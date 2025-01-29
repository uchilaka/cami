import React, { lazy } from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'

const AccountContextMenu = lazy(() => import('@/features/AccountManager/AccountContextMenu'))
const InvoiceContextMenu = lazy(() => import('@/features/InvoiceManager/InvoiceContextMenu'))

const router = createBrowserRouter([
  {
    path: '/accounts',
    element: <AccountContextMenu />,
  },
  {
    path: '/app',
    children: [
      {
        path: 'invoices',
        element: <InvoiceContextMenu />,
      },
      { path: '*', element: <></> },
    ],
  },
  {
    path: '/',
    element: <></>,
  },
])

const AppContextMenu = () => {
  return (
    <React.StrictMode>
      <RouterProvider router={router} />
    </React.StrictMode>
  )
}

export default AppContextMenu
