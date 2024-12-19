import { BusinessAccount, IndividualAccount, Invoice } from './api/types'

/**
 * Event detail types should support state composition i.e. if we
 * merged them all together, there should still be the integrity
 * of the data slices within each of them.
 */
export type LoadAccountEventDetail = {
  accountId: string
}

export type LoadInvoiceEventDetail = {
  invoiceId: string
}

export type LoadedAccountEventDetail = {
  account: IndividualAccount | BusinessAccount
}

export type LoadedInvoiceEventDetail = {
  invoice: Invoice
}
