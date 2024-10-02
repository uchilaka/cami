import React from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'

import Root from '@/components/Root'
import AboutUs from '@/routes/AboutUs'
import LangingPage from '@/routes/LandingPage'
import SetupWizard from '@/routes/SetupWizard'

const router = createBrowserRouter([
  {
    path: '/',
    element: <Root />,
    children: [
      { path: 'app/about', element: <AboutUs /> },
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
