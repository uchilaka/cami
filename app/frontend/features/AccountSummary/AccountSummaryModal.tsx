import React, { ComponentProps, useEffect, useState } from 'react'
import withAllTheProviders from '@/components/withAllTheProviders'
import LoadingAnimation, { InlineLoadingAnimation } from '../../components/LoadingAnimation'
import { useAccountContext, withAccountProvider } from '@/features/AccountSummary/AccountProvider'
import AccountTitleLabel from './AccountTitleLabel'

const AccountSummaryModal: React.FC<ComponentProps<'div'>> = ({ children, id, ...props }) => {
  const [accountLoader, setAccountLoader] = useState<AbortController>()

  const modalId = id ?? 'account--summary-modal'

  const { loading, account, listenForAccountLoadEvents } = useAccountContext()

  useEffect(() => {
    if (!accountLoader) setAccountLoader(listenForAccountLoadEvents())
    return () => {
      if (accountLoader) {
        console.debug('Aborting account loader listener...')
        accountLoader.abort()
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [accountLoader])

  return (
    <div
      {...props}
      id={modalId}
      tabIndex={-1}
      aria-hidden="true"
      className="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div className="relative p-4 w-full max-w-2xl max-h-full">
        {/* Modal Content */}
        <div className="relative bg-white rounded-lg shadow dark:bg-gray-700">
          {/* Modal Header */}
          <div className="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
              <AccountTitleLabel />
            </h3>
            <button
              type="button"
              className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide={modalId}
            >
              <svg className="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                <path
                  stroke="currentColor"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span className="sr-only">Close modal</span>
            </button>
          </div>
          {/* Modal Body */}
          <div className="p-4 md:p-5 space-y-4">
            {loading ? (
              <LoadingAnimation />
            ) : (
              <>
                <p className="my-5">
                  <strong className="block font-medium mb-1">{account?.type} name:</strong>
                  <span className="text-2xl text-gray-900 dark:text-white">{account?.displayName}</span>
                </p>

                <p className="my-5">
                  <strong className="block font-medium mb-1">Email:</strong>
                  <span className="text-2xl text-gray-900 dark:text-white">{account?.email}</span>
                </p>

                {account?.readme && (
                  <p className="my-5">
                    <strong className="block font-medium mb-1">Readme:</strong>
                    {/* @TODO Figure out how to handle trix-content via react frontend */}
                    <span className="trix-content text-2xl">{account?.readme}</span>
                  </p>
                )}

                {/* @TODO: render a list of invoices ordered by invoiced_at: :desc, status: :asc */}

                {/* Modal Actions */}
                <hr className="my-4" />
                <div className="flex justify-end items-center space-x-4">
                  <button className="btn px-5 py-2.5 text-base font-medium text-white bg-gradient-to-br from-green-400 to-blue-600 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 dark:focus:ring-green-800 font-medium rounded-lg text-sm text-center me-2 mb-2">
                    Edit this account
                  </button>
                  <button className="btn px-5 py-2.5 hover:text-white border focus:ring-4 focus:outline-none font-medium rounded-lg text-sm text-center me-2 mb-2 dark:hover:text-white text-red-700 border-red-700 hover:bg-red-800 focus:ring-red-300 dark:border-red-500 dark:text-red-500 dark:hover:bg-red-600 dark:focus:ring-red-900">
                    Delete this account
                  </button>
                  <button className="btn px-5 py-2.5 hover:text-white border focus:ring-4 focus:outline-none font-medium rounded-lg text-sm text-center me-2 mb-2 dark:hover:text-white text-gray-800 border-gray-800 hover:bg-gray-900 focus:ring-gray-300 dark:border-gray-600 dark:text-gray-400 dark:hover:bg-gray-600 dark:focus:ring-gray-800">
                    Back to accounts
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

export default withAllTheProviders(withAccountProvider(AccountSummaryModal))
