import React, { FC } from 'react'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'
import { Invoice } from './types'
import FilterableBadge from './InvoiceBadge/FilterableBadge'
import StaticBadge from './InvoiceBadge/StaticBadge'
import InvoiceDueDate from './InvoiceDueDate'
import InvoiceActionsMenu from './InvoiceActionsMenu'

interface InvoiceItemProps {
  invoice: Invoice
}

const InvoiceListItem: FC<InvoiceItemProps> = ({ invoice }) => {
  const { isEnabled } = useFeatureFlagsContext()
  const { account, vendorRecordId, status, dueAt } = invoice

  return (
    <tr className="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
      <td className="w-4 p-4">
        <div className="flex items-center">
          <input
            id="checkbox-table-search-1"
            type="checkbox"
            className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          />
          <label htmlFor="checkbox-table-search-1" className="sr-only">
            checkbox
          </label>
        </div>
      </td>
      <th scope="row" className="flex items-center px-6 py-4 text-gray-900 whitespace-nowrap dark:text-white">
        <div className="ps-3">
          <div className="text-base font-semibold">{invoice.number || vendorRecordId}</div>
          {isEnabled('filterable_billing_type_badge') ? (
            <FilterableBadge invoice={invoice} />
          ) : (
            <StaticBadge isRecurring={invoice.isRecurring} />
          )}
        </div>
      </th>
      <td className="px-6 py-4">
        <div className="max-sm:flex max-sm:justify-start md:block items-center">
          <h6 className="text-semibold">{account?.displayName}</h6>
          {account?.email && <div className="max-sm:hidden">{account?.email}</div>}
        </div>
      </td>
      <td className="px-6 py-4">
        <InvoiceDueDate invoiceId={invoice.id} value={dueAt} />
      </td>
      <td className="px-6 py-4">
        <div className="flex items-center">{status}</div>
      </td>
      <td className="px-6 py-4">
        <div className="flex items-center justify-end">{invoice.amount?.formattedValue}</div>
      </td>
      <td className="px-6 py-4 text-end">
        <div className="flex justify-end">
          {/* TODO: Show a warning that the re-direct will go to PayPal; Explore implementing this behavior as automatic for external links */}
          <a
            href="#"
            className="text-xs font-medium hover:text-white border dark:hover:text-white focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg px-3 py-1.5 text-center me-2 text-blue-700 border-blue-700 hover:bg-blue-800 dark:border-blue-500 dark:text-blue-500 dark:hover:bg-blue-500 dark:focus:ring-blue-800"
          >
            <i className="fa fa-copy"></i> New deal
          </a>
          <InvoiceActionsMenu invoice={invoice} />
        </div>
      </td>
    </tr>
  )
}

export default InvoiceListItem