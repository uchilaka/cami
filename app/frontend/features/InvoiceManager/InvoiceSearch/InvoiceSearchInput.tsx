import React, { useState } from 'react'
import debounce from 'lodash.debounce'
import MagnifyingGlassIcon from './MagnifyingGlassIcon'
import SpinnerIcon from './SpinnerIcon'
import { useInvoiceContext } from '../InvoiceProvider'

type RunSearchFn = (ev: React.ChangeEvent<HTMLInputElement>) => void

const InvoiceSearchInput = () => {
  const [userIsTyping, setUserIsTyping] = useState(false)
  /**
   * TODO: Show tooltip hint (on hover) if live search is disabled
   *
   * For live search, review the (PayPal) invoice search docs:
   * https://developer.paypal.com/docs/api/invoicing/v2/#invoices_search-invoices
   */
  const liveSearchEnabled = false

  const { updateSearchParams } = useInvoiceContext()

  const handleChange = debounce<RunSearchFn>(({ target }) => {
    setUserIsTyping(false)
    const q = target.value
    if (q.length >= 3) {
      console.debug(`Searching for invoices with: ${target.value}`)
      updateSearchParams({ q })
    }
  }, 1000)

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
            {userIsTyping ? <SpinnerIcon /> : <MagnifyingGlassIcon />}
          </div>
          {/* TODO: Use i18n for invoice placeholder */}
          <input
            type="text"
            id="table-search-accounts"
            className="block p-2 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg w-80 bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            placeholder="Search for invoices..."
            onKeyDownCapture={() => setUserIsTyping(true)}
            onChange={handleChange}
          />
        </div>
      </div>
    </div>
  )
}

export default InvoiceSearchInput
