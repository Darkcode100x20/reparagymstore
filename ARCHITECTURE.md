# ReparagymStore System Architecture
## Comprehensive Technical Architecture Document

**Prepared by:** Winston, Architect Agent (BMAD-METHOD)  
**Date:** September 20, 2025  
**Project:** Gym Equipment Parts E-commerce Platform - Mexico MVP  
**Version:** 1.0  

---

## 1. System Overview & Architecture Principles

### 1.1 Executive Summary

ReparagymStore's architecture follows a modern, scalable microservices approach built on proven technologies. The system is designed to handle the Mexican gym equipment parts market requirements with emphasis on performance, reliability, and cultural adaptation.

### 1.2 Core Architecture Principles

**Performance First:**
- Target TTFB < 500ms globally
- LCP < 2.5s on 3G networks
- Search response time < 200ms
- 99.9% uptime SLA

**Security & Compliance:**
- PCI DSS compliance for payment processing
- Mexican data residency compliance
- GDPR-ready data handling
- End-to-end encryption

**Scalability & Maintainability:**
- Horizontal scaling capabilities
- Modular service architecture
- Infrastructure as Code (IaC)
- Automated testing and deployment

**Cultural & Market Adaptation:**
- Spanish language first-class support
- WhatsApp Business API integration
- Mexican payment methods (SPEI, OXXO)
- Mobile-first responsive design

---

## 2. High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT TIER                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Web Browser   │  │  Mobile Apps    │  │  WhatsApp Bot   │  │
│  │   (Next.js)     │  │   (PWA)         │  │  (Business API) │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                         ┌──────▼──────┐
                         │ Load Balancer│
                         │   (Vercel)   │
                         └──────┬──────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                    APPLICATION TIER                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │  Storefront     │  │   Admin Panel   │  │  API Gateway    │  │
│  │  (Next.js)      │  │   (Medusa)      │  │  (Medusa Core)  │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
│                                │                                │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │  Search Service │  │ Payment Service │  │ Shipping Service│  │
│  │ (MeiliSearch)   │  │ (Mercado Pago)  │  │  (Multi-carrier)│  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                      DATA TIER                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   PostgreSQL    │  │      Redis      │  │   File Storage  │  │
│  │  (Primary DB)   │  │  (Cache/Queue)  │  │   (Images/PDFs) │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Frontend Architecture (Next.js Storefront)

### 3.1 Technology Stack
- **Framework:** Next.js 14+ (App Router)
- **Styling:** Tailwind CSS 3.4+
- **State Management:** Zustand + React Query
- **Forms:** React Hook Form + Zod validation
- **Internationalization:** next-intl
- **Analytics:** Vercel Analytics + Google Analytics 4

### 3.2 Application Structure
```
src/
├── app/                     # App Router pages
│   ├── (storefront)/       # Customer-facing pages
│   ├── admin/              # Admin interface (if needed)
│   └── api/                # API routes and webhooks
├── components/             # Reusable UI components
│   ├── ui/                 # Base UI components
│   ├── layout/             # Layout components
│   ├── product/            # Product-specific components
│   └── checkout/           # Checkout flow components
├── lib/                    # Utility functions and configs
│   ├── medusa.ts          # Medusa client configuration
│   ├── meilisearch.ts     # Search client
│   └── validation.ts      # Zod schemas
├── hooks/                  # Custom React hooks
├── stores/                 # Zustand stores
└── types/                  # TypeScript type definitions
```

### 3.3 Performance Optimizations
- **Image Optimization:** Next.js Image component with WebP format
- **Code Splitting:** Dynamic imports for heavy components
- **Caching Strategy:** SWR for API calls, ISR for product pages
- **Bundle Analysis:** Continuous bundle size monitoring
- **Critical CSS:** Inline critical styles, defer non-critical

### 3.4 Mobile-First Design
- **Responsive Breakpoints:** 320px, 768px, 1024px, 1280px
- **Touch Interactions:** Optimized tap targets (44px minimum)
- **Progressive Web App:** Service worker for offline functionality
- **Network Awareness:** Adaptive loading based on connection speed

---

## 4. Backend Architecture (Medusa.js Core)

### 4.1 Medusa.js Configuration
- **Version:** Medusa 2.0+
- **Runtime:** Node.js 18+ with TypeScript
- **Architecture:** Plugin-based modular system
- **API Style:** RESTful with GraphQL support

### 4.2 Custom Plugins and Services

**Core Customizations:**
```typescript
// Custom services structure
src/
├── services/              # Business logic services
│   ├── product-search.ts  # MeiliSearch integration
│   ├── shipping-rates.ts  # Multi-carrier shipping
│   ├── whatsapp.ts       # WhatsApp Business API
│   └── inventory.ts      # Inventory management
├── plugins/              # Custom Medusa plugins
│   ├── meilisearch/      # Search plugin
│   ├── mercado-pago/     # Payment plugin
│   └── multi-shipping/   # Shipping plugin
├── workflows/            # Business process workflows
│   ├── order-fulfillment/
│   ├── inventory-sync/
│   └── whatsapp-orders/
└── models/              # Extended data models
    ├── product-guide.ts
    ├── shipping-zone.ts
    └── whatsapp-order.ts
```

**Custom Data Models Extensions:**
```typescript
// Enhanced Product model
export class Product extends MedusaProduct {
  brand_id: string
  machine_type_id: string
  compatibility_tags: string[]
  technical_specs: Record<string, any>
  installation_guides: Guide[]
  weight_kg: number
  dimensions_cm: [number, number, number] // L, W, H
}

// Enhanced ProductVariant model
export class ProductVariant extends MedusaProductVariant {
  sku_barcode?: string
  attributes: Record<string, any>
  spanish_title: string
  spanish_description: string
}
```

### 4.3 API Architecture

**Core Endpoints:**
```
GET    /store/products                 # Product catalog with search
GET    /store/products/:id             # Product details
GET    /store/search                   # MeiliSearch proxy
POST   /store/carts                    # Cart management
GET    /store/shipping-options         # Real-time shipping rates
POST   /store/payments                 # Mercado Pago integration
POST   /webhook/whatsapp              # WhatsApp webhook handler
GET    /store/guides/:id              # Product guide downloads
```

**Custom Middleware:**
- Request logging and analytics
- Rate limiting (100 req/min per IP)
- Spanish language content negotiation
- Currency conversion (USD ↔ MXN)
- Geolocation-based shipping zones

---

## 5. Database Design (PostgreSQL)

### 5.1 Schema Extensions

**Core Medusa Tables Enhanced:**
```sql
-- Extended product table
ALTER TABLE product ADD COLUMN brand_id UUID REFERENCES brand(id);
ALTER TABLE product ADD COLUMN machine_type_id UUID REFERENCES machine_type(id);
ALTER TABLE product ADD COLUMN compatibility_tags TEXT[];
ALTER TABLE product ADD COLUMN weight_kg DECIMAL(8,2);
ALTER TABLE product ADD COLUMN dimensions_cm INTEGER[3];

-- Extended product_variant table
ALTER TABLE product_variant ADD COLUMN sku_barcode VARCHAR(50);
ALTER TABLE product_variant ADD COLUMN attributes JSONB;
ALTER TABLE product_variant ADD COLUMN spanish_title VARCHAR(255);
ALTER TABLE product_variant ADD COLUMN spanish_description TEXT;
```

**Custom Tables:**
```sql
-- Brand management
CREATE TABLE brand (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo_url VARCHAR(500),
    description TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Machine type taxonomy
CREATE TABLE machine_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    parent_id UUID REFERENCES machine_type(id),
    description TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- Product installation guides
CREATE TABLE product_guide (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES product(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(10) DEFAULT 'pdf',
    language VARCHAR(5) DEFAULT 'es',
    version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT now()
);

-- WhatsApp orders tracking
CREATE TABLE whatsapp_order (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100),
    product_requests TEXT NOT NULL,
    order_id UUID REFERENCES "order"(id),
    status VARCHAR(20) DEFAULT 'pending',
    agent_notes TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Shipping zones for Mexico
CREATE TABLE shipping_zone (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    postal_codes TEXT[], -- Array of postal code patterns
    state_codes TEXT[], -- Mexican state codes
    carriers TEXT[], -- Available carriers for this zone
    base_rate DECIMAL(8,2),
    created_at TIMESTAMP DEFAULT now()
);
```

### 5.2 Indexing Strategy

**Performance Indexes:**
```sql
-- Product search optimization
CREATE INDEX idx_product_search ON product USING gin(
    to_tsvector('spanish', title || ' ' || description)
);

-- SKU lookup optimization
CREATE UNIQUE INDEX idx_variant_sku ON product_variant(sku);
CREATE INDEX idx_variant_barcode ON product_variant(sku_barcode);

-- Category navigation
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_machine_type ON product(machine_type_id);

-- Inventory queries
CREATE INDEX idx_variant_inventory ON product_variant(inventory_quantity);

-- Order fulfillment
CREATE INDEX idx_order_status_date ON "order"(status, created_at);
CREATE INDEX idx_whatsapp_status ON whatsapp_order(status, created_at);
```

### 5.3 Data Relationships

```mermaid
erDiagram
    BRAND ||--o{ PRODUCT : has
    MACHINE_TYPE ||--o{ PRODUCT : categorizes
    PRODUCT ||--o{ PRODUCT_VARIANT : contains
    PRODUCT ||--o{ PRODUCT_GUIDE : includes
    PRODUCT_VARIANT ||--o{ LINE_ITEM : ordered
    ORDER ||--o{ LINE_ITEM : contains
    ORDER ||--o| WHATSAPP_ORDER : may_have
    SHIPPING_ZONE ||--o{ ORDER : ships_to
```

---

## 6. Search Architecture (MeiliSearch)

### 6.1 Search Index Configuration

**Primary Product Index:**
```json
{
  "indexUid": "products",
  "primaryKey": "id",
  "searchableAttributes": [
    "title",
    "spanish_title",
    "sku",
    "brand_name",
    "machine_type_name",
    "compatibility_tags",
    "attributes_flat"
  ],
  "filterableAttributes": [
    "brand_id",
    "machine_type_id",
    "price_range",
    "in_stock",
    "has_guide"
  ],
  "sortableAttributes": [
    "price",
    "created_at",
    "popularity_score"
  ],
  "rankingRules": [
    "words",
    "typo",
    "proximity",
    "attribute",
    "sort",
    "exactness"
  ],
  "distinctAttribute": null,
  "displayedAttributes": ["*"],
  "stopWords": ["de", "la", "el", "en", "para", "con"],
  "synonyms": {
    "mancuerna": ["dumbbell", "pesa"],
    "rodamiento": ["balero", "bearing"],
    "banda": ["belt", "correa"],
    "cable": ["alambre", "wire"]
  }
}
```

### 6.2 Search Document Structure

**Indexed Product Document:**
```typescript
interface ProductSearchDocument {
  id: string;
  title: string;
  spanish_title: string;
  sku: string;
  brand_name: string;
  brand_id: string;
  machine_type_name: string;
  machine_type_id: string;
  compatibility_tags: string[];
  attributes_flat: string; // Flattened searchable attributes
  price: number;
  price_range: string; // "0-100", "100-500", etc.
  in_stock: boolean;
  has_guide: boolean;
  popularity_score: number;
  created_at: string;
  thumbnail_url?: string;
}
```

### 6.3 Search Features Implementation

**Typo Tolerance Configuration:**
```json
{
  "typoTolerance": {
    "enabled": true,
    "minWordSizeForTypos": {
      "oneTypo": 5,
      "twoTypos": 9
    },
    "disableOnWords": ["SKU", "OEM"],
    "disableOnAttributes": ["sku"]
  }
}
```

**Faceted Search Implementation:**
- Brand filtering with counts
- Machine type hierarchical filtering  
- Price range buckets
- Availability status
- Guide availability

**Spanish Language Optimization:**
- Custom tokenization rules
- Accent-insensitive search
- Spanish stop words
- Technical terminology dictionary

---

## 7. Payment Integration Architecture (Mercado Pago)

### 7.1 Payment Flow Architecture

```mermaid
sequenceDiagram
    participant C as Customer
    participant S as Storefront
    participant M as Medusa API
    participant MP as Mercado Pago
    participant WH as Webhook Handler

    C->>S: Initiate Checkout
    S->>M: Create Payment Intent
    M->>MP: Create Preference
    MP-->>M: Return Preference ID
    M-->>S: Return Payment URL
    S->>C: Redirect to MP Checkout
    C->>MP: Complete Payment
    MP->>WH: Send Webhook
    WH->>M: Update Order Status
    M->>S: Notify Payment Success
    S->>C: Display Confirmation
```

### 7.2 Payment Methods Configuration

**Mercado Pago Integration:**
```typescript
// Payment provider configuration
export const mercadoPagoConfig = {
  accessToken: process.env.MP_ACCESS_TOKEN,
  publicKey: process.env.MP_PUBLIC_KEY,
  webhookSecret: process.env.MP_WEBHOOK_SECRET,
  
  // Mexican payment methods
  paymentMethods: {
    creditCard: {
      enabled: true,
      installments: 12, // Up to 12 installments
      minAmount: 100 // Minimum 100 MXN
    },
    debitCard: {
      enabled: true,
      installments: 1
    },
    spei: {
      enabled: true,
      expirationDays: 3
    },
    oxxo: {
      enabled: true,
      expirationDays: 3,
      minAmount: 50,
      maxAmount: 10000
    }
  },
  
  // Webhook configuration
  webhook: {
    url: "https://api.reparagymstore.com/webhook/mercado-pago",
    events: ["payment.created", "payment.updated"]
  }
};
```

### 7.3 Security Implementation

**PCI DSS Compliance:**
- Never store card data on our servers
- All payment processing through Mercado Pago
- Encrypted transmission using TLS 1.3
- Regular security scans and compliance audits

**Fraud Prevention:**
- Velocity checking on order frequency
- Geolocation validation for shipping addresses
- Device fingerprinting integration
- Manual review for high-value orders

---

## 8. Shipping Integration Architecture

### 8.1 Multi-Carrier Integration Design

**Shipping Provider Abstraction:**
```typescript
interface ShippingProvider {
  getRates(params: RateRequest): Promise<ShippingRate[]>;
  createShipment(params: ShipmentRequest): Promise<Shipment>;
  trackShipment(trackingNumber: string): Promise<TrackingInfo>;
  validateAddress(address: Address): Promise<AddressValidation>;
}

// Implemented providers
class FedExProvider implements ShippingProvider { }
class UPSProvider implements ShippingProvider { }
class EstafetaProvider implements ShippingProvider { }
class TieredRateProvider implements ShippingProvider { } // Fallback
```

### 8.2 Rate Calculation Logic

**Shipping Zone Strategy:**
```typescript
export const shippingZones = {
  "metropolitan": {
    states: ["CDMX", "MEX"],
    carriers: ["fedex", "ups", "estafeta"],
    sameDay: true,
    baseRate: 120
  },
  "northern": {
    states: ["NL", "CHH", "COAH", "TAMPS"],
    carriers: ["fedex", "ups"],
    sameDay: false,
    baseRate: 180
  },
  "southern": {
    states: ["OAX", "CHIS", "CAM", "QROO"],
    carriers: ["estafeta", "ups"],
    sameDay: false,
    baseRate: 220
  }
  // ... more zones
};
```

**Rate Calculation Algorithm:**
1. Determine shipping zone from postal code
2. Calculate dimensional weight vs actual weight
3. Query available carriers for zone
4. Apply size/weight surcharges
5. Add handling fees and insurance
6. Return sorted options (speed/price)

### 8.3 Tracking Integration

**Unified Tracking Interface:**
```typescript
interface TrackingUpdate {
  trackingNumber: string;
  carrier: string;
  status: 'pending' | 'in_transit' | 'delivered' | 'exception';
  location: string;
  timestamp: Date;
  description: string;
}

// Webhook handlers for each carrier
app.post('/webhook/fedex-tracking', handleFedExTracking);
app.post('/webhook/ups-tracking', handleUPSTracking);
app.post('/webhook/estafeta-tracking', handleEstafetaTracking);
```

---

## 9. WhatsApp Integration Architecture

### 9.1 WhatsApp Business API Integration

**Architecture Flow:**
```mermaid
graph TD
    A[Customer WhatsApp] --> B[WhatsApp Business API]
    B --> C[Webhook Handler]
    C --> D[Message Router]
    D --> E[Order Processing Service]
    D --> F[Support Ticket System]
    E --> G[Medusa Order Creation]
    F --> H[Agent Dashboard]
    G --> I[Payment Link Generation]
    I --> J[Customer Notification]
```

### 9.2 Message Processing Pipeline

**Webhook Handler:**
```typescript
export async function handleWhatsAppWebhook(req: Request, res: Response) {
  const { messages, contacts } = req.body;
  
  for (const message of messages) {
    const conversation = await getOrCreateConversation(message.from);
    
    // Route based on message type and conversation state
    switch (conversation.state) {
      case 'initial':
        await handleInitialInquiry(message, conversation);
        break;
      case 'product_selection':
        await handleProductSelection(message, conversation);
        break;
      case 'collecting_info':
        await handleInfoCollection(message, conversation);
        break;
      case 'order_confirmation':
        await handleOrderConfirmation(message, conversation);
        break;
    }
  }
  
  res.status(200).json({ status: 'processed' });
}
```

### 9.3 Order Creation Workflow

**WhatsApp to Medusa Order Flow:**
```typescript
interface WhatsAppOrderData {
  phoneNumber: string;
  customerName: string;
  productRequests: ProductRequest[];
  shippingAddress: Address;
  notes: string;
}

async function createOrderFromWhatsApp(data: WhatsAppOrderData) {
  // 1. Create or find customer
  const customer = await findOrCreateCustomer({
    phone: data.phoneNumber,
    first_name: data.customerName
  });
  
  // 2. Create draft order in Medusa
  const order = await medusaService.orders.create({
    customer_id: customer.id,
    region_id: mexicoRegionId,
    items: data.productRequests.map(req => ({
      variant_id: req.variantId,
      quantity: req.quantity
    })),
    shipping_address: data.shippingAddress
  });
  
  // 3. Generate payment link
  const paymentLink = await generateMercadoPagoLink(order);
  
  // 4. Send payment link via WhatsApp
  await sendWhatsAppMessage(data.phoneNumber, {
    type: 'template',
    template: 'payment_link',
    parameters: [order.id, paymentLink, order.total]
  });
  
  return order;
}
```

---

## 10. Infrastructure Architecture

### 10.1 Deployment Strategy

**Multi-Environment Setup:**
```yaml
# Production Environment
production:
  frontend:
    platform: vercel
    domain: reparagymstore.com
    regions: [cdg1, iad1] # Paris, Northern Virginia
    
  backend:
    platform: railway
    regions: [us-west-1]
    scaling: auto (1-5 instances)
    
  database:
    provider: neon
    region: us-west-2
    backup: daily
    
  search:
    provider: digital_ocean
    region: nyc3
    instances: 1 (upgrade to 3 for HA)

# Staging Environment  
staging:
  frontend: vercel-preview
  backend: railway-staging
  database: neon-staging
  search: docker-compose
```

### 10.2 CDN and Caching Strategy

**Content Delivery Network:**
- Vercel Edge Network for static assets
- Cloudflare for additional DDoS protection
- Image optimization and WebP conversion
- Geolocation-based content serving

**Caching Layers:**
```typescript
// Multi-layer caching strategy
export const cachingStrategy = {
  // Level 1: Browser cache
  browser: {
    static: '1y', // CSS, JS, images
    api: '5m',    // API responses
    pages: '1h'   // Static pages
  },
  
  // Level 2: CDN cache  
  cdn: {
    static: '30d',
    api: '1m',
    pages: '6h'
  },
  
  // Level 3: Redis cache
  redis: {
    products: '1h',
    search: '30m',
    user_sessions: '24h',
    cart: '7d'
  },
  
  // Level 4: Database query cache
  postgres: {
    query_cache: '15m',
    connection_pool: 20
  }
};
```

### 10.3 Monitoring and Observability

**Monitoring Stack:**
```yaml
logging:
  provider: winston + logflare
  levels: [error, warn, info, debug]
  structured: true
  retention: 30d

metrics:
  application: custom prometheus metrics
  infrastructure: railway metrics
  frontend: vercel analytics
  real_user: google analytics 4

alerting:
  channels: [email, slack, whatsapp]
  thresholds:
    error_rate: 1%
    response_time: 2s
    uptime: 99.9%

tracing:
  provider: opentelemetry
  sampling: 10%
  endpoints: critical paths only
```

---

## 11. Security Architecture

### 11.1 Authentication and Authorization

**Authentication Strategy:**
```typescript
// JWT-based authentication with refresh tokens
export const authConfig = {
  access_token: {
    secret: process.env.JWT_SECRET,
    expiry: '15m',
    algorithm: 'HS256'
  },
  refresh_token: {
    secret: process.env.JWT_REFRESH_SECRET,
    expiry: '7d',
    algorithm: 'HS256'
  },
  password_policy: {
    min_length: 8,
    require_uppercase: true,
    require_numbers: true,
    require_symbols: false
  }
};

// Role-based access control
enum Role {
  CUSTOMER = 'customer',
  ADMIN = 'admin',
  SUPPORT = 'support',
  WAREHOUSE = 'warehouse'
}
```

### 11.2 Data Protection Strategy

**Encryption at Rest:**
- Database: AES-256 encryption
- File storage: Server-side encryption
- Backups: Encrypted with separate keys
- Secrets: Managed through environment variables

**Encryption in Transit:**
- TLS 1.3 for all HTTP traffic
- API authentication via Bearer tokens
- Webhook signature validation
- Certificate pinning for mobile apps

### 11.3 Compliance Framework

**Mexican Data Protection (LFPDPPP):**
- Explicit consent for data collection
- Data minimization principles
- Right to access and deletion
- Privacy notice in Spanish
- Data processing registry

**PCI DSS Requirements:**
- Never store card data
- Secure transmission protocols
- Regular security scans
- Access control restrictions
- Incident response plan

---

## 12. Performance Architecture

### 12.1 Frontend Performance Strategy

**Core Web Vitals Optimization:**
```typescript
// Performance targets
const performanceTargets = {
  FCP: 1.5, // First Contentful Paint
  LCP: 2.5, // Largest Contentful Paint
  FID: 100, // First Input Delay (ms)
  CLS: 0.1, // Cumulative Layout Shift
  TTFB: 500 // Time to First Byte (ms)
};

// Optimization techniques
const optimizations = {
  images: {
    format: 'webp-with-fallback',
    lazy_loading: true,
    responsive_sizing: true,
    compression: 80
  },
  code_splitting: {
    route_based: true,
    component_based: true,
    vendor_chunks: true
  },
  critical_css: {
    inline: true,
    defer_non_critical: true
  }
};
```

### 12.2 Backend Performance Strategy

**API Performance Optimization:**
```typescript
// Response time targets
const apiTargets = {
  product_list: 200, // ms
  product_detail: 150,
  search: 100,
  cart_operations: 300,
  checkout: 500
};

// Database optimization
const dbOptimization = {
  connection_pooling: {
    min: 5,
    max: 20,
    idle_timeout: 30000
  },
  query_optimization: {
    indexing: 'comprehensive',
    explain_analyze: true,
    slow_query_log: true
  },
  caching: {
    query_cache: 'redis',
    ttl: 900 // 15 minutes
  }
};
```

### 12.3 Search Performance

**MeiliSearch Optimization:**
```typescript
const searchOptimization = {
  indexing: {
    batch_size: 1000,
    update_frequency: 'realtime',
    memory_allocation: '2GB'
  },
  search_performance: {
    target_response: 50, // ms
    typo_tolerance: 2,
    max_results: 100,
    facet_distribution: true
  }
};
```

---

## 13. API Design Specifications

### 13.1 RESTful API Standards

**API Versioning Strategy:**
```
https://api.reparagymstore.com/v1/store/products
https://api.reparagymstore.com/v1/admin/orders
```

**Standard Response Format:**
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    pagination?: PaginationMeta;
    search?: SearchMeta;
  };
}
```

### 13.2 Core API Endpoints

**Product Catalog API:**
```typescript
// GET /store/products
interface ProductListParams {
  page?: number;
  limit?: number;
  brand_id?: string;
  machine_type_id?: string;
  q?: string; // Search query
  price_min?: number;
  price_max?: number;
  in_stock?: boolean;
}

// GET /store/products/:id
interface ProductResponse {
  id: string;
  title: string;
  description: string;
  brand: Brand;
  machine_type: MachineType;
  variants: ProductVariant[];
  guides: ProductGuide[];
  images: ProductImage[];
  compatibility_tags: string[];
}
```

**Search API:**
```typescript
// GET /store/search
interface SearchParams {
  q: string;
  filters?: Record<string, string[]>;
  facets?: string[];
  limit?: number;
  offset?: number;
}

interface SearchResponse {
  hits: ProductSearchDocument[];
  totalHits: number;
  query: string;
  processingTimeMs: number;
  facetDistribution?: Record<string, Record<string, number>>;
}
```

### 13.3 Webhook Specifications

**Mercado Pago Webhook:**
```typescript
interface MercadoPagoWebhook {
  id: number;
  type: 'payment' | 'merchant_order';
  action: 'created' | 'updated';
  api_version: string;
  data: {
    id: string;
  };
  date_created: string;
  user_id: number;
}
```

**WhatsApp Webhook:**
```typescript
interface WhatsAppWebhook {
  object: 'whatsapp_business_account';
  entry: Array<{
    id: string;
    changes: Array<{
      field: 'messages';
      value: {
        messaging_product: 'whatsapp';
        metadata: any;
        contacts?: Contact[];
        messages?: Message[];
        statuses?: Status[];
      };
    }>;
  }>;
}
```

---

## 14. Data Flow Diagrams

### 14.1 Customer Purchase Journey

```mermaid
flowchart TD
    A[Customer arrives] --> B{Logged in?}
    B -->|No| C[Browse as guest]
    B -->|Yes| D[Browse with account]
    
    C --> E[Product search]
    D --> E
    
    E --> F[Product detail view]
    F --> G[Add to cart]
    G --> H{Ready to checkout?}
    
    H -->|No| E
    H -->|Yes| I[Checkout process]
    
    I --> J{Account required?}
    J -->|Yes| K[Login/Register]
    J -->|No| L[Guest checkout]
    
    K --> M[Shipping info]
    L --> M
    
    M --> N[Shipping options]
    N --> O[Payment method]
    O --> P[Review order]
    P --> Q[Submit payment]
    
    Q --> R[Payment processing]
    R --> S{Payment success?}
    
    S -->|Yes| T[Order confirmation]
    S -->|No| U[Payment retry]
    
    U --> O
    T --> V[Fulfillment process]
    V --> W[Shipping notification]
    W --> X[Delivery tracking]
    X --> Y[Order completion]
```

### 14.2 WhatsApp Order Flow

```mermaid
sequenceDiagram
    participant C as Customer
    participant W as WhatsApp
    participant A as Agent
    participant S as System
    participant M as Medusa
    participant P as Payment

    C->>W: "Need help with [product]"
    W->>A: Webhook notification
    A->>C: "Hi! Let me help you find the right part"
    C->>A: Product description/photo
    A->>S: Search product catalog
    S-->>A: Product matches
    A->>C: "Here are the options: [products]"
    C->>A: "I want product X, quantity Y"
    A->>C: "Please provide your address"
    C->>A: Shipping address
    A->>M: Create draft order
    M-->>A: Order created
    A->>P: Generate payment link
    P-->>A: Payment URL
    A->>C: "Your order total is $X. Pay here: [link]"
    C->>P: Complete payment
    P->>M: Payment webhook
    M->>A: Order confirmed
    A->>C: "Payment received! Order #X confirmed"
```

---

## 15. Scalability Considerations

### 15.1 Horizontal Scaling Strategy

**Application Tier Scaling:**
```yaml
scaling_strategy:
  frontend:
    type: edge_deployment
    auto_scale: true
    max_regions: global
    
  backend:
    type: container_orchestration
    min_instances: 2
    max_instances: 10
    scale_triggers:
      - cpu_usage: 70%
      - memory_usage: 80%
      - response_time: 1s
      
  database:
    type: read_replicas
    master: 1
    replicas: 2
    connection_pooling: true
    
  search:
    type: cluster
    nodes: 3
    replication: 1
    sharding: by_product_category
```

### 15.2 Traffic Growth Projections

**Expected Load Growth:**
```typescript
const trafficProjections = {
  month_1: {
    daily_users: 100,
    orders_per_day: 3,
    page_views: 2000
  },
  month_6: {
    daily_users: 800,
    orders_per_day: 25,
    page_views: 15000
  },
  month_12: {
    daily_users: 2500,
    orders_per_day: 80,
    page_views: 50000
  }
};
```

### 15.3 Performance Bottleneck Prevention

**Proactive Optimization:**
- Database query optimization monitoring
- Cache hit ratio tracking
- API response time alerting
- Search performance monitoring
- Third-party API circuit breakers

---

## 16. Development Environment Setup

### 16.1 Local Development Stack

**Docker Compose Configuration:**
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: reparagymstore
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  meilisearch:
    image: getmeili/meilisearch:v1.4
    ports:
      - "7700:7700"
    environment:
      MEILI_MASTER_KEY: dev_master_key
    volumes:
      - meilisearch_data:/meili_data

  medusa-backend:
    build: ./backend
    ports:
      - "9000:9000"
    environment:
      DATABASE_URL: postgres://dev:dev123@postgres:5432/reparagymstore
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis

  nextjs-frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      NEXT_PUBLIC_MEDUSA_BACKEND_URL: http://localhost:9000
    depends_on:
      - medusa-backend

volumes:
  postgres_data:
  meilisearch_data:
```

### 16.2 Development Workflow

**Git Workflow:**
```
main
├── develop
├── feature/search-improvements
├── feature/whatsapp-integration
└── hotfix/payment-bug
```

**Development Commands:**
```bash
# Setup development environment
npm run dev:setup

# Start all services
npm run dev:start

# Run tests
npm run test
npm run test:e2e

# Database operations
npm run db:migrate
npm run db:seed

# Build and deploy
npm run build
npm run deploy:staging
npm run deploy:production
```

---

## 17. Deployment Strategy

### 17.1 CI/CD Pipeline

**GitHub Actions Workflow:**
```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          npm ci
          npm run test
          npm run test:e2e

  deploy-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Railway
        run: railway up --service backend

  deploy-frontend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Vercel
        run: vercel --prod

  post-deploy:
    needs: [deploy-backend, deploy-frontend]
    runs-on: ubuntu-latest
    steps:
      - name: Run smoke tests
        run: npm run test:smoke
      - name: Update search index
        run: npm run search:reindex
```

### 17.2 Environment Configuration

**Production Environment Variables:**
```bash
# Database
DATABASE_URL=postgresql://user:pass@host:5432/reparagymstore
REDIS_URL=redis://host:6379

# Medusa
MEDUSA_ADMIN_CORS=https://admin.reparagymstore.com
STORE_CORS=https://reparagymstore.com

# Search
MEILISEARCH_HOST=https://search.reparagymstore.com
MEILISEARCH_MASTER_KEY=prod_master_key

# Payments
MERCADO_PAGO_ACCESS_TOKEN=APP_USR-xxx
MERCADO_PAGO_PUBLIC_KEY=APP_USR-xxx
MERCADO_PAGO_WEBHOOK_SECRET=xxx

# Shipping
FEDEX_ACCOUNT_NUMBER=xxx
FEDEX_METER_NUMBER=xxx
UPS_ACCESS_LICENSE=xxx
ESTAFETA_USER=xxx

# WhatsApp
WHATSAPP_ACCESS_TOKEN=xxx
WHATSAPP_PHONE_NUMBER_ID=xxx
WHATSAPP_WEBHOOK_VERIFY_TOKEN=xxx

# Analytics
GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
VERCEL_ANALYTICS_ID=xxx
```

---

## 18. Conclusion and Implementation Roadmap

### 18.1 Architecture Summary

This architecture provides a robust, scalable foundation for ReparagymStore's Mexican market entry. Key architectural decisions prioritize:

- **Performance:** Sub-500ms response times with global CDN
- **Reliability:** 99.9% uptime with automated failover
- **Scalability:** Horizontal scaling from MVP to enterprise
- **Security:** PCI DSS compliance and Mexican data protection
- **Cultural Adaptation:** WhatsApp integration and Spanish-first design

### 18.2 Implementation Phases

**Phase 1 (Days 1-10): Core Infrastructure**
- Set up development environment
- Deploy basic Medusa.js backend
- Configure PostgreSQL with base schema
- Implement Next.js storefront foundation

**Phase 2 (Days 11-20): Core Features**
- Implement product catalog and search
- Set up MeiliSearch indexing
- Build checkout and payment flow
- Configure Mercado Pago integration

**Phase 3 (Days 21-30): Launch Preparation**
- Implement WhatsApp integration
- Set up shipping providers
- Complete admin panel customization
- Production deployment and testing

### 18.3 Success Metrics

**Technical KPIs:**
- TTFB < 500ms (Vercel global CDN)
- LCP < 2.5s on 3G networks
- 99.9% uptime SLA
- Search success rate ≥ 75%

**Business KPIs:**
- ≥ 10 paid orders in first 30 days
- Checkout conversion ≥ 1.5%
- Support response time < 4 hours
- Refund rate < 5%

This architecture document serves as the technical blueprint for building a world-class e-commerce platform tailored specifically for the Mexican gym equipment parts market.

---

**Document Prepared By:** Winston, Architect Agent (BMAD-METHOD)  
**Review Status:** Ready for validation and implementation  
**Next Steps:** Product Owner validation and development story creation