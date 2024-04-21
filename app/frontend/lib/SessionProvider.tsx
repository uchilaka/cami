import React from 'react'
import { User } from '../types'

export interface SessionContextProps {
  user?: User
}

interface SessionProviderProps {
  children?: React.ReactNode
}

const SessionContext = React.createContext<SessionContextProps>(null!)

export default function SessionProvider({ children }: SessionProviderProps) {
  return <SessionContext.Provider value={{}}>{children}</SessionContext.Provider>
}
