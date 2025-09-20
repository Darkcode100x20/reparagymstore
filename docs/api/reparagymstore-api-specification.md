# ReparagymStore API Specification

**API Version:** v1  
**Base URL:** `https://api.reparagymstore.com/v1`  
**Documentation:** OpenAPI 3.0  
**Authentication:** JWT Bearer Token  
**Content Type:** `application/json`  

## Overview

The ReparagymStore API provides comprehensive access to gym equipment parts catalog, order management, customer accounts, and WhatsApp integration. Built on Medusa.js with custom extensions for the Mexican B2B market.

## Authentication

### JWT Token Structure
```http
Authorization: Bearer <access_token>
```

```typescript
interface AuthTokens {
  access_token: string;    // 15-minute expiration
  refresh_token: string;   // 7-day expiration
  expires_in: number;      // Seconds until expiration
  token_type: 'Bearer';
}
```

### Authentication Endpoints

#### POST /auth/login
**Description:** Authenticate user with email and password  
**Rate Limit:** 5 requests per 15 minutes per IP  

```typescript
// Request
interface LoginRequest {
  email: string;
  password: string;
  remember_me?: boolean; // Extends session to 30 days
}

// Response
interface LoginResponse {
  customer: Customer;
  access_token: string;
  refresh_token: string;
  expires_in: number;
}

// Example
POST /auth/login
{
  "email": "carlos@gimnasiopremium.mx",
  "password": "SecurePass123",
  "remember_me": true
}
```

#### POST /auth/register
**Description:** Register new business customer account  

```typescript
interface RegisterRequest {
  email: string;
  password: string;
  first_name: string;
  last_name: string;
  company_name: string;
  phone: string; // Mexican format: +52xxxxxxxxxx
  accepted_terms: boolean;
  data_consent: boolean;
}

// Example
POST /auth/register
{
  "email": "maria@tecnicofitness.mx",
  "password": "SecurePass123",
  "first_name": "María",
  "last_name": "González",
  "company_name": "Técnico Fitness Solutions",
  "phone": "+525512345678",
  "accepted_terms": true,
  "data_consent": true
}
```

#### POST /auth/refresh
**Description:** Refresh access token using refresh token  

```typescript
interface RefreshRequest {
  refresh_token: string;
}

POST /auth/refresh
{
  "refresh_token": "refresh_token_here"
}
```

## Product Catalog API

### GET /store/products
**Description:** Get product catalog with search and filtering  

```typescript
interface ProductListParams {
  q?: string;                    // Search query
  limit?: number;               // Default: 20, Max: 100
  offset?: number;              // Pagination offset
  brand_id?: string[];          // Filter by brand IDs
  machine_type_id?: string[];   // Filter by machine type
  price_min?: number;           // Minimum price filter
  price_max?: number;           // Maximum price filter
  in_stock?: boolean;           // Stock availability filter
  has_guide?: boolean;          // Has installation guide
  sort?: 'price_asc' | 'price_desc' | 'created_at' | 'popularity';
}

interface ProductListResponse {
  products: Product[];
  count: number;
  total: number;
  limit: number;
  offset: number;
  facets?: {
    brands: Array<{ id: string; name: string; count: number }>;
    machine_types: Array<{ id: string; name: string; count: number }>;
    price_ranges: Array<{ min: number; max: number; count: number }>;
  };
}

// Example
GET /store/products?q=banda%20caminadora&brand_id=life-fitness&limit=10&sort=price_asc
```

### GET /store/products/:id
**Description:** Get detailed product information  

```typescript
interface Product {
  id: string;
  title: string;
  spanish_title: string;
  description: string;
  spanish_description: string;
  handle: string;
  thumbnail: string;
  images: ProductImage[];
  status: 'draft' | 'proposed' | 'published' | 'rejected';
  weight?: number; // in kg
  length?: number; // in cm
  width?: number;  // in cm
  height?: number; // in cm
  brand?: Brand;
  machine_type?: MachineType;
  variants: ProductVariant[];
  guides: ProductGuide[];
  compatibility_tags: string[];
  technical_specs: Record<string, any>;
  created_at: string;
  updated_at: string;
}

interface ProductVariant {
  id: string;
  title: string;
  spanish_title: string;
  sku: string;
  sku_barcode?: string;
  price_amount: number;
  currency_code: string;
  inventory_quantity: number;
  manage_inventory: boolean;
  allow_backorder: boolean;
  material?: string;
  weight?: number;
  options: Array<{
    id: string;
    value: string;
    option_id: string;
  }>;
  created_at: string;
  updated_at: string;
}

// Example
GET /store/products/prod_01H8XYZ123
```

### GET /store/search
**Description:** Advanced search with MeiliSearch integration  

```typescript
interface SearchParams {
  q: string;                    // Search query (required)
  limit?: number;               // Max: 100
  offset?: number;
  filters?: string[];           // MeiliSearch filter syntax
  facets?: string[];            // Facets to return
  highlight_pre_tag?: string;   // HTML highlight start
  highlight_post_tag?: string;  // HTML highlight end
}

interface SearchResponse {
  hits: ProductSearchHit[];
  query: string;
  total_hits: number;
  processing_time_ms: number;
  facet_distribution?: Record<string, Record<string, number>>;
}

interface ProductSearchHit {
  id: string;
  title: string;
  spanish_title: string;
  sku: string;
  brand_name: string;
  machine_type_name: string;
  price: number;
  thumbnail?: string;
  in_stock: boolean;
  has_guide: boolean;
  _formatted?: Record<string, string>; // Highlighted fields
}

// Example
GET /store/search?q=rodamiento&filters=brand_id%3Dlife-fitness&facets=brand_id,machine_type_id
```

## Shopping Cart API

### GET /store/carts/:id
**Description:** Get shopping cart contents  

```typescript
interface Cart {
  id: string;
  customer_id?: string;
  email?: string;
  region: Region;
  items: LineItem[];
  subtotal: number;
  tax_total: number;
  shipping_total: number;
  discount_total: number;
  total: number;
  currency_code: string;
  created_at: string;
  updated_at: string;
}

interface LineItem {
  id: string;
  cart_id: string;
  variant: ProductVariant;
  product: Product;
  quantity: number;
  unit_price: number;
  total: number;
  created_at: string;
  updated_at: string;
}

// Example
GET /store/carts/cart_01H8XYZ123
```

### POST /store/carts/:id/line-items
**Description:** Add item to shopping cart  

```typescript
interface AddItemRequest {
  variant_id: string;
  quantity: number;
}

// Example
POST /store/carts/cart_01H8XYZ123/line-items
{
  "variant_id": "variant_01H8ABC456",
  "quantity": 2
}
```

### PUT /store/carts/:id/line-items/:line_id
**Description:** Update cart item quantity  

```typescript
interface UpdateItemRequest {
  quantity: number;
}

// Example
PUT /store/carts/cart_01H8XYZ123/line-items/item_01H8DEF789
{
  "quantity": 3
}
```

## Shipping API

### POST /store/shipping-options
**Description:** Get available shipping options for cart  

```typescript
interface ShippingOptionsRequest {
  cart_id: string;
  shipping_address: {
    first_name: string;
    last_name: string;
    address_1: string;
    address_2?: string;
    city: string;
    postal_code: string; // Mexican 5-digit format
    province: string;    // Mexican state code
    country_code: string; // "MX"
  };
}

interface ShippingOption {
  id: string;
  name: string;
  carrier: 'fedex' | 'ups' | 'estafeta';
  service_level: 'standard' | 'express' | 'same_day';
  amount: number;
  currency_code: string;
  estimated_delivery_days: number;
  estimated_delivery_date: string;
  restrictions?: string[];
}

// Example
POST /store/shipping-options
{
  "cart_id": "cart_01H8XYZ123",
  "shipping_address": {
    "first_name": "Carlos",
    "last_name": "Mendoza",
    "address_1": "Av. Insurgentes Sur 1234",
    "city": "Ciudad de México",
    "postal_code": "03100",
    "province": "CDMX",
    "country_code": "MX"
  }
}
```

## Order Management API

### POST /store/orders
**Description:** Create order from cart  

```typescript
interface CreateOrderRequest {
  cart_id: string;
  shipping_address: Address;
  billing_address?: Address;
  shipping_option_id: string;
  payment_method: 'mercado_pago' | 'bank_transfer';
}

interface Order {
  id: string;
  display_id: number;
  status: 'pending' | 'paid' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  email: string;
  customer?: Customer;
  region: Region;
  currency_code: string;
  tax_rate: number;
  items: LineItem[];
  shipping_address: Address;
  billing_address: Address;
  shipping_methods: ShippingMethod[];
  payments: Payment[];
  subtotal: number;
  tax_total: number;
  shipping_total: number;
  total: number;
  paid_total: number;
  refunded_total: number;
  created_at: string;
  updated_at: string;
}

// Example
POST /store/orders
{
  "cart_id": "cart_01H8XYZ123",
  "shipping_address": { /* address object */ },
  "shipping_option_id": "so_fedex_express",
  "payment_method": "mercado_pago"
}
```

### GET /store/orders/:id
**Description:** Get order details  

```typescript
// Example
GET /store/orders/order_01H8XYZ123
```

### GET /store/customers/me/orders
**Description:** Get customer order history  
**Authentication:** Required  

```typescript
interface OrderListParams {
  limit?: number;
  offset?: number;
  status?: string[];
  date_from?: string;
  date_to?: string;
}

// Example
GET /store/customers/me/orders?limit=10&status=delivered,shipped
```

## Customer Account API

### GET /store/customers/me
**Description:** Get current customer profile  
**Authentication:** Required  

```typescript
interface Customer {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  company_name?: string;
  phone?: string;
  phone_verified: boolean;
  email_verified: boolean;
  account_type: 'business' | 'individual';
  billing_address?: Address;
  shipping_addresses: Address[];
  orders?: Order[];
  created_at: string;
  updated_at: string;
}

// Example
GET /store/customers/me
```

### PUT /store/customers/me
**Description:** Update customer profile  
**Authentication:** Required  

```typescript
interface UpdateCustomerRequest {
  first_name?: string;
  last_name?: string;
  company_name?: string;
  phone?: string;
}

// Example
PUT /store/customers/me
{
  "company_name": "Gimnasio Premium Nuevo Nombre",
  "phone": "+525512345679"
}
```

### POST /store/customers/me/addresses
**Description:** Add new customer address  
**Authentication:** Required  

```typescript
interface CreateAddressRequest {
  first_name: string;
  last_name: string;
  company?: string;
  address_1: string;
  address_2?: string;
  city: string;
  postal_code: string;
  province: string;
  country_code: string;
  phone?: string;
  metadata?: Record<string, any>;
}

// Example
POST /store/customers/me/addresses
{
  "first_name": "Carlos",
  "last_name": "Mendoza",
  "company": "Sucursal Norte",
  "address_1": "Av. Revolución 456",
  "city": "Monterrey",
  "postal_code": "64000",
  "province": "NL",
  "country_code": "MX"
}
```

## WhatsApp Integration API

### POST /whatsapp/inquiry
**Description:** Create WhatsApp inquiry (internal use)  

```typescript
interface WhatsAppInquiryRequest {
  phone_number: string;
  customer_name?: string;
  message: string;
  media_url?: string;
  agent_id?: string;
}

// Example
POST /whatsapp/inquiry
{
  "phone_number": "+525512345678",
  "customer_name": "Carlos Mendoza",
  "message": "Necesito una banda para mi caminadora Life Fitness",
  "agent_id": "agent_001"
}
```

### POST /whatsapp/orders
**Description:** Create order from WhatsApp conversation  
**Authentication:** Required (Agent)  

```typescript
interface WhatsAppOrderRequest {
  conversation_id: string;
  customer_phone: string;
  customer_name: string;
  customer_email?: string;
  items: Array<{
    variant_id: string;
    quantity: number;
    notes?: string;
  }>;
  shipping_address: Address;
  notes?: string;
}

// Example
POST /whatsapp/orders
{
  "conversation_id": "conv_01H8XYZ123",
  "customer_phone": "+525512345678",
  "customer_name": "Carlos Mendoza",
  "items": [
    {
      "variant_id": "variant_01H8ABC456",
      "quantity": 1,
      "notes": "Para caminadora modelo T5.5"
    }
  ],
  "shipping_address": { /* address object */ },
  "notes": "Cliente necesita instalación urgente"
}
```

## Analytics API

### GET /analytics/search
**Description:** Get search analytics data  
**Authentication:** Required (Admin)  

```typescript
interface SearchAnalyticsParams {
  date_from: string;
  date_to: string;
  limit?: number;
  group_by?: 'day' | 'week' | 'month';
}

interface SearchAnalyticsResponse {
  total_searches: number;
  unique_queries: number;
  success_rate: number; // Percentage of searches leading to clicks
  top_queries: Array<{
    query: string;
    count: number;
    success_rate: number;
  }>;
  failed_queries: Array<{
    query: string;
    count: number;
  }>;
}

// Example
GET /analytics/search?date_from=2025-09-01&date_to=2025-09-30&group_by=week
```

## Error Handling

### Standard Error Response
```typescript
interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: any;
  };
  status: number;
  timestamp: string;
}

// Example error responses
{
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email o contraseña incorrectos"
  },
  "status": 401,
  "timestamp": "2025-09-20T10:30:00Z"
}

{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Datos de entrada inválidos",
    "details": {
      "email": ["El email es requerido"],
      "phone": ["Formato de teléfono mexicano inválido"]
    }
  },
  "status": 400,
  "timestamp": "2025-09-20T10:30:00Z"
}
```

### Common Error Codes
- `INVALID_CREDENTIALS` (401): Login failed
- `VALIDATION_ERROR` (400): Request validation failed
- `NOT_FOUND` (404): Resource not found
- `UNAUTHORIZED` (401): Authentication required
- `FORBIDDEN` (403): Insufficient permissions
- `RATE_LIMITED` (429): Too many requests
- `INTERNAL_ERROR` (500): Server error
- `SERVICE_UNAVAILABLE` (503): External service down

## Rate Limiting

### Rate Limit Headers
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1632150000
X-RateLimit-Window: 3600
```

### Rate Limits by Endpoint Category
- **Authentication:** 5 requests per 15 minutes per IP
- **Search:** 100 requests per minute per user
- **Cart Operations:** 200 requests per minute per user
- **Order Creation:** 10 requests per minute per user
- **General API:** 1000 requests per hour per user

## Webhooks

### Webhook Events
```typescript
interface WebhookEvent {
  id: string;
  type: string;
  data: any;
  created_at: string;
  api_version: string;
}

// Available webhook events
const WEBHOOK_EVENTS = [
  'order.created',
  'order.updated', 
  'order.paid',
  'order.shipped',
  'order.delivered',
  'order.cancelled',
  'payment.succeeded',
  'payment.failed',
  'customer.created',
  'product.updated',
  'inventory.low_stock'
] as const;
```

### Webhook Security
- HMAC-SHA256 signature verification
- Timestamp validation (5-minute window)
- Idempotency key support
- Retry mechanism with exponential backoff

---

**API Owner:** Backend Development Team  
**Documentation:** Swagger/OpenAPI available at `/docs`  
**SDK:** JavaScript/TypeScript SDK available  
**Support:** api-support@reparagymstore.com