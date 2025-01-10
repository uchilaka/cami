import { InvoiceSearchProps } from '../types'

export const findInvoices = async (payload?: Partial<InvoiceSearchProps>) => {
  console.debug(`Finding invoices with payload:`, { ...payload })
  const result = await fetch('/invoices/search.json', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })
  const data = await result.json()
  return data
}

export default findInvoices
