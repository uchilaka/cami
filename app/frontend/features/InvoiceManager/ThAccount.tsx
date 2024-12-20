import React, { useEffect, useRef } from 'react'
import { Tooltip } from 'flowbite'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'

export default function ThAccount() {
  const controlRef = useRef<HTMLAnchorElement>(null)
  const tooltipRef = useRef<HTMLDivElement>(null)
  const labelText = 'Account'
  const { isEnabled } = useFeatureFlagsContext()

  useEffect(() => {
    if (!controlRef.current || !tooltipRef.current) return

    const control = controlRef.current
    const tooltip = tooltipRef.current

    new Tooltip(tooltip, control, { placement: 'left', triggerType: 'hover' }, { id: 'tooltip--sort-by-account' })
  }, [controlRef, tooltipRef])

  return (
    <th scope="col" className="px-6 py-3">
      {isEnabled('sortable_invoice_index') ? (
        <>
          <a ref={controlRef} href="?s[][field]=account&s[][direction]=desc" data-tooltip-target="tooltip-sort-by-account">
            {labelText}
            <i className="fa-solid fa-caret-down px-2"></i>
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
