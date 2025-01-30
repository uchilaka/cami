import { ChangeEvent } from 'react'
import { create } from 'zustand'
import { devtools } from 'zustand/middleware'
// See https://github.com/pmndrs/zustand?tab=readme-ov-file#selecting-multiple-state-slices
// import { useShallow } from 'zustand/react/shallow'
import { Invoice } from '@/features/InvoiceManager/types'
import { createInvoiceSlice } from './invoiceSlice'

/**
 * See slice pattern: https://github.com/pmndrs/zustand/blob/main/docs/guides/slices-pattern.md
 */
interface InvoiceSlice {
  invoicesMap: Record<string, Invoice>
  selectedInvoicesMap: Record<string, boolean>
  setInvoicesMap: (invoiceMap: Record<string, Invoice>) => void
  handleInvoiceSelectionChange: (ev: ChangeEvent<HTMLInputElement>) => void
}

type AppStore = InvoiceSlice

/**
 * Global state store for the application.
 *
 * For notes on persisting state, see: https://github.com/pmndrs/zustand?tab=readme-ov-file#persist-middleware
 */
export const useAppStore = create<AppStore>((...slices) => ({
  ...createInvoiceSlice(...slices),
}))

export const useAppStoreWithDevtools = create(
  devtools<AppStore>(
    (...slices) => ({
      ...createInvoiceSlice(...slices),
    }),
    { store: 'CAMI' },
  ),
)
