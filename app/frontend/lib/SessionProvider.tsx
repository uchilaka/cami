import React from 'react'
import { useCookies } from 'react-cookie'

import { User } from '../types'

export interface SessionContextProps {
  user?: User
}

interface SessionProviderProps {
  children?: React.ReactNode
}

const SessionContext = React.createContext<SessionContextProps>(null!)

export default function SessionProvider({ children }: SessionProviderProps) {
  const [cookies, setCookie, removeCookie] = useCookies(['_account_manager_session'])
  console.debug({ cookies })

  return <SessionContext.Provider value={{}}>{children}</SessionContext.Provider>
}
