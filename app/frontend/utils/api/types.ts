type AccountStatus = 'demo' | 'guest' | 'active' | 'payment_due' | 'overdue' | 'paid' | 'suspended' | 'deactivated'

export interface Account {
  id: string
  displayName: string
  email?: string
  slug: string
  status: AccountStatus
}

export interface IndividualAccount extends Account {
  type: 'Individual'
  email: string
}

export interface BusinessAccount extends Account {
  type: 'Business'
  taxId: string
}

export const isValidAccount = (account: IndividualAccount | BusinessAccount | null): account is IndividualAccount | BusinessAccount => {
  return !!account && !!account.displayName && !!account.slug && !!account.type
}

export const isIndividualAccount = (account: IndividualAccount | BusinessAccount | null): account is IndividualAccount => {
  return isValidAccount(account) && account.type === 'Individual'
}

export const isBusinessAccount = (account: IndividualAccount | BusinessAccount | null): account is BusinessAccount => {
  return isValidAccount(account) && account.type === 'Business'
}
