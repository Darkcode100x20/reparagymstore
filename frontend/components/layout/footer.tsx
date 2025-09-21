import Link from 'next/link'

const footerLinks = {
  productos: [
    { href: '/productos/cardio', label: 'Cardio' },
    { href: '/productos/fuerza', label: 'Fuerza' },
    { href: '/productos/electronicos', label: 'Electrónicos' },
    { href: '/productos/cables', label: 'Cables y Herrajes' },
  ],
  empresa: [
    { href: '/sobre', label: 'Sobre Nosotros' },
    { href: '/soporte', label: 'Soporte' },
    { href: '/contacto', label: 'Contacto' },
    { href: '/politicas/privacidad', label: 'Aviso de Privacidad' },
  ],
  ayuda: [
    { href: '/envios', label: 'Envíos y Entregas' },
    { href: '/devoluciones', label: 'Devoluciones' },
    { href: '/garantia', label: 'Garantía' },
    { href: '/faq', label: 'Preguntas Frecuentes' },
  ],
}

export function Footer() {
  return (
    <footer className="bg-white border-t border-gray-200">
      <div className="container-custom py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <div className="h-8 w-8 rounded-lg mexican-flag-border" />
              <span className="font-display text-xl font-semibold">ReparagymStore</span>
            </div>
            <p className="text-sm text-gray-600 mb-4">
              Refacciones auténticas para equipo de gimnasio en México. Entrega rápida y soporte técnico en español.
            </p>
            <div className="text-sm text-gray-600">
              <div>Tel: 55 1234 5678</div>
              <div>WhatsApp: 55 9876 5432</div>
              <div>Email: soporte@reparagymstore.com</div>
            </div>
          </div>

          {/* Links */}
          <div>
            <h4 className="text-sm font-semibold text-gray-900 mb-3">Productos</h4>
            <ul className="space-y-2">
              {footerLinks.productos.map((l) => (
                <li key={l.href}>
                  <Link href={l.href} className="text-sm text-gray-600 hover:text-gray-900">
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="text-sm font-semibold text-gray-900 mb-3">Empresa</h4>
            <ul className="space-y-2">
              {footerLinks.empresa.map((l) => (
                <li key={l.href}>
                  <Link href={l.href} className="text-sm text-gray-600 hover:text-gray-900">
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="text-sm font-semibold text-gray-900 mb-3">Ayuda</h4>
            <ul className="space-y-2">
              {footerLinks.ayuda.map((l) => (
                <li key={l.href}>
                  <Link href={l.href} className="text-sm text-gray-600 hover:text-gray-900">
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>

      <div className="border-t border-gray-200">
        <div className="container-custom py-6 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-sm text-gray-500">© {new Date().getFullYear()} ReparagymStore. Todos los derechos reservados.</p>
          <div className="flex items-center gap-4 text-sm text-gray-500">
            <Link href="/politicas/terminos">Términos</Link>
            <Link href="/politicas/privacidad">Privacidad</Link>
            <Link href="/politicas/cookies">Cookies</Link>
          </div>
        </div>
      </div>
    </footer>
  )
}



