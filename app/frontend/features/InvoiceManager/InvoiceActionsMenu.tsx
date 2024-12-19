import React, { FC } from 'react'
import { Dropdown } from 'flowbite'
import { Invoice } from '@/utils/api/types'

interface ActionsMenuProps {
  invoice: Invoice
}

const InvoiceActionsMenu: FC<ActionsMenuProps> = ({ invoice }) => {
  const actionsMenuControlId = `actions-menu-control--${invoice.id}`
  const actionsMenuId = `actions-menu--${invoice.id}`

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
          <li>
            {/* TODO: Show a warning that the re-direct will go to PayPal; Explore implementing this behavior as automatic for external links */}
            <a
              href={invoice.paymentVendorURL}
              target="_blank"
              className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              rel="noreferrer"
            >
              <i className="fa-brands fa-paypal"></i> Manage
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
