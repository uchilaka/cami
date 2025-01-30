import { ChangeEvent } from 'react'
import { Invoice } from '@/features/InvoiceManager/types'
import { StateCreator } from 'zustand'
/**
 * See slice pattern: https://github.com/pmndrs/zustand/blob/main/docs/guides/slices-pattern.md
 */
export interface InvoiceSlice {
  invoicesMap: Record<string, Invoice>
  selectedInvoicesMap: Record<string, boolean>
  setInvoices: (invoices: Invoice[]) => void
  setInvoicesMap: (invoiceMap: Record<string, Invoice>) => void
  handleInvoiceSelectionChange: (ev: ChangeEvent<HTMLInputElement>) => void
}

export const createInvoiceSlice: StateCreator<InvoiceSlice> = (set, _get) => ({
  invoicesMap: {},
  selectedInvoicesMap: {},
  setInvoices: (invoices: Invoice[]) =>
    set((slice) => {
      const invoicesMap = invoices.reduce(
        (acc, invoice) => {
          acc[invoice.id] = invoice
          return acc
        },
        {} as Record<string, Invoice>,
      )
      return {
        ...slice,
        invoicesMap,
      }
    }),
  setInvoicesMap: (invoicesMap: Record<string, Invoice>) =>
    set((slice) => {
      return {
        ...slice,
        invoicesMap,
      }
    }),
  handleInvoiceSelectionChange: (ev: ChangeEvent<HTMLInputElement>) =>
    set((slice) => {
      console.warn('>> Invoice slice is about to be updated <<', { ...slice })
      const { selectedInvoicesMap } = slice
      const { invoiceId } = ev.currentTarget.dataset
      const { checked } = ev.currentTarget
      // TODO: Support toggling all available invoices
      if (invoiceId) {
        return {
          ...slice,
          selectedInvoicesMap: {
            ...selectedInvoicesMap,
            [invoiceId]: checked,
          },
        }
      }
      return slice
    }),
})
