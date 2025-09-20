import { Metadata } from 'next'
import { Hero } from '@/components/sections/hero'
import { FeaturedCategories } from '@/components/sections/featured-categories'
import { WhyChooseUs } from '@/components/sections/why-choose-us'
import { CallToAction } from '@/components/sections/call-to-action'

export const metadata: Metadata = {
  title: 'ReparagymStore - Refacciones para Gimnasio en México | Inicio',
  description: 'Encuentra las mejores refacciones para tu equipo de gimnasio en México. Entrega rápida, partes auténticas, soporte técnico especializado.',
}

export default function HomePage() {
  return (
    <main className="min-h-screen">
      {/* Hero Section */}
      <Hero />
      
      {/* Featured Categories */}
      <FeaturedCategories />
      
      {/* Why Choose Us */}
      <WhyChooseUs />
      
      {/* Call to Action */}
      <CallToAction />
    </main>
  )
}