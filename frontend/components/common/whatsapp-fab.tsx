"use client"

import Link from 'next/link'
import { MessageCircle } from 'lucide-react'

export function WhatsAppFAB() {
  return (
    <Link
      href="/whatsapp"
      aria-label="Chatear por WhatsApp"
      className="whatsapp-button"
    >
      <MessageCircle className="h-7 w-7" />
    </Link>
  )
}



