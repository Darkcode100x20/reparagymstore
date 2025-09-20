import { Clock, Shield, MessageCircle, Truck, CheckCircle, Users } from 'lucide-react'

const features = [
  {
    icon: Clock,
    title: 'Entrega Rápida',
    description: 'Entrega en 3-7 días a toda la República Mexicana con opciones de envío express disponibles.',
    stat: '3-7 días',
    color: 'text-blue-600 bg-blue-100'
  },
  {
    icon: Shield,
    title: 'Partes Auténticas',
    description: 'Garantizamos la autenticidad de todas nuestras refacciones con certificados de calidad.',
    stat: '100% Genuinas',
    color: 'text-green-600 bg-green-100'
  },
  {
    icon: MessageCircle,
    title: 'Soporte en Español',
    description: 'Nuestro equipo técnico especializado te ayuda a encontrar exactamente lo que necesitas.',
    stat: '24/7 Disponible',
    color: 'text-purple-600 bg-purple-100'
  },
  {
    icon: Truck,
    title: 'Envío Gratis',
    description: 'Envío gratuito en pedidos mayores a $1,500 MXN a toda la República Mexicana.',
    stat: '+$1,500 MXN',
    color: 'text-orange-600 bg-orange-100'
  },
  {
    icon: CheckCircle,
    title: 'Garantía Extendida',
    description: 'Todas nuestras refacciones incluyen garantía de 12 meses contra defectos de fabricación.',
    stat: '12 Meses',
    color: 'text-red-600 bg-red-100'
  },
  {
    icon: Users,
    title: 'Experiencia Comprobada',
    description: 'Más de 500 gimnasios en México confían en nosotros para mantener su equipo funcionando.',
    stat: '+500 Clientes',
    color: 'text-indigo-600 bg-indigo-100'
  }
]

export function WhyChooseUs() {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container-custom">
        {/* Section header */}
        <div className="text-center max-w-3xl mx-auto mb-12">
          <h2 className="text-3xl sm:text-4xl font-bold font-display text-gray-900 mb-4">
            ¿Por qué Elegir ReparagymStore?
          </h2>
          <p className="text-lg text-gray-600">
            Somos el proveedor líder de refacciones para gimnasio en México. 
            Nuestra experiencia y compromiso con la calidad nos distingue.
          </p>
        </div>

        {/* Features grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => {
            const Icon = feature.icon
            return (
              <div
                key={index}
                className="bg-white rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow duration-300"
              >
                {/* Icon and stat */}
                <div className="flex items-center justify-between mb-4">
                  <div className={`inline-flex h-12 w-12 items-center justify-center rounded-lg ${feature.color}`}>
                    <Icon className="h-6 w-6" />
                  </div>
                  <span className="text-sm font-bold text-primary-600 bg-primary-50 px-3 py-1 rounded-full">
                    {feature.stat}
                  </span>
                </div>

                {/* Content */}
                <div className="space-y-2">
                  <h3 className="text-lg font-semibold text-gray-900">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 leading-relaxed">
                    {feature.description}
                  </p>
                </div>
              </div>
            )
          })}
        </div>

        {/* Trust indicators */}
        <div className="mt-16 border-t border-gray-200 pt-12">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="text-3xl font-bold text-primary-600 mb-2">500+</div>
              <div className="text-sm text-gray-600">Gimnasios Atendidos</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-primary-600 mb-2">98%</div>
              <div className="text-sm text-gray-600">Satisfacción Cliente</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-primary-600 mb-2">5,000+</div>
              <div className="text-sm text-gray-600">Productos en Stock</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-primary-600 mb-2">24/7</div>
              <div className="text-sm text-gray-600">Soporte Técnico</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}