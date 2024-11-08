import React, { createContext, FC, ReactNode, useCallback } from 'react'
import useFeatureFlags, { FeatureFlagsProps } from '@/utils/hooks/useFeatureFlags'

type FEATURE_FLAGS =
  | 'editable_phone_numbers'
  | 'filterable_billing_type_badge'
  | 'account_filtering'
  | 'invoice_filtering'
  | 'invoice_bulk_actions'
  | 'invoice_search'
  | 'sortable_invoice_index'

type FeatureFlagContextProps = Pick<FeatureFlagsProps, 'error' | 'loading' | 'refetch'> & {
  isEnabled: (flag: FEATURE_FLAGS) => boolean
}

const FeatureFlagsContext = createContext<FeatureFlagContextProps>(null!)

class MissingRequiredContextError extends Error {}

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
    (flag: FEATURE_FLAGS) => {
      return flags[`feat__${flag}`] ?? false
    },
    [flags],
  )

  return <FeatureFlagsContext.Provider value={{ loading, error, isEnabled, refetch }}>{children}</FeatureFlagsContext.Provider>
}

export default FeatureFlagsProvider
