import React, { FC } from 'react'
import { Dropdown } from 'flowbite'
import { Invoice } from './types'

interface ActionsMenuProps {
  invoice: Invoice
}

const AT_OR_PAST_SENT_STATUSES: Invoice['status'][] = ['PAID', 'OVERDUE', 'SENT']

const InvoiceActionsMenu: FC<ActionsMenuProps> = ({ invoice }) => {
  const actionsMenuControlId = `actions-menu-control--${invoice.id}`
  const actionsMenuId = `actions-menu--${invoice.id}`
  const invoiceHasBeenSent = AT_OR_PAST_SENT_STATUSES.includes(invoice.status)
  const linkAccountLabel = invoice.account ? 'Update account' : 'Link account'
  const manageLabel = invoice.status === 'PAID' ? 'Review' : 'Manage'
  const sendInvoiceLabel = invoiceHasBeenSent ? 'Re-send' : 'Send'
  const invoiceCanBeSent = invoice.account && invoice.status !== 'PAID'

  const controlRef = React.useRef<HTMLButtonElement>(null)
  const menuRef = React.useRef<HTMLDivElement>(null)

  React.useEffect(() => {
    if (!controlRef.current || !menuRef.current) return

    const control = controlRef.current
    const menu = menuRef.current

    new Dropdown(menu, control, { placement: 'left-start', triggerType: 'click' })
  }, [controlRef, menuRef])

  return (
    <>
      <button
        id={actionsMenuControlId}
        ref={controlRef}
        data-dropdown-toggle={actionsMenuId}
        data-dropdown-placement="left"
        className="mb-3 md:mb-0 text-xs font-medium hover:text-white border dark:hover:text-white focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg px-3 py-1.5 text-center me-2 text-blue-700 border-blue-700 hover:bg-blue-800 dark:border-blue-500 dark:text-blue-500 dark:hover:bg-blue-500 dark:focus:ring-blue-800"
        type="button"
      >
        <i className="fa-solid fa-ellipsis-vertical"></i>
        <span className="sr-only">Actions</span>
      </button>
      <div id={actionsMenuId} ref={menuRef} className="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700">
        <ul className="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownLeftButton">
          {invoiceCanBeSent && (
            <li>
              <a href="#" className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">
                <i className="fa-solid fa-paper-plane"></i> {sendInvoiceLabel}
              </a>
            </li>
          )}
          <li>
            {/* TODO: Show a warning that the re-direct will go to PayPal; Explore implementing this behavior as automatic for external links */}
            <a
              href={invoice.paymentVendorURL}
              target="_blank"
              className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              rel="noreferrer"
            >
              <i className="fa-brands fa-paypal"></i> {manageLabel}
            </a>
          </li>
          <li>
            <a href="#" className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">
              <i className="fa fa-link"></i> {linkAccountLabel}
            </a>
          </li>
          <li>
            <a href="#" className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">
              <i className="fa fa-copy"></i> New deal
            </a>
          </li>
        </ul>
      </div>
    </>
  )
}

export default InvoiceActionsMenu
