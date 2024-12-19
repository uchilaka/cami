import React from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'

import Root from '@/components/Root'
import AboutUs from '@/routes/AboutUs'
import LangingPage from '@/routes/LandingPage'
import SetupWizard from '@/routes/SetupWizard'
import TermsOfService from '@/routes/TermsOfService'
import PrivacyPolicy from '@/routes/PrivacyPolicy'

const router = createBrowserRouter([
  {
    path: '/',
    element: <Root />,
    children: [
      { path: 'app/about', element: <AboutUs /> },
      { path: 'app/legal/terms', element: <TermsOfService /> },
      { path: 'app/legal/privacy', element: <PrivacyPolicy /> },
      { path: 'app/services/setup', element: <SetupWizard /> },
      { path: '', element: <LangingPage /> },
    ],
  },
])

export default function Home() {
  return (
    <React.StrictMode>
      <RouterProvider router={router} />
    </React.StrictMode>
  )
}
