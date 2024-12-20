import React, { FC, ComponentProps } from 'react'
import FilterForInvoiceStatus from './FilterForInvoiceStatus'
import FilterForInvoiceDueDate from './FilterForInvoiceDueDate'
import withAllTheProviders from '@/components/withAllTheProviders'
import { useInvoiceContext, withInvoiceProvider } from './InvoiceProvider'
import ThDueDate from './ThDueDate'
import ThStatus from './ThStatus'
import ThAmount from './ThAmount'
import InvoiceListItem from './InvoiceListItem'
import ThAccount from './ThAccount'
import InvoiceSearchInput from './InvoiceSearchInput'
import InvoicingVendorPicker from './InvoicingVendorPicker'
import { VendorType } from './types'

const InvoiceSearch: FC<ComponentProps<'div'>> = () => {
  const { invoices } = useInvoiceContext()

  console.debug({ invoices })

  const vendorSelectionHandler = (vendor: VendorType) => {
    console.debug(`Vendor changed @InvoiceSearch: ${vendor}`)
  }

  return (
    <>
      <InvoicingVendorPicker onChange={vendorSelectionHandler} />
      <div className="flex items-center justify-between flex-column flex-wrap md:flex-row space-y-4 md:space-y-0 p-4 dark:bg-gray-900">
        <div className="flex flex-row space-x-4">
          <FilterForInvoiceStatus />
          <FilterForInvoiceDueDate />
        </div>
        <InvoiceSearchInput />
      </div>

      <table className="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
        <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
          <tr>
            <th scope="col" className="p-4">
              <div className="flex items-center">
                <input
                  id="checkbox-all-search"
                  type="checkbox"
                  className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                />
                <label htmlFor="checkbox-all-search" className="sr-only">
                  checkbox
                </label>
              </div>
            </th>
            <th scope="col" className="px-6 py-3">
              Invoice #
            </th>
            <ThAccount />
            <ThDueDate />
            <ThStatus />
            <ThAmount />
            <th scope="col" className="px-6 py-3 flex justify-end">
              <div className="flex justify-end">Action</div>
            </th>
          </tr>
        </thead>
        <tbody>
          {invoices.map((invoice) => (
            <InvoiceListItem key={`row--${invoice.id}`} invoice={invoice} />
          ))}
        </tbody>
      </table>
    </>
  )
}

export default withAllTheProviders(withInvoiceProvider(InvoiceSearch))
