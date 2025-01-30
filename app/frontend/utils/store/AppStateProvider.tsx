import React, { createContext, FC } from 'react'
import { StoreApi } from 'zustand'
import { AppStore } from '.'

const AppStateContext = createContext<{ store: StoreApi<AppStore> }>(null!)

export const useAppStateContext = () => React.useContext(AppStateContext)

interface AppStateProviderProps {
  store: StoreApi<AppStore>
  children: React.ReactNode
}

const AppStateProvider: FC<AppStateProviderProps> = ({ store, children }) => {
  return <AppStateContext.Provider value={{ store }}>{children}</AppStateContext.Provider>
}

export default AppStateProvider
