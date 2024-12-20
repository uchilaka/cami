import { Invoice } from '../types'
import { composeFilterQueryParams } from '../utils'

type SortTerm = {
  field: keyof Invoice
  direction?: 'asc' | 'desc'
}

type FilterKey = keyof Pick<Invoice, 'account' | 'status' | 'dueAt' | 'amount'>

export interface InvoiceSearchProps {
  s: Partial<Record<FilterKey, SortTerm>>
  q: string
}

export const getInvoices = async (payload?: Partial<InvoiceSearchProps>) => {
  const params = composeFilterQueryParams(payload ?? {}, new URLSearchParams({ format: 'json' }))
  const result = await fetch(`/invoices?${params.toString()}`)
  const data = await result.json()
  return data
}

export default getInvoices
