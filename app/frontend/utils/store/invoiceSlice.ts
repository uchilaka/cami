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

export const createInvoiceSlice: StateCreator<InvoiceSlice> = (set) => ({
  invoicesMap: {},
  selectedInvoicesMap: {},
  setInvoices: (invoices: Invoice[]) =>
    set((slice) => {
      const dataMap = invoices.reduce(
        (acc, invoice) => {
          acc[invoice.id] = invoice
          return acc
        },
        {} as Record<string, Invoice>,
      )
      return {
        ...slice,
        invoicesMap: dataMap,
      }
    }),
  setInvoicesMap: (dataMap: Record<string, Invoice>) =>
    set((slice) => {
      return {
        ...slice,
        invoicesMap: dataMap,
      }
    }),
  handleInvoiceSelectionChange: (ev: ChangeEvent<HTMLInputElement>) =>
    set((slice) => {
      const { selectedInvoicesMap: selectedMap } = slice
      const { invoiceId } = ev.currentTarget.dataset
      const { checked } = ev.currentTarget
      // TODO: Support toggling all available invoices
      if (invoiceId) {
        return {
          ...slice,
          selectedInvoicesMap: {
            ...selectedMap,
            [invoiceId]: checked,
          },
        }
      }
      return slice
    }),
})
