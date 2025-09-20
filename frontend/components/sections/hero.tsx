import Link from 'next/link'
import { Search, MessageCircle, Truck, Shield } from 'lucide-react'

export function Hero() {
  return (
    <section className="relative bg-gradient-to-br from-primary-600 via-primary-700 to-primary-800 text-white">
      {/* Background pattern */}
      <div className="absolute inset-0 bg-[url('/grid-pattern.svg')] opacity-10" />
      
      <div className="relative container-custom py-16 sm:py-20 lg:py-24">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Content */}
          <div className="space-y-8">
            {/* Mexican flag accent */}
            <div className="flex items-center space-x-2">
              <div className="h-1 w-8 bg-mexican-green rounded-full" />
              <div className="h-1 w-8 bg-mexican-white rounded-full" />
              <div className="h-1 w-8 bg-mexican-red rounded-full" />
              <span className="text-sm font-medium opacity-90">Hecho en México</span>
            </div>

            {/* Headline */}
            <div className="space-y-4">
              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold font-display leading-tight">
                Refacciones para{' '}
                <span className="text-secondary-400">Gimnasio</span>{' '}
                en México
              </h1>
              <p className="text-xl sm:text-2xl text-primary-100 leading-relaxed">
                La forma más rápida y confiable de mantener tu equipo de gimnasio funcionando. 
                Partes auténticas, entrega en 3-7 días, soporte técnico en español.
              </p>
            </div>

            {/* Value propositions */}
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
              <div className="flex flex-col items-center text-center space-y-2">
                <div className="h-12 w-12 bg-white/10 rounded-full flex items-center justify-center">
                  <Search className="h-6 w-6" />
                </div>
                <span className="text-sm font-medium">Búsqueda Fácil</span>
              </div>
              <div className="flex flex-col items-center text-center space-y-2">
                <div className="h-12 w-12 bg-white/10 rounded-full flex items-center justify-center">
                  <Truck className="h-6 w-6" />
                </div>
                <span className="text-sm font-medium">Entrega Rápida</span>
              </div>
              <div className="flex flex-col items-center text-center space-y-2">
                <div className="h-12 w-12 bg-white/10 rounded-full flex items-center justify-center">
                  <Shield className="h-6 w-6" />
                </div>
                <span className="text-sm font-medium">Partes Auténticas</span>
              </div>
              <div className="flex flex-col items-center text-center space-y-2">
                <div className="h-12 w-12 bg-white/10 rounded-full flex items-center justify-center">
                  <MessageCircle className="h-6 w-6" />
                </div>
                <span className="text-sm font-medium">Soporte 24/7</span>
              </div>
            </div>

            {/* Call to action buttons */}
            <div className="flex flex-col sm:flex-row gap-4">
              <Link 
                href="/productos"
                className="btn btn-lg bg-white text-primary-600 hover:bg-gray-50 focus:ring-white flex-1 sm:flex-none"
              >
                Explorar Catálogo
              </Link>
              <Link 
                href="/whatsapp"
                className="btn btn-lg btn-outline border-white text-white hover:bg-white hover:text-primary-600 flex-1 sm:flex-none"
              >
                <MessageCircle className="h-5 w-5 mr-2" />
                Ordenar por WhatsApp
              </Link>
            </div>

            {/* Trust indicators */}
            <div className="flex items-center space-x-6 text-sm text-primary-100">
              <div className="flex items-center space-x-2">
                <div className="h-2 w-2 bg-green-400 rounded-full" />
                <span>+500 Gimnasios Servidos</span>
              </div>
              <div className="flex items-center space-x-2">
                <div className="h-2 w-2 bg-green-400 rounded-full" />
                <span>98% Satisfacción</span>
              </div>
            </div>
          </div>

          {/* Hero image/illustration */}
          <div className="relative">
            <div className="relative bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
              {/* Search demo */}
              <div className="bg-white rounded-lg p-4 shadow-xl">
                <div className="flex items-center space-x-3 mb-4">
                  <Search className="h-5 w-5 text-gray-400" />
                  <div className="h-5 bg-gray-200 rounded flex-1 animate-pulse" />
                </div>
                <div className="space-y-3">
                  <div className="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                    <div className="h-12 w-12 bg-gray-200 rounded animate-pulse" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 bg-gray-200 rounded animate-pulse" />
                      <div className="h-3 bg-gray-200 rounded animate-pulse w-3/4" />
                    </div>
                    <div className="text-primary-600 font-semibold">$299</div>
                  </div>
                  <div className="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                    <div className="h-12 w-12 bg-gray-200 rounded animate-pulse" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 bg-gray-200 rounded animate-pulse" />
                      <div className="h-3 bg-gray-200 rounded animate-pulse w-2/3" />
                    </div>
                    <div className="text-primary-600 font-semibold">$149</div>
                  </div>
                </div>
              </div>
              
              {/* Floating elements */}
              <div className="absolute -top-4 -right-4 bg-secondary-400 text-secondary-900 px-3 py-1 rounded-full text-xs font-semibold">
                ¡En Stock!
              </div>
              <div className="absolute -bottom-4 -left-4 bg-green-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                Envío Gratis
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}