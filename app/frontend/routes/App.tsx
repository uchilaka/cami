import React, { lazy } from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'

import Root from '@/components/Root'

const Dashboard = lazy(() => import('@/features/Dashboard'))
const InvoiceSearch = lazy(() => import('@/features/InvoiceManager/InvoiceSearch'))
const AboutUs = lazy(() => import('@/routes/AboutUs'))
const LandingPage = lazy(() => import('@/routes/LandingPage'))
const SetupWizard = lazy(() => import('@/routes/SetupWizard'))
const TermsOfService = lazy(() => import('@/routes/TermsOfService'))
const PrivacyPolicy = lazy(() => import('@/routes/PrivacyPolicy'))

// See: https://reactrouter.com/6.28.2/start/overview
const router = createBrowserRouter([
  {
    path: '/app',
    element: <Root />,
    children: [
      { path: 'about', element: <AboutUs /> },
      { path: 'legal/terms', element: <TermsOfService /> },
      { path: 'legal/privacy', element: <PrivacyPolicy /> },
      { path: 'services/setup', element: <SetupWizard /> },
      { path: 'dashboard', element: <Dashboard /> },
      { path: 'invoices', element: <InvoiceSearch /> },
      { path: 'home', element: <LandingPage /> },
    ],
  },
  {
    path: '/',
    element: <Root />,
    children: [{ path: '/', element: <LandingPage /> }],
  },
])

export default function App() {
  return (
    <React.StrictMode>
      <RouterProvider router={router} />
    </React.StrictMode>
  )
}
