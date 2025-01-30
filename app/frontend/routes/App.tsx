import React, { FC, lazy } from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

import Root from '@/components/Root'
import { AppGlobalProps } from '@/utils'
import AppStateProvider from '@/utils/store/AppStateProvider'

const Dashboard = lazy(() => import('@/features/Dashboard'))
const InvoiceSearch = lazy(() => import('@/features/InvoiceManager/InvoiceSearch'))
const AboutUs = lazy(() => import('@/routes/AboutUs'))
const LandingPage = lazy(() => import('@/routes/LandingPage'))
const SetupWizard = lazy(() => import('@/routes/SetupWizard'))
const TermsOfService = lazy(() => import('@/routes/TermsOfService'))
const PrivacyPolicy = lazy(() => import('@/routes/PrivacyPolicy'))

/**
 * See: https://reactrouter.com/6.28.2/start/overview
 * @returns JSX.Element
 */
const App: FC<AppGlobalProps> = ({ appStore }) => {
  return (
    <React.StrictMode>
      <AppStateProvider store={appStore}>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Root />}>
              <Route index element={<LandingPage />} />
              <Route path="app">
                <Route path="about" element={<AboutUs />} />
                <Route path="legal/terms" element={<TermsOfService />} />
                <Route path="legal/privacy" element={<PrivacyPolicy />} />
                <Route path="services/setup" element={<SetupWizard />} />
                <Route path="dashboard" element={<Dashboard />} />
                <Route path="invoices" element={<InvoiceSearch />} />
                <Route path="home" element={<LandingPage />} />
              </Route>
            </Route>
          </Routes>
        </BrowserRouter>
      </AppStateProvider>
    </React.StrictMode>
  )
}

export default App
