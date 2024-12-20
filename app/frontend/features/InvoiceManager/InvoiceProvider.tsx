import React, {
  FC,
  createContext,
  ComponentType,
  Dispatch,
  ReactNode,
  SetStateAction,
  useCallback,
  useContext,
  useEffect,
  useState,
} from 'react'
import { LoadInvoiceEventDetail, nsEventName } from '@/utils'
import { useInvoiceSearchQuery } from './hooks/useInvoiceSearchQuery'
import { InvoiceSearchProps } from './api'
import { Invoice } from './types'

interface InvoiceContextProps {
  listenForInvoiceLoadEvents: () => AbortController
  setInvoiceId: Dispatch<SetStateAction<string | undefined>>
  setFilterParams: Dispatch<SetStateAction<Partial<InvoiceSearchProps>>>
  updateFilterParams: (newParams: Partial<InvoiceSearchProps>) => void
  reload: () => Promise<void>
  filterParams?: Partial<InvoiceSearchProps>
  loading?: boolean
  invoice?: Invoice | null
  invoices: Invoice[]
}

const InvoiceContext = createContext<InvoiceContextProps>(null!)

export const useInvoiceContext = () => useContext(InvoiceContext)

export const InvoiceProvider: FC<{ children: ReactNode }> = ({ children }) => {
  const [filterParams, setFilterParams] = useState<Partial<InvoiceSearchProps>>({})
  const [queryParams] = useState<Partial<InvoiceSearchProps>>({})
  const [invoiceId, setInvoiceId] = useState<string>()
  const [loading, setLoading] = useState<boolean>()
  const { invoices, query } = useInvoiceSearchQuery({ ...filterParams, ...queryParams })

  const reload = useCallback(async () => {
    console.debug(`Loading invoices:`, { query })
    setLoading(true)
    const result = await query.refetch()
    console.debug({ result })
    if (result.isSuccess) setLoading(false)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query, invoiceId])

  const listenForInvoiceLoadEvents = () => {
    const invoiceLoader = new AbortController()
    document.addEventListener(
      nsEventName('invoice:load'),
      (ev) => {
        const { detail } = ev as CustomEvent<LoadInvoiceEventDetail>
        console.debug(`Received request to load invoice: ${detail.invoiceId}`)
        setInvoiceId(detail.invoiceId)
      },
      /**
       * https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#options
       */
      { capture: true, passive: true, signal: invoiceLoader.signal },
    )
    return invoiceLoader
  }

  const updateFilterParams = useCallback(({ s, q }: Partial<InvoiceSearchProps>) => {}, [filterParams])

  useEffect(() => {
    if (invoiceId) reload()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [invoiceId])

  return (
    <InvoiceContext.Provider
      value={{ filterParams, invoices, loading, reload, listenForInvoiceLoadEvents, setInvoiceId, setFilterParams, updateFilterParams }}
    >
      {children}
    </InvoiceContext.Provider>
  )
}

export const withInvoiceProvider = <P extends {}>(WrappedComponent: ComponentType<P>) => {
  const displayName = WrappedComponent.displayName ?? WrappedComponent.name ?? 'Component'
  /**
   * TODO: Should the ComponentWithInvoiceProvider props be typed as `P` instead of `any`?
   */
  const ComponentWithInvoiceProvider = (props: any) => (
    <InvoiceProvider>
      <WrappedComponent {...props} />
    </InvoiceProvider>
  )
  ComponentWithInvoiceProvider.displayName = `withInvoiceProvider(${displayName})`
  return ComponentWithInvoiceProvider
}
