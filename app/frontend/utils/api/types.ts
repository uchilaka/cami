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
  formattedValue: string
  currencyCode: string
}

export interface Invoice {
  id: string
  vendorRecordId: string
  paymentVendor: 'paypal' | 'stripe'
  createdAt: Date
  dueAt: Date
  updatedAt: Date
  number: string
  status: 'PAID' | 'OVERDUE' | 'SENT'
  amount: InvoiceAmount
  isRecurring?: boolean
  tooltipId?: string
  itemActionBtnClasses?: string
  paymentVendorURL: string
}

interface UserProfile {
  id: string
  givenName?: string
  familyName?: string
  phone?: string
}

interface RichText {
  html: string
  plaintext: string
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
  readme?: RichText
}

export interface IndividualAccount extends Account {
  type: 'Individual'
  email: string
  profile?: UserProfile
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
