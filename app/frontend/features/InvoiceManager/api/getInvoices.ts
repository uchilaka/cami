import { Invoice } from '../types'
import { composeSortQueryParams } from '../utils'

type SortKey = keyof Pick<Invoice, 'account' | 'status' | 'dueAt' | 'paidAt' | 'amount'> | 'account.email' | 'account.displayName'
type FilterKey = 'status' | 'invoiceNumber' | 'account.displayName' | 'account.email'

export interface InvoiceSearchProps {
  // Sorting
  s: Partial<Record<SortKey, 'asc' | 'desc' | null>>
  // Filtering
  f: Partial<Record<FilterKey, string>>
  // (Full-text search) query string
  q: string
}

export const getInvoices = async (payload?: Partial<InvoiceSearchProps>) => {
  const params = composeSortQueryParams(payload ?? {}, new URLSearchParams({ format: 'json' }))
  const result = await fetch(`/invoices?${params.toString()}`)
  const data = await result.json()
  return data
}

export default getInvoices
