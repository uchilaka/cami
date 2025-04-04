import { create, createStore, StateCreator } from 'zustand'
import { devtools, subscribeWithSelector } from 'zustand/middleware'
// See https://github.com/pmndrs/zustand?tab=readme-ov-file#selecting-multiple-state-slices
// import { useShallow } from 'zustand/react/shallow'

import { createInvoiceSlice, InvoiceSlice } from '@/features/InvoiceManager/store/invoiceSlice'
import { AccountSlice, createAccountSlice } from '@/features/AccountManager/store/accountSlice'

/**
 * See doc on the slice pattern: https://github.com/pmndrs/zustand/blob/main/docs/guides/slices-pattern.md
 */
export type AppStore = AccountSlice & InvoiceSlice

const createAppStore: StateCreator<AppStore> = (...slices) => ({
  ...createAccountSlice(...slices),
  ...createInvoiceSlice(...slices),
})
/**
 * Global state store for the application.
 *
 * For notes on persisting state, see: https://github.com/pmndrs/zustand?tab=readme-ov-file#persist-middleware
 */
export const useAppStore = create(subscribeWithSelector<AppStore>(createAppStore))

export const useJustAppStore = create<AppStore>(createAppStore)

export const useAppStoreWithDevtools = create(devtools(subscribeWithSelector<AppStore>(createAppStore), { store: 'CAMI' }))

export const createAppStoreWithDevtools = () => createStore(devtools(subscribeWithSelector<AppStore>(createAppStore), { store: 'CAMI' }))
