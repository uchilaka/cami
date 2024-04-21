import React from 'react'
import { Outlet } from 'react-router-dom'

import SessionProvider from '../lib/SessionProvider'

export default function Root() {
  return (
    <SessionProvider>
      <Outlet />
    </SessionProvider>
  )
}
