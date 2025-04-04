import React, { ComponentProps, useRef, useEffect } from 'react'
import { Modal } from 'flowbite'
import { useLogTransport } from '@/components/LogTransportProvider'
import withAllTheProviders from '@/components/withAllTheProviders'
import { AppGlobalProps } from '@/utils'
import CloseIcon from '@/components/Icons/CloseIcon'
import { Account } from '../AccountManager/types'

const OffsiteLinkModal: React.FC<ComponentProps<'div'> & Partial<AppGlobalProps>> = ({ children, id, appStore, ...props }) => {
  const modalRef = useRef<HTMLDivElement>(null)
  const { logger } = useLogTransport()
  const modalId = id ?? 'offsite-link--modal'

  const closeModal = async () => {
    if (!modalRef.current) return
    const modal = new Modal(modalRef.current)
    logger.debug('@OffsiteLinkModal :: closeModal', { modalId })
    modal.hide()
  }

  useEffect(() => {
    const unsub = appStore?.subscribe(({ accountsMap, selectedAccountsMap }) => {
      logger.debug({ selectedAccountsMap })
      const selectedAccountId = Object.keys(selectedAccountsMap ?? {}).pop()
      /**
       * TODO: This doesn't return anything yet because the list of accounts is
       *   not being passed to the frontend from Rails yet. We would need to have
       *   app/frontend/entrypoints/accounts.ts pass the list of accounts (as JSON)
       *   to the frontend by setting it in document.appStore
       */
      const [selectedAccount] =
        Object.entries<Account>(accountsMap ?? {}).filter(([accountId, _account]) => accountId === selectedAccountId) ?? []
      console.debug({ selectedAccount })
      return selectedAccountsMap
    }, logger.debug)
    return unsub
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [appStore, logger?.debug])

  return (
    <div
      {...props}
      id={modalId}
      ref={modalRef}
      tabIndex={-1}
      aria-hidden="true"
      data-testid="offsite-link--modal"
      className="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div className="relative p-4 w-full max-w-2xl max-h-full">
        <div className="relative p-4 w-full max-w-2xl max-h-full">
          {/* Modal Content */}
          <div className="relative bg-white rounded-lg shadow dark:bg-gray-700">
            {/* Modal Header */}
            <div className="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">Offsite Link</h3>
              <button
                type="button"
                onClick={closeModal}
                className="inline-flex items-center p-1.5 text-sm text-gray-400 bg-transparent rounded-lg hover:bg-gray-200 hover:text-gray-900 dark:hover:bg-gray-600 dark:hover:text-white"
                data-modal-toggle={modalId}
              >
                <CloseIcon />
                <span className="sr-only">Close modal</span>
              </button>
            </div>
            {/* Modal Body */}
            <div className="p-6 md:p-5 space-y-6">
              This link will take you to an external site. Please ensure you trust the source before proceeding.
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default withAllTheProviders(OffsiteLinkModal)
