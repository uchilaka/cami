import React from 'react'
import { withAccountProvider } from './AccountProvider'
import withAllTheProviders from '@/components/withAllTheProviders'

const AccountContextMenu = () => {
  return (
    <div className="max-w-screen-xl px-4 py-3 mx-auto">
      <div className="flex items-center">
        <ul className="flex flex-row font-medium mt-0 space-x-8 rtl:space-x-reverse text-sm">
          {/* IF: 1+ accounts are selected */}
          <li>
            <a href="#" className="text-gray-900 dark:text-white hover:underline" aria-current="page">
              Combine
            </a>
          </li>
          {/* IF: 1+ accounts are selected */}
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

export default withAllTheProviders(withAccountProvider(AccountContextMenu))
