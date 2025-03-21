import React from 'react'
import { useAccountContext } from './AccountProvider'
import { InlineLoadingAnimation } from '@/components/LoadingAnimation'

export default function AccountTitleLabel() {
  const { loading, account } = useAccountContext()

  if (loading) return <InlineLoadingAnimation />

  return (
    <>
      {account?.displayName}
      {account?.isVendor && (
        <span className="uppercase ml-2 bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400">
          Vendor
        </span>
      )}
    </>
  )
}
