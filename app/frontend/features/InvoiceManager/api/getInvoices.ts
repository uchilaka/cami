import { InvoiceSearchProps } from '../types'
import { composeQueryParams } from '../utils'

export const getInvoices = async (payload?: Partial<InvoiceSearchProps>) => {
  console.debug(`Fetching invoices with payload:`, { ...payload })
  const params = composeQueryParams(payload ?? {}, new URLSearchParams({ format: 'json' }))
  const result = await fetch(`/invoices?${params.toString()}`)
  const data = await result.json()
  return data
}

export default getInvoices
