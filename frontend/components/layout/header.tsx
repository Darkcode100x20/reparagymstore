"use client"

import Link from 'next/link'
import Image from 'next/image'
import { useState } from 'react'
import { Menu, X, MessageCircle } from 'lucide-react'

const navItems = [
  { href: '/productos', label: 'Productos' },
  { href: '/marcas', label: 'Marcas' },
  { href: '/soporte', label: 'Soporte' },
  { href: '/contacto', label: 'Contacto' },
]

export function Header() {
  const [mobileOpen, setMobileOpen] = useState(false)

  return (
    <header className="sticky top-0 z-40 bg-white/80 backdrop-blur-sm border-b border-gray-200">
      <div className="container-custom h-16 flex items-center justify-between">
        {/* Brand */}
        <div className="flex items-center gap-3">
          <Link href="/" className="flex items-center gap-2" aria-label="ReparagymStore inicio">
            <Image src="/logo.svg" alt="ReparagymStore" width={148} height={32} priority />
          </Link>
        </div>

        {/* Desktop nav */}
        <nav className="hidden md:flex items-center gap-6">
          {navItems.map((item) => (
            <Link key={item.href} href={item.href} className="nav-link-inactive">
              {item.label}
            </Link>
          ))}
        </nav>

        {/* Actions */}
        <div className="hidden md:flex items-center gap-3">
          <Link href="/whatsapp" className="btn btn-sm btn-primary">
            <MessageCircle className="h-4 w-4 mr-2" />
            WhatsApp
          </Link>
        </div>

        {/* Mobile toggle */}
        <button
          aria-label="Abrir menú"
          className="md:hidden inline-flex items-center justify-center rounded-md p-2 text-gray-700 hover:bg-gray-100"
          onClick={() => setMobileOpen((v) => !v)}
        >
          {mobileOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </button>
      </div>

      {/* Mobile nav */}
      {mobileOpen && (
        <div className="md:hidden border-t border-gray-200 bg-white">
          <nav className="container-custom py-3 flex flex-col">
            {navItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="nav-link-inactive"
                onClick={() => setMobileOpen(false)}
              >
                {item.label}
              </Link>
            ))}
            <Link href="/whatsapp" className="btn btn-md btn-primary mt-2" onClick={() => setMobileOpen(false)}>
              <MessageCircle className="h-5 w-5 mr-2" />
              WhatsApp
            </Link>
          </nav>
        </div>
      )}
    </header>
  )
}



