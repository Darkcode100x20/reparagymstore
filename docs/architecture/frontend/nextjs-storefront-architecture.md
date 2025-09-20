# Next.js Storefront Architecture

**Document ID:** ARCH-FE-001  
**Component:** Frontend Application  
**Technology Stack:** Next.js 14+ with App Router  
**Deployment:** Vercel with Global CDN  
**Last Updated:** September 20, 2025  

## Overview

The ReparagymStore frontend is built as a modern, mobile-first Progressive Web Application using Next.js 14+ with the App Router. The architecture prioritizes performance, accessibility, and Mexican market cultural adaptation while maintaining scalability for future expansion.

## Technology Stack

### Core Framework
- **Framework:** Next.js 14+ (App Router)
- **Runtime:** Node.js 18+
- **Language:** TypeScript 5+
- **Styling:** Tailwind CSS 3.4+
- **Package Manager:** npm or pnpm

### State Management & Data Fetching
- **Global State:** Zustand (lightweight, performant)
- **Server State:** React Query (TanStack Query v5)
- **Forms:** React Hook Form + Zod validation
- **HTTP Client:** Axios with interceptors

### UI & User Experience
- **Component Library:** Custom components with Tailwind
- **Icons:** Lucide React or Heroicons
- **Internationalization:** next-intl (Spanish primary)
- **Analytics:** Vercel Analytics + Google Analytics 4
- **Performance:** Next.js built-in optimizations

## Application Structure

```
src/
├── app/                           # App Router pages and layouts
│   ├── (storefront)/             # Customer-facing routes
│   │   ├── layout.tsx            # Storefront layout
│   │   ├── page.tsx              # Homepage
│   │   ├── productos/            # Product catalog
│   │   │   ├── page.tsx          # Product listing
│   │   │   ├── [slug]/           # Product details
│   │   │   └── categoria/        # Category pages
│   │   ├── buscar/               # Search results
│   │   ├── carrito/              # Shopping cart
│   │   ├── checkout/             # Checkout process
│   │   ├── cuenta/               # Account management
│   │   └── pedidos/              # Order history
│   ├── api/                      # API routes and webhooks
│   │   ├── auth/                 # Authentication endpoints
│   │   ├── search/               # Search proxy to MeiliSearch
│   │   ├── webhook/              # External webhooks
│   │   └── health/               # Health check
│   ├── globals.css               # Global styles
│   └── layout.tsx                # Root layout
├── components/                   # Reusable UI components
│   ├── ui/                       # Base UI components
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Modal.tsx
│   │   └── ...
│   ├── layout/                   # Layout components
│   │   ├── Header.tsx
│   │   ├── Footer.tsx
│   │   ├── Navigation.tsx
│   │   └── MobileMenu.tsx
│   ├── product/                  # Product-specific components
│   │   ├── ProductCard.tsx
│   │   ├── ProductGrid.tsx
│   │   ├── ProductDetails.tsx
│   │   ├── ProductImages.tsx
│   │   └── ProductSpecs.tsx
│   ├── search/                   # Search components
│   │   ├── SearchBar.tsx
│   │   ├── SearchResults.tsx
│   │   ├── SearchFilters.tsx
│   │   └── SearchSuggestions.tsx
│   └── checkout/                 # Checkout flow components
│       ├── CartSummary.tsx
│       ├── AddressForm.tsx
│       ├── ShippingOptions.tsx
│       └── PaymentSection.tsx
├── hooks/                        # Custom React hooks
│   ├── useAuth.ts               # Authentication state
│   ├── useCart.ts               # Shopping cart state
│   ├── useSearch.ts             # Search functionality
│   ├── useLocalStorage.ts       # Browser storage
│   └── useMediaQuery.ts         # Responsive utilities
├── lib/                         # Utility functions and configs
│   ├── medusa.ts               # Medusa.js client configuration
│   ├── meilisearch.ts          # Search client
│   ├── validation.ts           # Zod schemas
│   ├── utils.ts                # General utilities
│   ├── constants.ts            # App constants
│   └── types.ts                # TypeScript types
├── stores/                      # Zustand stores
│   ├── authStore.ts            # Authentication state
│   ├── cartStore.ts            # Shopping cart state
│   ├── searchStore.ts          # Search state
│   └── uiStore.ts              # UI state (modals, etc.)
└── types/                       # TypeScript type definitions
    ├── medusa.ts               # Medusa API types
    ├── search.ts               # Search-related types
    └── common.ts               # Common type definitions
```

## Performance Architecture

### Core Web Vitals Optimization

```typescript
// Performance targets
const PERFORMANCE_TARGETS = {
  FCP: 1.5,    // First Contentful Paint (seconds)
  LCP: 2.5,    // Largest Contentful Paint (seconds)
  FID: 100,    // First Input Delay (milliseconds)
  CLS: 0.1,    // Cumulative Layout Shift
  TTFB: 500    // Time to First Byte (milliseconds)
} as const;
```

### Image Optimization Strategy
```typescript
// Next.js Image configuration
const imageConfig = {
  formats: ['image/webp', 'image/avif'],
  imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
  minimumCacheTTL: 31536000, // 1 year
  dangerouslyAllowSVG: false,
  contentSecurityPolicy: "default-src 'self'; script-src 'none'; sandbox;",
};

// Image component usage
<Image
  src={product.thumbnail}
  alt={product.title}
  width={400}
  height={400}
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  priority={isAboveFold}
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>
```

### Code Splitting Strategy
```typescript
// Dynamic imports for heavy components
const ProductComparison = dynamic(() => import('@/components/ProductComparison'), {
  loading: () => <ProductComparisonSkeleton />,
  ssr: false
});

const WhatsAppWidget = dynamic(() => import('@/components/WhatsAppWidget'), {
  loading: () => null,
  ssr: false
});

// Route-based code splitting (automatic with App Router)
// Page components are automatically split
```

### Caching Strategy
```typescript
// API route caching
export async function GET(request: Request) {
  const products = await getProducts();
  
  return new Response(JSON.stringify(products), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'public, s-maxage=300, stale-while-revalidate=600',
    },
  });
}

// Component-level caching with React Query
const useProducts = (categoryId?: string) => {
  return useQuery({
    queryKey: ['products', categoryId],
    queryFn: () => fetchProducts(categoryId),
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  });
};
```

## State Management Architecture

### Zustand Store Configuration
```typescript
// Auth store
interface AuthState {
  user: Customer | null;
  isAuthenticated: boolean;
  token: string | null;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  register: (userData: RegistrationData) => Promise<void>;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  isAuthenticated: false,
  token: null,
  
  login: async (credentials) => {
    try {
      const response = await medusaClient.auth.authenticate(credentials);
      set({ 
        user: response.customer,
        isAuthenticated: true,
        token: response.access_token
      });
    } catch (error) {
      throw new Error('Login failed');
    }
  },
  
  logout: () => {
    set({ user: null, isAuthenticated: false, token: null });
    // Clear other stores if needed
  },
}));

// Cart store with persistence
interface CartState {
  items: CartItem[];
  total: number;
  addItem: (item: CartItem) => void;
  removeItem: (variantId: string) => void;
  updateQuantity: (variantId: string, quantity: number) => void;
  clear: () => void;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      total: 0,
      
      addItem: (item) => {
        set((state) => {
          const existingItem = state.items.find(i => i.variantId === item.variantId);
          if (existingItem) {
            existingItem.quantity += item.quantity;
            return { ...state, total: calculateTotal(state.items) };
          }
          return { 
            items: [...state.items, item],
            total: calculateTotal([...state.items, item])
          };
        });
      },
      
      // ... other methods
    }),
    {
      name: 'reparagym-cart',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
```

## Mexican Market Adaptations

### Internationalization Setup
```typescript
// next-intl configuration
const messages = {
  es: {
    navigation: {
      products: 'Productos',
      categories: 'Categorías',
      search: 'Buscar',
      cart: 'Carrito',
      account: 'Cuenta'
    },
    product: {
      addToCart: 'Agregar al Carrito',
      outOfStock: 'Agotado',
      specifications: 'Especificaciones Técnicas',
      compatibility: 'Compatibilidad',
      installation: 'Guía de Instalación'
    },
    checkout: {
      shipping: 'Envío',
      billing: 'Facturación',
      payment: 'Pago',
      review: 'Revisar Pedido'
    }
  }
};

// Component usage
import { useTranslations } from 'next-intl';

function ProductCard({ product }: { product: Product }) {
  const t = useTranslations('product');
  
  return (
    <div className="product-card">
      <h3>{product.title}</h3>
      <button>{t('addToCart')}</button>
    </div>
  );
}
```

### Mexican Address Form Component
```typescript
interface MexicanAddressFormProps {
  onSubmit: (address: MexicanAddress) => void;
  defaultValues?: Partial<MexicanAddress>;
}

function MexicanAddressForm({ onSubmit, defaultValues }: MexicanAddressFormProps) {
  const form = useForm<MexicanAddress>({
    resolver: zodResolver(mexicanAddressSchema),
    defaultValues
  });

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <Input
          {...form.register('street')}
          label="Calle"
          placeholder="Av. Insurgentes Sur"
          required
        />
        <Input
          {...form.register('exteriorNumber')}
          label="Número Exterior"
          placeholder="123"
          required
        />
      </div>
      
      <Input
        {...form.register('neighborhood')}
        label="Colonia"
        placeholder="Roma Norte"
        required
      />
      
      <div className="grid grid-cols-2 gap-4">
        <Select
          {...form.register('state')}
          label="Estado"
          options={MEXICAN_STATES}
          required
        />
        <Input
          {...form.register('postalCode')}
          label="Código Postal"
          placeholder="06700"
          pattern="[0-9]{5}"
          required
        />
      </div>
      
      <Button type="submit">Guardar Dirección</Button>
    </form>
  );
}
```

## Mobile-First Design System

### Responsive Breakpoints
```typescript
const breakpoints = {
  sm: '640px',   // Mobile large
  md: '768px',   // Tablet
  lg: '1024px',  // Desktop small
  xl: '1280px',  // Desktop large
  '2xl': '1536px' // Desktop extra large
} as const;

// Tailwind configuration
module.exports = {
  theme: {
    screens: breakpoints,
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
        // Mexican flag inspired colors as accents
        mexican: {
          green: '#006847',
          red: '#ce1126',
        }
      }
    }
  }
};
```

### Touch-Friendly Components
```typescript
// Button with proper touch targets
function Button({ 
  children, 
  size = 'md',
  ...props 
}: ButtonProps) {
  const sizeClasses = {
    sm: 'px-3 py-2 text-sm min-h-[44px]', // 44px minimum for touch
    md: 'px-4 py-3 text-base min-h-[48px]',
    lg: 'px-6 py-4 text-lg min-h-[52px]'
  };

  return (
    <button
      className={cn(
        'inline-flex items-center justify-center rounded-md font-medium',
        'focus:outline-none focus:ring-2 focus:ring-offset-2',
        'disabled:opacity-50 disabled:pointer-events-none',
        sizeClasses[size]
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

## SEO & Analytics Architecture

### Metadata Configuration
```typescript
// app/layout.tsx
export const metadata: Metadata = {
  title: {
    template: '%s | ReparagymStore - Refacciones para Gimnasio',
    default: 'ReparagymStore - Refacciones y Partes para Equipos de Gimnasio'
  },
  description: 'La forma más rápida y confiable de mantener tu equipo de gimnasio funcionando en México. Envío en 3-7 días.',
  keywords: ['refacciones gimnasio', 'partes ejercicio', 'equipo fitness', 'mantenimiento gimnasio'],
  authors: [{ name: 'ReparagymStore' }],
  openGraph: {
    type: 'website',
    locale: 'es_MX',
    url: 'https://reparagymstore.com',
    siteName: 'ReparagymStore',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

// Product page metadata
export async function generateMetadata({ params }: { params: { slug: string } }): Promise<Metadata> {
  const product = await getProduct(params.slug);
  
  return {
    title: product.title,
    description: product.description,
    openGraph: {
      title: product.title,
      description: product.description,
      images: [product.thumbnail],
      type: 'product',
    },
    alternates: {
      canonical: `/productos/${product.handle}`,
    },
  };
}
```

### Analytics Implementation
```typescript
// Google Analytics 4 setup
'use client';

import { GoogleAnalytics } from '@next/third-parties/google';
import { usePathname, useSearchParams } from 'next/navigation';
import { useEffect } from 'react';

export function Analytics() {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('config', process.env.NEXT_PUBLIC_GA_ID, {
        page_path: pathname + searchParams.toString(),
      });
    }
  }, [pathname, searchParams]);

  return <GoogleAnalytics gaId={process.env.NEXT_PUBLIC_GA_ID} />;
}

// E-commerce tracking
export function trackPurchase(orderData: OrderData) {
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', 'purchase', {
      transaction_id: orderData.id,
      value: orderData.total,
      currency: 'MXN',
      items: orderData.items.map(item => ({
        item_id: item.variant_id,
        item_name: item.title,
        category: item.product.categories[0]?.name,
        quantity: item.quantity,
        price: item.unit_price,
      })),
    });
  }
}
```

## Security Implementation

### Content Security Policy
```typescript
// next.config.js
const nextConfig = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'Content-Security-Policy',
            value: [
              "default-src 'self'",
              "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.googletagmanager.com",
              "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
              "img-src 'self' data: https: blob:",
              "font-src 'self' https://fonts.gstatic.com",
              "connect-src 'self' https://api.reparagymstore.com https://search.reparagymstore.com",
              "frame-ancestors 'none'",
            ].join('; '),
          },
        ],
      },
    ];
  },
};
```

### Input Validation
```typescript
// Form validation with Zod
const productSearchSchema = z.object({
  query: z.string().min(1).max(100).trim(),
  category: z.string().optional(),
  brand: z.string().optional(),
  priceMin: z.number().min(0).optional(),
  priceMax: z.number().min(0).optional(),
});

// XSS prevention utility
function sanitizeInput(input: string): string {
  return input
    .replace(/[<>\"']/g, '') // Remove dangerous characters
    .trim()
    .slice(0, 1000); // Limit length
}
```

## Deployment & CI/CD

### Vercel Configuration
```json
{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "outputDirectory": ".next",
  "functions": {
    "app/api/**/*.ts": {
      "maxDuration": 30
    }
  },
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=0, s-maxage=300"
        }
      ]
    }
  ],
  "redirects": [
    {
      "source": "/admin",
      "destination": "https://admin.reparagymstore.com",
      "permanent": false
    }
  ]
}
```

### Environment Variables
```bash
# Production environment
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.reparagymstore.com
NEXT_PUBLIC_MEILISEARCH_HOST=https://search.reparagymstore.com
NEXT_PUBLIC_MEILISEARCH_API_KEY=
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX
NEXT_PUBLIC_WHATSAPP_NUMBER=+525512345678
NEXTAUTH_SECRET=
NEXTAUTH_URL=https://reparagymstore.com
```

---

**Architecture Owner:** Frontend Development Lead  
**Stakeholders:** UX Designer, Performance Engineer, SEO Specialist  
**Review Frequency:** Quarterly  
**Last Performance Audit:** September 20, 2025