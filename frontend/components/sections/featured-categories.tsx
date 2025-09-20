import Link from 'next/link'
import { Dumbbell, Zap, Cable, Settings } from 'lucide-react'

const categories = [
  {
    id: 'cardio',
    name: 'Cardio Equipment',
    spanish: 'Equipo Cardiovascular',
    description: 'Bandas, motores, consolas',
    icon: Zap,
    href: '/productos/cardio',
    count: 150,
    color: 'bg-blue-500'
  },
  {
    id: 'strength',
    name: 'Strength Equipment', 
    spanish: 'Equipo de Fuerza',
    description: 'Poleas, cables, pesas',
    icon: Dumbbell,
    href: '/productos/fuerza',
    count: 200,
    color: 'bg-red-500'
  },
  {
    id: 'electronics',
    name: 'Electronics',
    spanish: 'Electrónicos',
    description: 'Tableros, sensores, controles',
    icon: Settings,
    href: '/productos/electronicos',
    count: 75,
    color: 'bg-green-500'
  },
  {
    id: 'cables',
    name: 'Cables & Hardware',
    spanish: 'Cables y Herrajes',
    description: 'Cables, conectores, tornillos',
    icon: Cable,
    href: '/productos/cables',
    count: 300,
    color: 'bg-purple-500'
  }
]

export function FeaturedCategories() {
  return (
    <section className="py-16 bg-white">
      <div className="container-custom">
        {/* Section header */}
        <div className="text-center max-w-3xl mx-auto mb-12">
          <h2 className="text-3xl sm:text-4xl font-bold font-display text-gray-900 mb-4">
            Encuentra lo que Necesitas
          </h2>
          <p className="text-lg text-gray-600">
            Explora nuestras categorías principales de refacciones para equipo de gimnasio. 
            Tenemos todo lo que necesitas para mantener tu gimnasio funcionando.
          </p>
        </div>

        {/* Categories grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {categories.map((category) => {
            const Icon = category.icon
            return (
              <Link
                key={category.id}
                href={category.href}
                className="group relative bg-white rounded-xl border border-gray-200 p-6 hover:border-primary-300 hover:shadow-lg transition-all duration-300"
              >
                {/* Icon */}
                <div className={`inline-flex h-12 w-12 items-center justify-center rounded-lg ${category.color} mb-4 group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="h-6 w-6 text-white" />
                </div>

                {/* Content */}
                <div className="space-y-2">
                  <h3 className="text-lg font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">
                    {category.spanish}
                  </h3>
                  <p className="text-sm text-gray-600">
                    {category.description}
                  </p>
                  <div className="flex items-center justify-between pt-2">
                    <span className="text-sm font-medium text-primary-600">
                      {category.count} productos
                    </span>
                    <span className="text-sm text-gray-400 group-hover:text-primary-500 transition-colors">
                      Ver todos →
                    </span>
                  </div>
                </div>

                {/* Hover overlay */}
                <div className="absolute inset-0 rounded-xl bg-primary-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10" />
              </Link>
            )
          })}
        </div>

        {/* CTA */}
        <div className="text-center mt-12">
          <Link
            href="/productos"
            className="btn btn-primary btn-lg"
          >
            Ver Todos los Productos
          </Link>
        </div>
      </div>
    </section>
  )
}