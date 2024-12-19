import { getInvoices, InvoiceSearchProps } from '@/utils/api'
import { Invoice } from '@/utils/api/types'
import { useQuery } from '@tanstack/react-query'
import { useState } from 'react'

export const useInvoiceSearchQuery = (props?: Partial<InvoiceSearchProps>) => {
  const [invoices, setInvoices] = useState<Invoice[]>([])

  const query = useQuery({
    queryKey: ['invoiceSearch'],
    queryFn: async () => {
      const data = await getInvoices(props)
      setInvoices(data)
      return data
    },
  })

  return { query, invoices }
}
