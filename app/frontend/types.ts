import { ReactNode } from 'react'

export interface User {
  id: string
  givenName: string
  familyName: string
  email: string
}

export interface CookieSetOptions {
  path?: string
  expires?: Date
  maxAge?: number
  domain?: string
  secure?: boolean
  httpOnly?: boolean
  sameSite?: boolean | 'strict' | 'lax' | 'none'
  partitioned?: boolean
}

export type AppCookies = Record<string, any> & {
  _account_manager_session?: string
}

export interface ValidationFeedbackProps {
  success?: boolean
  error?: boolean
}

export interface FormInputProps extends ValidationFeedbackProps {
  label: string
  name: string
  placeholder?: string
  hint?: ReactNode
}
