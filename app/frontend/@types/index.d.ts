import { StoreApi } from 'zustand'
import { AppStore } from '../utils/store'

declare global {
  interface Document {
    appStore: StoreApi<AppStore>
  }
}

export {}
