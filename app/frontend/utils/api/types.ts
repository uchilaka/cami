type AccountStatus = 'demo' | 'guest' | 'active' | 'payment_due' | 'overdue' | 'paid' | 'suspended' | 'deactivated'

interface AccountAction {
  domId: string
  httpMethod: 'GET' | 'POST' | 'PUT' | 'DELETE'
  label: string
  url: string
}

type ActionKey = 'delete' | 'edit' | 'show' | 'showProfile' | 'profilesIndex' | 'transactionsIndex'

interface InvoiceAmount {
  value: number
  currencyCode: string
}

interface Invoice {
  id: string
  createdAt: Date
  dueAt: Date
  updatedAt: Date
  number: string
  status: 'PAID' | 'OVERDUE' | 'SENT'
  amount: InvoiceAmount
}
export interface Account {
  id: string
  displayName: string
  slug: string
  status: AccountStatus
  isVendor: boolean
  actions: Record<ActionKey, AccountAction>
  invoices: Invoice[]
  email?: string
  readme?: string
}

export interface IndividualAccount extends Account {
  type: 'Individual'
  email: string
}

export interface BusinessAccount extends Account {
  type: 'Business'
  taxId: string
  phone: string
}

export const isValidAccount = (account?: IndividualAccount | BusinessAccount | null): account is IndividualAccount | BusinessAccount => {
  return !!account && !!account.displayName && !!account.slug && !!account.type
}

export const isActionableAccount = (
  account?: IndividualAccount | BusinessAccount | null,
): account is IndividualAccount | BusinessAccount => {
  return isValidAccount(account) && !!account.actions
}

export const isIndividualAccount = (account?: IndividualAccount | BusinessAccount | null): account is IndividualAccount => {
  return isValidAccount(account) && account.type === 'Individual'
}

export const isBusinessAccount = (account?: IndividualAccount | BusinessAccount | null): account is BusinessAccount => {
  return isValidAccount(account) && account.type === 'Business'
}

export const arrayHasItems = <T>(array: T[] | null | undefined): array is T[] => {
  return Array.isArray(array) && array.length > 0
}
