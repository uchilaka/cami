import React from 'react'
import FilterForInvoiceStatus from './FilterForInvoiceStatus'
import FilterForInvoiceDueDate from './FilterForInvoiceDueDate'

const InvoiceSearch = () => {
  return (
    <>
      <div className="flex items-center justify-between flex-column flex-wrap md:flex-row space-y-4 md:space-y-0 pb-4 dark:bg-gray-900">
        <div className="flex flex-row space-x-4">
          <FilterForInvoiceStatus />
          <FilterForInvoiceDueDate />
        </div>
      </div>
    </>
  )
}

export default InvoiceSearch
