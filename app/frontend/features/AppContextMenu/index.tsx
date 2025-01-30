import { AppGlobalProps } from '@/utils'
import AppStateProvider from '@/utils/store/AppStateProvider'
import React, { FC, lazy } from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

const AccountContextMenu = lazy(() => import('@/features/AccountManager/AccountContextMenu'))
const InvoiceContextMenu = lazy(() => import('@/features/InvoiceManager/InvoiceContextMenu'))

const AppContextMenu: FC<AppGlobalProps> = ({ appStore }) => {
  return (
    <React.StrictMode>
      <AppStateProvider store={appStore}>
        <BrowserRouter>
          <Routes>
            <Route path="/accounts" element={<AccountContextMenu />} />
            <Route path="/app">
              <Route path="invoices" element={<InvoiceContextMenu />} />
              <Route path="*" element={<></>} />
            </Route>
            <Route path="*" element={<></>} />
          </Routes>
        </BrowserRouter>
      </AppStateProvider>
    </React.StrictMode>
  )
}

export default AppContextMenu
