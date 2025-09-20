import Link from 'next/link'
import { MessageCircle, Search, Phone } from 'lucide-react'

export function CallToAction() {
  return (
    <section className="py-16 bg-gradient-to-r from-primary-600 to-primary-700 text-white">
      <div className="container-custom">
        <div className="max-w-4xl mx-auto text-center">
          {/* Main CTA */}
          <div className="space-y-6 mb-12">
            <h2 className="text-3xl sm:text-4xl font-bold font-display">
              ¿Listo para Encontrar la Refacción que Necesitas?
            </h2>
            <p className="text-xl text-primary-100 leading-relaxed">
              Nuestro equipo está aquí para ayudarte a mantener tu gimnasio funcionando al 100%. 
              Encuentra la refacción correcta o contáctanos para asesoría personalizada.
            </p>
          </div>

          {/* Action buttons */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-12">
            <Link
              href="/productos"
              className="flex flex-col items-center p-6 bg-white/10 backdrop-blur-sm rounded-xl border border-white/20 hover:bg-white/20 transition-all duration-300 group"
            >
              <div className="h-12 w-12 bg-white/20 rounded-full flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                <Search className="h-6 w-6" />
              </div>
              <h3 className="font-semibold mb-2">Explorar Catálogo</h3>
              <p className="text-sm text-primary-100">Busca por categoría, marca o modelo</p>
            </Link>

            <Link
              href="/whatsapp"
              className="flex flex-col items-center p-6 bg-white/10 backdrop-blur-sm rounded-xl border border-white/20 hover:bg-white/20 transition-all duration-300 group"
            >
              <div className="h-12 w-12 bg-green-500 rounded-full flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                <MessageCircle className="h-6 w-6" />
              </div>
              <h3 className="font-semibold mb-2">WhatsApp</h3>
              <p className="text-sm text-primary-100">Orden rápida con asesoría personalizada</p>
            </Link>

            <Link
              href="/contacto"
              className="flex flex-col items-center p-6 bg-white/10 backdrop-blur-sm rounded-xl border border-white/20 hover:bg-white/20 transition-all duration-300 group"
            >
              <div className="h-12 w-12 bg-white/20 rounded-full flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                <Phone className="h-6 w-6" />
              </div>
              <h3 className="font-semibold mb-2">Llamar Ahora</h3>
              <p className="text-sm text-primary-100">Habla directo con nuestros técnicos</p>
            </Link>
          </div>

          {/* Contact info */}
          <div className="border-t border-white/20 pt-8">
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 text-center">
              <div>
                <div className="font-semibold mb-1">Teléfono</div>
                <div className="text-primary-100">55 1234 5678</div>
              </div>
              <div>
                <div className="font-semibold mb-1">WhatsApp</div>
                <div className="text-primary-100">55 9876 5432</div>
              </div>
              <div>
                <div className="font-semibold mb-1">Email</div>
                <div className="text-primary-100">soporte@reparagymstore.com</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}