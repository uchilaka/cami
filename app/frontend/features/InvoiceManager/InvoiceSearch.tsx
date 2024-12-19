import React from 'react'
import FilterForInvoiceStatus from './FilterForInvoiceStatus'
import FilterForInvoiceDueDate from './FilterForInvoiceDueDate'
import withAllTheProviders from '@/components/withAllTheProviders'
import ThDueDate from './ThDueDate'
import ThStatus from './ThStatus'
import ThAmount from './ThAmount'

const InvoiceSearch = () => {
  return (
    <>
      <div className="flex items-center justify-between flex-column flex-wrap md:flex-row space-y-4 md:space-y-0 pb-4 dark:bg-gray-900">
        <div className="flex flex-row space-x-4">
          <FilterForInvoiceStatus />
          <FilterForInvoiceDueDate />
        </div>

        <label htmlFor="table-search" className="sr-only">
          Search
        </label>
        <div className="relative">
          <div className="absolute inset-y-0 rtl:inset-r-0 start-0 flex items-center ps-3 pointer-events-none">
            <svg
              className="w-4 h-4 text-gray-500 dark:text-gray-400"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 20 20"
            >
              <path
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"
              />
            </svg>
          </div>
          {/* TODO: Use i18n for invoice placeholder */}
          <input
            type="text"
            id="table-search-accounts"
            className="block p-2 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg w-80 bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            placeholder="Search for invoices..."
            disabled
          />
        </div>
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
            <ThDueDate />
            <ThStatus />
            <ThAmount />
            <th scope="col" className="px-6 py-3 flex justify-end">
              <div className="flex justify-end">Action</div>
            </th>
          </tr>
        </thead>
        <tbody>{/* Render returned invoice records */}</tbody>
      </table>
    </>
  )
}

export default withAllTheProviders(InvoiceSearch)
