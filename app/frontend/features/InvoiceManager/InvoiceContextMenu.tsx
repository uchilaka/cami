import React from 'react'
import { withInvoiceProvider } from './InvoiceProvider'
import withAllTheProviders from '@/components/withAllTheProviders'

const InvoiceContextMenu = () => {
  return (
    <div className="max-w-screen-xl px-4 py-3 mx-auto">
      <div className="flex items-center">
        <ul className="flex flex-row font-medium mt-0 space-x-8 rtl:space-x-reverse text-sm">
          {/* IF: 1+ invoices are selected */}
          <li>
            <a href="#" className="text-gray-900 dark:text-white hover:underline" aria-current="page">
              Link Account
            </a>
          </li>
          {/* IF: 1+ invoices are selected */}
          <li>
            <a href="#" className="text-gray-900 dark:text-white hover:underline">
              Archive
            </a>
          </li>
        </ul>
      </div>
    </div>
  )
}

export default withAllTheProviders(withInvoiceProvider(InvoiceContextMenu))
