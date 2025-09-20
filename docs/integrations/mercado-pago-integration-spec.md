# Mercado Pago Integration Specification

**Integration ID:** INT-MP-001  
**Service:** Mercado Pago Payment Gateway  
**Priority:** Critical (P0)  
**Mexican Market Compliance:** Yes  
**PCI DSS Compliance:** Through Provider  

## Overview

Mercado Pago integration enables ReparagymStore to accept payments through Mexico's leading payment platform, supporting credit/debit cards, SPEI bank transfers, and OXXO cash payments. This integration is critical for the Mexican market as Mercado Pago has 87% recognition among the target demographic.

## Business Requirements

### Payment Methods Support
- **Credit Cards:** Visa, Mastercard, American Express
- **Debit Cards:** Mexican bank debit cards
- **Bank Transfers:** SPEI (Sistema de Pagos Electrónicos Interbancarios)
- **Cash Payments:** OXXO convenience store payments (optional)
- **Installments:** Up to 12 monthly payments for credit cards

### Market Requirements
- Mexican peso (MXN) as primary currency
- USD conversion support for international suppliers
- Mexican tax calculation (IVA 16%)
- Local customer behavior adaptation (installment preferences)

## Technical Architecture

### Authentication & Security
```typescript
interface MercadoPagoConfig {
  accessToken: string;        // Server-side secret token
  publicKey: string;          // Client-side public key
  webhookSecret: string;      // Webhook signature validation
  environment: 'sandbox' | 'production';
  locale: 'es-MX';
  currency: 'MXN';
}

const mpConfig: MercadoPagoConfig = {
  accessToken: process.env.MP_ACCESS_TOKEN,
  publicKey: process.env.MP_PUBLIC_KEY,
  webhookSecret: process.env.MP_WEBHOOK_SECRET,
  environment: process.env.NODE_ENV === 'production' ? 'production' : 'sandbox',
  locale: 'es-MX',
  currency: 'MXN'
};
```

### Payment Flow Architecture
```typescript
interface PaymentFlow {
  // 1. Create Payment Preference
  createPreference(orderData: OrderData): Promise<PreferenceResponse>;
  
  // 2. Process Payment
  processPayment(paymentData: PaymentData): Promise<PaymentResponse>;
  
  // 3. Handle Webhook
  handleWebhook(webhookPayload: WebhookPayload): Promise<void>;
  
  // 4. Verify Payment
  verifyPayment(paymentId: string): Promise<PaymentStatus>;
}
```

## API Integration Details

### 1. Payment Preference Creation
**Endpoint:** `POST https://api.mercadopago.com/checkout/preferences`

```typescript
interface CreatePreferenceRequest {
  items: Array<{
    id: string;
    title: string;
    description: string;
    quantity: number;
    currency_id: string;
    unit_price: number;
  }>;
  payer: {
    name: string;
    surname: string;
    email: string;
    phone: {
      area_code: string;
      number: string;
    };
    identification: {
      type: string;
      number: string;
    };
    address: {
      street_name: string;
      street_number: string;
      zip_code: string;
    };
  };
  back_urls: {
    success: string;
    failure: string;
    pending: string;
  };
  auto_return: 'approved' | 'all';
  payment_methods: {
    excluded_payment_methods: Array<{ id: string }>;
    excluded_payment_types: Array<{ id: string }>;
    installments: number;
  };
  notification_url: string;
  external_reference: string; // Our order ID
  expires: boolean;
  expiration_date_from?: string;
  expiration_date_to?: string;
}

// Implementation
async function createPaymentPreference(order: Order): Promise<string> {
  const preference: CreatePreferenceRequest = {
    items: order.items.map(item => ({
      id: item.variant_id,
      title: item.title,
      description: item.description || '',
      quantity: item.quantity,
      currency_id: 'MXN',
      unit_price: item.unit_price
    })),
    payer: {
      name: order.customer.first_name,
      surname: order.customer.last_name,
      email: order.customer.email,
      phone: {
        area_code: '52',
        number: order.customer.phone
      },
      identification: {
        type: 'RFC', // Mexican tax ID
        number: order.customer.company_name || 'XAXX010101000'
      },
      address: {
        street_name: order.shipping_address.address_1,
        street_number: '1',
        zip_code: order.shipping_address.postal_code
      }
    },
    back_urls: {
      success: `${process.env.FRONTEND_URL}/checkout/success`,
      failure: `${process.env.FRONTEND_URL}/checkout/failure`,
      pending: `${process.env.FRONTEND_URL}/checkout/pending`
    },
    auto_return: 'approved',
    payment_methods: {
      excluded_payment_methods: [],
      excluded_payment_types: [],
      installments: 12
    },
    notification_url: `${process.env.BACKEND_URL}/webhook/mercado-pago`,
    external_reference: order.id,
    expires: true,
    expiration_date_to: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString() // 24 hours
  };

  const response = await fetch('https://api.mercadopago.com/checkout/preferences', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${mpConfig.accessToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(preference)
  });

  const result = await response.json();
  return result.init_point; // Redirect URL for payment
}
```

### 2. Webhook Handling
**Endpoint:** `POST /webhook/mercado-pago`

```typescript
interface WebhookPayload {
  id: number;
  live_mode: boolean;
  type: 'payment' | 'merchant_order';
  date_created: string;
  application_id: number;
  user_id: number;
  version: number;
  api_version: string;
  action: 'payment.created' | 'payment.updated';
  data: {
    id: string;
  };
}

async function handleMercadoPagoWebhook(req: Request, res: Response) {
  try {
    // Verify webhook signature
    const signature = req.headers['x-signature'] as string;
    const requestId = req.headers['x-request-id'] as string;
    
    if (!verifyWebhookSignature(req.body, signature, requestId)) {
      return res.status(401).json({ error: 'Invalid signature' });
    }

    const payload: WebhookPayload = req.body;
    
    if (payload.type === 'payment') {
      await processPaymentWebhook(payload.data.id);
    }
    
    res.status(200).json({ status: 'processed' });
  } catch (error) {
    console.error('Webhook processing error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function processPaymentWebhook(paymentId: string) {
  // Get payment details from Mercado Pago
  const paymentResponse = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
    headers: {
      'Authorization': `Bearer ${mpConfig.accessToken}`
    }
  });
  
  const payment = await paymentResponse.json();
  const orderId = payment.external_reference;
  
  // Update order status based on payment status
  switch (payment.status) {
    case 'approved':
      await updateOrderStatus(orderId, 'paid');
      await sendOrderConfirmation(orderId);
      break;
      
    case 'pending':
      await updateOrderStatus(orderId, 'pending_payment');
      break;
      
    case 'rejected':
    case 'cancelled':
      await updateOrderStatus(orderId, 'cancelled');
      await handlePaymentFailure(orderId, payment.status_detail);
      break;
  }
}
```

### 3. Payment Status Verification
```typescript
interface PaymentStatus {
  id: string;
  status: 'pending' | 'approved' | 'authorized' | 'in_process' | 'in_mediation' | 'rejected' | 'cancelled' | 'refunded' | 'charged_back';
  status_detail: string;
  operation_type: string;
  currency_id: string;
  transaction_amount: number;
  date_created: string;
  date_last_updated: string;
  external_reference: string;
  payer: {
    email: string;
    identification: {
      type: string;
      number: string;
    };
  };
  payment_method: {
    id: string;
    type: string;
    issuer_id: string;
  };
  installments: number;
  transaction_details: {
    net_received_amount: number;
    total_paid_amount: number;
    installment_amount: number;
  };
}

async function verifyPaymentStatus(paymentId: string): Promise<PaymentStatus> {
  const response = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
    headers: {
      'Authorization': `Bearer ${mpConfig.accessToken}`
    }
  });
  
  if (!response.ok) {
    throw new Error(`Payment verification failed: ${response.statusText}`);
  }
  
  return await response.json();
}
```

## Error Handling & Retry Logic

### Common Error Scenarios
```typescript
interface ErrorHandling {
  // Network timeouts
  timeout: 30000; // 30 seconds
  
  // Retry configuration
  retries: {
    maxAttempts: 3;
    backoffMultiplier: 2;
    initialDelay: 1000; // 1 second
  };
  
  // Error mapping
  errorMappings: {
    'cc_rejected_insufficient_amount': 'Fondos insuficientes';
    'cc_rejected_bad_filled_card_number': 'Número de tarjeta inválido';
    'cc_rejected_bad_filled_date': 'Fecha de vencimiento inválida';
    'cc_rejected_bad_filled_security_code': 'Código de seguridad inválido';
    'cc_rejected_high_risk': 'Pago rechazado por seguridad';
  };
}

async function processPaymentWithRetry(paymentData: any, attempt = 1): Promise<any> {
  try {
    return await processPayment(paymentData);
  } catch (error) {
    if (attempt < 3 && isRetryableError(error)) {
      const delay = 1000 * Math.pow(2, attempt - 1);
      await new Promise(resolve => setTimeout(resolve, delay));
      return processPaymentWithRetry(paymentData, attempt + 1);
    }
    throw error;
  }
}

function isRetryableError(error: any): boolean {
  return [
    'network_timeout',
    'internal_server_error',
    'service_unavailable'
  ].includes(error.cause);
}
```

## Security Implementation

### Webhook Signature Verification
```typescript
import crypto from 'crypto';

function verifyWebhookSignature(
  payload: string,
  signature: string,
  requestId: string
): boolean {
  const [tsHeader, v1Header] = signature.split(',');
  const timestamp = tsHeader.split('=')[1];
  const v1Signature = v1Header.split('=')[1];
  
  // Create expected signature
  const dataToSign = `id:${requestId};request-id:${requestId};ts:${timestamp};`;
  const expectedSignature = crypto
    .createHmac('sha256', mpConfig.webhookSecret)
    .update(dataToSign)
    .digest('hex');
  
  // Compare signatures
  return crypto.timingSafeEqual(
    Buffer.from(v1Signature, 'hex'),
    Buffer.from(expectedSignature, 'hex')
  );
}
```

### PCI DSS Compliance
- Never store credit card information
- Use Mercado Pago's secure tokenization
- Implement proper SSL/TLS encryption
- Regular security audits and penetration testing

## Mexican Market Specific Features

### SPEI Bank Transfer Integration
```typescript
interface SPEIPayment {
  payment_method_id: 'bank_transfer';
  transaction_amount: number;
  description: string;
  external_reference: string;
  payer: {
    email: string;
    entity_type: 'individual' | 'association';
  };
}

async function createSPEIPayment(orderData: OrderData): Promise<SPEIResponse> {
  const payment: SPEIPayment = {
    payment_method_id: 'bank_transfer',
    transaction_amount: orderData.total,
    description: `Pedido ReparagymStore #${orderData.display_id}`,
    external_reference: orderData.id,
    payer: {
      email: orderData.customer.email,
      entity_type: 'association' // Business customers
    }
  };
  
  const response = await fetch('https://api.mercadopago.com/v1/payments', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${mpConfig.accessToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payment)
  });
  
  return await response.json();
}
```

### OXXO Cash Payment (Optional)
```typescript
interface OXXOPayment {
  payment_method_id: 'oxxo';
  transaction_amount: number;
  description: string;
  payer: {
    email: string;
    first_name: string;
    last_name: string;
  };
}
```

## Testing Strategy

### Test Environment Setup
```typescript
const testConfig = {
  accessToken: 'TEST-ACCESS-TOKEN',
  publicKey: 'TEST-PUBLIC-KEY',
  webhookSecret: 'TEST-WEBHOOK-SECRET',
  environment: 'sandbox'
};

// Test cards for different scenarios
const testCards = {
  approved: '4170068810108020',
  insufficient_funds: '4013540682746260',
  expired: '4444333322221111',
  security_code_error: '4000000000000127'
};
```

### Integration Tests
```typescript
describe('Mercado Pago Integration', () => {
  test('should create payment preference successfully', async () => {
    const order = createTestOrder();
    const preferenceUrl = await createPaymentPreference(order);
    expect(preferenceUrl).toMatch(/https:\/\/www\.mercadopago\.com/);
  });
  
  test('should handle approved payment webhook', async () => {
    const webhook = createTestWebhook('approved');
    await handleMercadoPagoWebhook(webhook);
    const order = await getOrder(webhook.external_reference);
    expect(order.status).toBe('paid');
  });
  
  test('should handle rejected payment webhook', async () => {
    const webhook = createTestWebhook('rejected');
    await handleMercadoPagoWebhook(webhook);
    const order = await getOrder(webhook.external_reference);
    expect(order.status).toBe('cancelled');
  });
});
```

## Monitoring & Analytics

### Key Metrics to Track
- Payment success rate by method
- Average payment processing time
- Failed payment reasons and frequency
- Fraud detection alerts
- Revenue by payment method

### Monitoring Implementation
```typescript
interface PaymentMetrics {
  trackPaymentAttempt(method: string, amount: number): void;
  trackPaymentSuccess(method: string, amount: number, processingTime: number): void;
  trackPaymentFailure(method: string, reason: string, amount: number): void;
  trackRefund(paymentId: string, amount: number, reason: string): void;
}

// Example monitoring
function trackPaymentEvent(event: string, data: any) {
  analytics.track('payment_' + event, {
    ...data,
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV
  });
}
```

## Deployment Configuration

### Environment Variables
```bash
# Production
MP_ACCESS_TOKEN=APP_USR-production-token
MP_PUBLIC_KEY=APP_USR-production-public-key
MP_WEBHOOK_SECRET=production-webhook-secret

# Staging
MP_ACCESS_TOKEN=TEST-staging-token
MP_PUBLIC_KEY=TEST-staging-public-key
MP_WEBHOOK_SECRET=staging-webhook-secret
```

### Rate Limiting
- API calls: 500 requests per minute
- Webhook processing: Queue-based with retry logic
- Payment verification: Cached for 5 minutes

## Compliance & Legal

### Mexican Financial Regulations
- CNBV (Comisión Nacional Bancaria y de Valores) compliance
- Anti-money laundering (AML) reporting
- Customer identification requirements
- Transaction record keeping (7 years)

### Data Protection
- Mexican Federal Law on Protection of Personal Data (LFPDPPP)
- PCI DSS Level 1 compliance through Mercado Pago
- Secure data transmission and storage
- Customer consent for payment processing

---

**Integration Owner:** Payments Team  
**Stakeholders:** Finance, Compliance, Security  
**Review Frequency:** Quarterly  
**Last Security Audit:** September 20, 2025