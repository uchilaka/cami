import React from 'react'

/**
 * TODO: Call to action: "New service setup" with a wrench and screwdriver icon.
 * TODO: Figure out how to leverage Tailwind for the styling of React components -
 *   different from almost everywhere else having it server-side rendered.
 * @constructor
 */
export default function InvoiceSummaryModal() {
  return (
    <>
      <h3 role="title">This is the invoice summary modal component</h3>
      <h6>
        You can find me in: <span className="px-2 py-1 bg-slate-100">frontend/views/SetupWizard/InvoiceSummaryModal.tsx</span>
      </h6>
    </>
  )
}
