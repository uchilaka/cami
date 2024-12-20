import { Invoice } from '../types'

export interface InvoiceSearchProps {
  field: keyof Invoice
  direction: 'asc' | 'desc'
  q?: string
}

export const getInvoices = async (payload?: Partial<InvoiceSearchProps>) => {
  const params = new URLSearchParams({ ...(payload ?? {}), format: 'json' })
  const result = await fetch(`/invoices?${params.toString()}`)
  const data = await result.json()
  return data
}

export default getInvoices
