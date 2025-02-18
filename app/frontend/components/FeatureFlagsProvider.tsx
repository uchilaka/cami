import React, { createContext, FC, ReactNode, useCallback } from 'react'
import useFeatureFlags, { FeatureFlagsProps } from '@/utils/hooks/useFeatureFlags'
import { MissingRequiredContextError } from '@/utils/errors'
import LoadingAnimation from './LoadingAnimation'

type FEATURE_FLAGS =
  | 'editable_phone_numbers'
  | 'filterable_billing_type_badge'
  | 'account_filtering'
  | 'invoice_filtering'
  | 'invoice_filtering_by_account'
  | 'invoice_filtering_by_status'
  | 'invoice_filtering_by_due_date'
  | 'invoice_filtering_by_amount'
  | 'invoice_sortable_by_account'
  | 'invoice_sortable_by_due_date'
  | 'invoice_bulk_actions'
  | 'invoice_search'
  | 'sortable_invoice_index'
  | 'stripe_invoicing'
  | 'hubspot_invoicing'

type FeatureFlagContextProps = Pick<FeatureFlagsProps, 'error' | 'loading' | 'refetch'> & {
  isEnabled: (...flags: FEATURE_FLAGS[]) => boolean
}

const FeatureFlagsContext = createContext<FeatureFlagContextProps>(null!)

export const useFeatureFlagsContext = () => {
  const context = React.useContext(FeatureFlagsContext)
  if (!context) {
    throw new MissingRequiredContextError('useFeatureFlagsContext must be used within a FeatureFlagsProvider')
  }
  return context
}

export const FeatureFlagsProvider: FC<{ children?: ReactNode }> = ({ children }) => {
  const { loading, error, flags, refetch } = useFeatureFlags()

  const isEnabled = useCallback(
    (...checkFlags: FEATURE_FLAGS[]) => {
      return checkFlags.every((flag) => !!flags[`feat__${flag}`])
    },
    [flags],
  )

  if (loading === undefined || loading) {
    return <LoadingAnimation />
  }

  return <FeatureFlagsContext.Provider value={{ loading, error, isEnabled, refetch }}>{children}</FeatureFlagsContext.Provider>
}

export default FeatureFlagsProvider
