import type { Metadata } from 'next'
import { Inter, Poppins } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/providers'
import { Header } from '@/components/layout/header'
import { Footer } from '@/components/layout/footer'
import { WhatsAppFAB } from '@/components/common/whatsapp-fab'

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap'
})

const poppins = Poppins({ 
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-poppins',
  display: 'swap'
})

export const metadata: Metadata = {
  title: 'ReparagymStore - Refacciones para Gimnasio en México',
  description: 'La tienda más confiable de refacciones para equipo de gimnasio en México. Entrega rápida, partes auténticas, soporte técnico en español.',
  keywords: [
    'refacciones gimnasio',
    'partes equipo ejercicio',
    'repuestos fitness',
    'mexico',
    'gym equipment parts'
  ],
  authors: [{ name: 'ReparagymStore Team' }],
  creator: 'ReparagymStore',
  publisher: 'ReparagymStore',
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  metadataBase: new URL(process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000'),
  alternates: {
    canonical: '/',
    languages: {
      'es-MX': '/es',
      'en-US': '/en',
    },
  },
  openGraph: {
    title: 'ReparagymStore - Refacciones para Gimnasio en México',
    description: 'La tienda más confiable de refacciones para equipo de gimnasio en México.',
    url: '/',
    siteName: 'ReparagymStore',
    locale: 'es_MX',
    type: 'website',
    images: [
      {
        url: '/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'ReparagymStore - Refacciones para Gimnasio',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'ReparagymStore - Refacciones para Gimnasio en México',
    description: 'La tienda más confiable de refacciones para equipo de gimnasio en México.',
    images: ['/og-image.jpg'],
  },
  viewport: {
    width: 'device-width',
    initialScale: 1,
    maximumScale: 5,
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
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es" className={`${inter.variable} ${poppins.variable}`}>
      <body className={`${inter.className} antialiased`}>
        <Providers>
          <Header />
          {children}
          <Footer />
          <WhatsAppFAB />
        </Providers>
      </body>
    </html>
  )
}