import React, { useState } from 'react'

import FilterDropdown from './FilterDropdown'

const filterOptions = [
  ['Past due 7 days', 'past_due_7_days'],
  ['Past due 30 days', 'past_due_30_days'],
  ['Past due later', 'past_due_later_than_30_days'],
  ['Due today', 'due_today'],
  ['Due this week', 'due_this_week'],
  ['Due this month', 'due_this_month'],
  ['Due next month', 'due_next_month'],
  ['Due later', 'due_later_than_next_month'],
]

const FilterForInvoiceDueDate = () => {
  const [selectedFilter, setSelectedFilter] = useState('past_due_30_days')

  return (
    <div className="list-filter">
      <button
        id="dueDateDropdownRadioButton"
        data-dropdown-toggle="dueDateDropdownRadio"
        className="inline-flex items-center text-gray-500 bg-white border border-gray-300 focus:outline-none hover:bg-gray-100 focus:ring-4 focus:ring-gray-100 font-medium rounded-lg text-sm px-3 py-1.5 dark:bg-gray-800 dark:text-white dark:border-gray-600 dark:hover:bg-gray-700 dark:hover:border-gray-600 dark:focus:ring-gray-700"
        type="button"
      >
        <i className="mr-2.5 fa-sharp fa-solid fa-filter"></i>
        Due date
        <svg className="w-2.5 h-2.5 ms-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
          <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m1 1 4 4 4-4" />
        </svg>
      </button>

      {/*<!-- Dropdown menu -->*/}
      <FilterDropdown
        id="dueDateDropdownRadio"
        className="z-10 hidden w-48 bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700 dark:divide-gray-600"
        data-popper-reference-hidden=""
        data-popper-escaped=""
        data-popper-placement="top"
      >
        <ul className="p-3 space-y-1 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dueDateDropdownRadioButton">
          {filterOptions.map(([label, value], index) => (
            <li key={`due-date-filter-option-${index + 1}`}>
              <div className="flex items-center p-2 rounded hover:bg-gray-100 dark:hover:bg-gray-600">
                <input
                  id={`filter-radio-${value}`}
                  type="radio"
                  value={value}
                  checked={selectedFilter === value}
                  name="filter-radio"
                  className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                />
                <label
                  htmlFor={`filter-radio-${value}`}
                  className="w-full ms-2 text-sm font-medium text-gray-900 rounded dark:text-gray-300"
                >
                  {label}
                </label>
              </div>
            </li>
          ))}
        </ul>
      </FilterDropdown>
    </div>
  )
}

export default FilterForInvoiceDueDate
