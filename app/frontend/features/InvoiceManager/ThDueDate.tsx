import React from 'react'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'

export default function ThDueDate() {
  const labelText = 'Due Date'
  const { isEnabled } = useFeatureFlagsContext()
  return (
    <th scope="col" className="px-6 py-3">
      {isEnabled('sortable_invoice_index', 'invoice_filtering_by_due_date') ? (
        <>
          <a href="?s[][field]=dueAt&s[][direction]=desc" data-tooltip-target="tooltip-sort-by-due-date">
            {labelText}
            <i className="fa-solid fa-caret-down px-2"></i>
          </a>
          <div
            id="tooltip-sort-by-due-date"
            role="tooltip"
            className="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-900 rounded-lg shadow-sm opacity-0 tooltip dark:bg-gray-700 normal-case"
          >
            Sort by due date
            <div className="tooltip-arrow" data-popper-arrow></div>
          </div>
        </>
      ) : (
        <span>{labelText}</span>
      )}
    </th>
  )
}
