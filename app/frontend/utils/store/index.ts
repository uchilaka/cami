import { create, createStore } from 'zustand'
import { devtools } from 'zustand/middleware'
// See https://github.com/pmndrs/zustand?tab=readme-ov-file#selecting-multiple-state-slices
// import { useShallow } from 'zustand/react/shallow'

import { createInvoiceSlice, InvoiceSlice } from './invoiceSlice'

export type AppStore = InvoiceSlice

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

export const createAppStoreWithDevtools = () =>
  createStore(
    devtools<AppStore>(
      (...slices) => ({
        ...createInvoiceSlice(...slices),
      }),
      { store: 'CAMI' },
    ),
  )
