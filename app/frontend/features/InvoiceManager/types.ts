import { GenericAccount } from '@/utils/api/GenericAccount'

export type VendorType = 'paypal' | 'hubspot' | 'stripe'

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
  paidAt?: Date
  // eslint-disable-next-line no-use-before-define
  account?: GenericAccount
  isRecurring?: boolean
  tooltipId?: string
  itemActionBtnClasses?: string
  paymentVendorURL: string
}
