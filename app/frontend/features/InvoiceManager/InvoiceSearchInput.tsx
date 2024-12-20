import React from 'react'

const InvoiceSearchInput = () => {
  /**
   * TODO: Show tooltip hint (on hover) if live search is disabled
   *
   * For live search, review the (PayPal) invoice search docs:
   * https://developer.paypal.com/docs/api/invoicing/v2/#invoices_search-invoices
   */
  const liveSearchEnabled = false

  return (
    <div className="flex flex-row justify-end space-x-2">
      <label className="inline-flex items-center cursor-pointer space-x-2">
        <span className="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Live API</span>
        <input type="checkbox" value="" className="sr-only peer" disabled={!liveSearchEnabled} />
        <div className="relative w-11 h-6 bg-gray-200 rounded-full peer dark:bg-gray-700 peer-focus:ring-4 peer-focus:ring-orange-300 dark:peer-focus:ring-orange-800 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-orange-500"></div>
      </label>
      <div>
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
    </div>
  )
}

export default InvoiceSearchInput
