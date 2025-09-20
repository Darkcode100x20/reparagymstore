# ReparagymStore - Gym Equipment Parts E-commerce Platform

[![Built with BMAD-METHOD](https://img.shields.io/badge/Built%20with-BMAD--METHOD-blue.svg)](https://github.com/bmad-method)
[![Medusa 2.0](https://img.shields.io/badge/Medusa-2.0-brightgreen.svg)](https://medusajs.com)
[![Next.js 14](https://img.shields.io/badge/Next.js-14-black.svg)](https://nextjs.org)

A comprehensive e-commerce platform specifically designed for the Mexican gym equipment parts market. Built using the BMAD-METHOD™ framework with modern technologies and Mexican market adaptations.

## 🎯 Project Overview

**Goal:** Launch Mexico's first specialized gym equipment parts marketplace with 30-day MVP timeline.

**Target Market:** Mexican gym owners, fitness equipment technicians, and commercial facilities.

**Key Features:**
- 🔍 Advanced search with typo tolerance (MeiliSearch)
- 💳 Mexican payment methods (Mercado Pago, SPEI, OXXO)
- 📱 WhatsApp Business integration
- 🚚 Multi-carrier shipping (FedEx, UPS, Estafeta)
- 🇪🇸 Spanish-first experience
- ⚡ Performance optimized (TTFB < 500ms, LCP < 2.5s)

## 🏗️ Architecture

### Technology Stack

**Backend:**
- **Framework:** Medusa.js 2.0+ (Node.js/TypeScript)
- **Database:** PostgreSQL 15+ with MikroORM
- **Cache:** Redis 7+ for sessions and caching
- **Search:** MeiliSearch for product discovery
- **Files:** Local file storage (production: S3-compatible)

**Frontend:**
- **Framework:** Next.js 14+ with App Router
- **Styling:** Tailwind CSS 3.4+ with custom Mexican theme
- **State:** Zustand + React Query
- **UI:** Custom components with Lucide icons
- **i18n:** next-intl for Spanish/English

**Integrations:**
- **Payments:** Mercado Pago (cards, SPEI, OXXO)
- **Shipping:** Multi-carrier API integration
- **Communication:** WhatsApp Business API
- **Analytics:** Vercel Analytics + Google Analytics 4

**Infrastructure:**
- **Frontend:** Vercel (global CDN)
- **Backend:** Railway/Digital Ocean
- **Database:** Neon PostgreSQL/Railway
- **Search:** Self-hosted MeiliSearch

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm 9+
- Docker and Docker Compose
- Git

### Development Setup

1. **Clone and setup:**
```bash
git clone <repository-url>
cd reparagymstore
npm install
```

2. **Start development services:**
```bash
# Start PostgreSQL, Redis, and MeiliSearch
docker compose up -d

# Install dependencies
npm install
cd backend && npm install
cd ../frontend && npm install
cd ..
```

3. **Configure environment:**
```bash
# Backend configuration
cp backend/.env.example backend/.env
# Edit backend/.env with your database credentials

# Frontend configuration  
cp frontend/.env.example frontend/.env.local
# Edit frontend/.env.local with your API URLs
```

4. **Initialize database:**
```bash
# Run database migrations
cd backend
npm run migrations:run

# Seed initial data
npm run seed
```

5. **Start development servers:**
```bash
# Start both backend and frontend
npm run dev

# Or start individually:
npm run dev:backend  # Backend: http://localhost:9000
npm run dev:frontend # Frontend: http://localhost:3000
```

### Services Access

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:9000
- **Admin Dashboard:** http://localhost:9000/admin
- **MeiliSearch:** http://localhost:7700
- **PostgreSQL:** localhost:5432
- **Redis:** localhost:6379

## 📁 Project Structure

```
reparagymstore/
├── backend/                 # Medusa.js backend
│   ├── src/
│   │   ├── models/         # Data models (Product, Brand, etc.)
│   │   ├── services/       # Business logic services
│   │   ├── workflows/      # Process workflows
│   │   ├── plugins/        # Custom Medusa plugins
│   │   └── scripts/        # Data migration scripts
│   ├── data/               # Seed data and migrations
│   └── medusa-config.ts    # Medusa configuration
├── frontend/               # Next.js storefront
│   ├── app/                # App Router pages
│   ├── components/         # React components
│   │   ├── ui/            # Base UI components
│   │   ├── sections/      # Page sections
│   │   └── layout/        # Layout components
│   ├── lib/               # Utilities and configurations
│   ├── hooks/             # Custom React hooks
│   ├── stores/            # Zustand state stores
│   └── types/             # TypeScript definitions
├── docs/                  # BMAD-METHOD documentation
│   ├── epics/             # Development epics
│   ├── stories/           # User stories
│   ├── architecture/      # Technical specifications
│   └── api/              # API documentation
├── .bmad-core/           # BMAD framework configuration
└── docker-compose.yml    # Development services
```

## 🇲🇽 Mexican Market Features

### Language & Localization
- Spanish-first interface and content
- Mexican peso (MXN) currency formatting
- Local address formats and postal codes
- Cultural adaptations for B2B communication

### Payment Methods
- **Credit/Debit Cards:** Visa, Mastercard, AMEX
- **Bank Transfer:** SPEI (Sistema de Pagos Electrónicos Interbancarios)
- **Cash:** OXXO convenience store payments
- **Installments:** Up to 12 months with participating banks

### Shipping Integration
- **FedEx Mexico:** Express and ground services
- **UPS Mexico:** Next-day and standard delivery
- **Estafeta:** Local Mexican carrier
- **Tiered rates:** Fallback pricing system
- **Free shipping:** Orders over $1,500 MXN

### WhatsApp Integration
- WhatsApp Business API for order assistance
- Guided ordering flow for complex products
- Spanish-speaking support team
- Integration with Medusa order system

## 🔧 Development Commands

```bash
# Development
npm run dev                 # Start all services
npm run dev:backend        # Backend only
npm run dev:frontend       # Frontend only

# Building
npm run build              # Build all
npm run build:backend      # Build backend
npm run build:frontend     # Build frontend

# Testing
npm run test               # Run all tests
npm run test:backend       # Backend tests
npm run test:frontend      # Frontend tests
npm run test:e2e          # End-to-end tests

# Database
npm run db:migrate         # Run migrations
npm run db:seed           # Seed data
npm run db:reset          # Reset database

# Linting & Type Checking
npm run lint              # Lint all code
npm run type-check        # TypeScript checking

# Docker
npm run docker:up         # Start development services
npm run docker:down       # Stop services
npm run docker:clean      # Clean up containers and volumes
```

## 📊 Performance Targets

**Core Web Vitals:**
- **TTFB:** < 500ms (Time to First Byte)
- **LCP:** < 2.5s (Largest Contentful Paint)
- **FID:** < 100ms (First Input Delay)
- **CLS:** < 0.1 (Cumulative Layout Shift)

**Business Metrics:**
- Search success rate: ≥ 75%
- Checkout conversion: ≥ 1.5%
- Support response time: < 4 hours
- Uptime: 99.9% during business hours

## 🔒 Security & Compliance

### Data Protection
- **GDPR-ready:** Data handling and user consent
- **LFPDPPP compliance:** Mexican data protection law
- **PCI DSS:** Payment processing through Mercado Pago
- **Encryption:** TLS 1.3 for data in transit, AES-256 at rest

### Security Features
- **Authentication:** JWT with refresh tokens
- **Authorization:** Role-based access control
- **Rate limiting:** API protection against abuse
- **Input validation:** XSS and injection protection
- **Security headers:** HSTS, CSP, and more

## 🚀 Deployment

### Staging Environment
```bash
# Deploy backend to Railway
railway up --service backend

# Deploy frontend to Vercel
vercel --prod

# Run post-deployment checks
npm run test:smoke
```

### Production Environment
- **Frontend:** Vercel (https://reparagymstore.com)
- **Backend:** Railway (https://api.reparagymstore.com)
- **Database:** Neon PostgreSQL with read replicas
- **Search:** Digital Ocean MeiliSearch cluster
- **CDN:** Vercel Edge Network + Cloudflare

### Environment Variables

**Backend (.env):**
```bash
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_SECRET=...
COOKIE_SECRET=...
MERCADO_PAGO_ACCESS_TOKEN=...
WHATSAPP_ACCESS_TOKEN=...
```

**Frontend (.env.local):**
```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.reparagymstore.com
NEXT_PUBLIC_MEILISEARCH_HOST=https://search.reparagymstore.com
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=G-...
```

## 📈 Success Metrics (First 30 Days)

**Technical Performance:**
- ✅ TTFB < 500ms achieved
- ✅ LCP < 2.5s on 3G networks
- ✅ 99.9% uptime during business hours
- ✅ Search response time < 200ms

**Business Goals:**
- 🎯 ≥ 10 paid orders
- 🎯 ≥ 1.5% checkout conversion rate
- 🎯 < 5% refund/return rate
- 🎯 ≥ 75% search success rate
- 🎯 < 4 hour support response time

## 🤝 Contributing

This project follows the BMAD-METHOD™ development workflow:

1. **Planning Phase:** Completed (Analyst → PM → Architect → PO)
2. **Development Phase:** In progress (SM → Dev → QA cycle)

### Development Workflow
1. Pick a story from `docs/stories/`
2. Implement following the technical specifications
3. Run tests and type checking
4. Submit for QA review
5. Deploy to staging for validation

### Code Standards
- **TypeScript:** Strict mode enabled
- **ESLint:** Airbnb configuration with custom rules
- **Prettier:** Automatic code formatting
- **Husky:** Pre-commit hooks for quality gates

## 📚 Documentation

- **Planning Documents:** `/docs/` directory
- **API Documentation:** Auto-generated OpenAPI specs
- **Architecture:** `ARCHITECTURE.md`
- **Business Requirements:** `PRD_REPARAGYMSTORE.md`
- **Market Analysis:** `PROJECT_BRIEF.md`

## 🆘 Support

### Getting Help
- **Development Issues:** Check `/docs/` for specifications
- **Bug Reports:** Create GitHub issues with reproduction steps
- **Technical Questions:** Contact the development team

### External Dependencies
- **Medusa.js:** [Documentation](https://docs.medusajs.com)
- **Next.js:** [Documentation](https://nextjs.org/docs)
- **MeiliSearch:** [Documentation](https://docs.meilisearch.com)
- **Mercado Pago:** [Developer Docs](https://www.mercadopago.com.mx/developers)

## 📄 License

This project is proprietary and confidential. All rights reserved by ReparagymStore.

---

**Built with ❤️ using BMAD-METHOD™ for the Mexican fitness industry**