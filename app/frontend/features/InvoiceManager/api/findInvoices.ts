import { Invoice, InvoiceSearchProps } from '../types'

interface FindInvoiceOptions {
  signal: AbortSignal
}

type FindInvoiceFn = (payload: Partial<InvoiceSearchProps>, options?: Partial<FindInvoiceOptions>) => Promise<Invoice[]>

export const findInvoices: FindInvoiceFn = async (payload: Partial<InvoiceSearchProps>, { signal } = {}) => {
  console.debug(`Finding invoices with payload:`, { ...payload })
  const result = await fetch('/invoices/search.json', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
    signal,
  })
  const data = await result.json()
  return data
}

export default findInvoices
