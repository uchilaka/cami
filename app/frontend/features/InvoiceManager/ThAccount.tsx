import React, { useCallback, useEffect, useRef } from 'react'
import clsx from 'clsx'
import { Tooltip } from 'flowbite'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'
import { useInvoiceContext } from './InvoiceProvider'

export default function ThAccount() {
  const controlRef = useRef<HTMLAnchorElement>(null)
  const tooltipRef = useRef<HTMLDivElement>(null)
  const labelText = 'Account'
  const { isEnabled } = useFeatureFlagsContext()
  const { filterParams, setFilterParams } = useInvoiceContext()
  const filterParam = filterParams?.s?.account
  const filteringByAccount = !!filterParam
  const filteringDesc = filteringByAccount && filterParam.direction === 'desc'

  const toggleSortFilter = useCallback(() => {
    if (filteringByAccount && filteringDesc) {
      setFilterParams({ s: { account: { field: 'account' } } })
    } else {
      setFilterParams({ s: { account: { field: 'account', direction: 'desc' } } })
    }
  }, [filteringByAccount, filteringDesc, setFilterParams])

  useEffect(() => {
    if (!controlRef.current || !tooltipRef.current) return

    const control = controlRef.current
    const tooltip = tooltipRef.current

    new Tooltip(tooltip, control, { placement: 'bottom', triggerType: 'hover' }, { id: 'tooltip--sort-by-account' })
  }, [controlRef, tooltipRef])

  return (
    <th scope="col" className="px-6 py-3">
      {isEnabled('sortable_invoice_index') ? (
        <>
          <a
            ref={controlRef}
            href="#"
            className="text-blue-600 dark:text-blue-500 hover:underline"
            data-tooltip-target="tooltip-sort-by-account"
            onClick={toggleSortFilter}
          >
            {labelText}
            <i
              className={clsx('fa-solid px-2', filteringDesc && 'fa-caret-down', filteringByAccount && !filteringDesc && 'fa-caret-up')}
            ></i>
          </a>
          <div
            id="tooltip-sort-by-account"
            ref={tooltipRef}
            role="tooltip"
            className="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-900 rounded-lg shadow-sm opacity-0 tooltip dark:bg-gray-700 normal-case"
          >
            Sort by account
            <div className="tooltip-arrow" data-popper-arrow></div>
          </div>
        </>
      ) : (
        <span>{labelText}</span>
      )}
    </th>
  )
}
