import React, { ComponentType } from 'react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import FeatureFlagsProvider from '@/components/FeatureFlagsProvider'
import LogTransportProvider from '@/components/LogTransportProvider'

export const withAllTheProviders = <P extends {}>(WrappedComponent: ComponentType<P>) => {
  const displayName = WrappedComponent.displayName ?? WrappedComponent.name ?? 'Component'
  const ComponentWithAllTheProviders = (props: any) => {
    const queryClient = new QueryClient()

    return (
      <LogTransportProvider>
        <QueryClientProvider client={queryClient}>
          <FeatureFlagsProvider>
            <WrappedComponent {...props} />
          </FeatureFlagsProvider>
        </QueryClientProvider>
      </LogTransportProvider>
    )
  }
  ComponentWithAllTheProviders.displayName = `withAllTheProviders(${displayName})`
  return ComponentWithAllTheProviders
}

export default withAllTheProviders
