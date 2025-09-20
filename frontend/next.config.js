/** @type {import('next').NextConfig} */
const withNextIntl = require('next-intl/plugin')('./src/i18n.ts');

const nextConfig = {
  experimental: {
    serverComponentsExternalPackages: ['@medusajs/js-sdk']
  },
  images: {
    remotePatterns: [
      {
        protocol: 'http',
        hostname: 'localhost',
        port: '9000',
        pathname: '/uploads/**',
      },
      {
        protocol: 'https',
        hostname: 'api.reparagymstore.com',
        pathname: '/uploads/**',
      }
    ]
  },
  env: {
    NEXT_PUBLIC_MEDUSA_BACKEND_URL: process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || 'http://localhost:9000',
    NEXT_PUBLIC_BASE_URL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
    NEXT_PUBLIC_MEILISEARCH_HOST: process.env.NEXT_PUBLIC_MEILISEARCH_HOST || 'http://localhost:7700',
    NEXT_PUBLIC_MEILISEARCH_API_KEY: process.env.NEXT_PUBLIC_MEILISEARCH_API_KEY,
  }
};

module.exports = withNextIntl(nextConfig);