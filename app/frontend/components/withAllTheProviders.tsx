import React, { ComponentType } from 'react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

export const withAllTheProviders = <P extends {}>(WrappedComponent: ComponentType<P>) => {
  const displayName = WrappedComponent.displayName ?? WrappedComponent.name ?? 'Component'
  const ComponentWithAllTheProviders = (props: any) => {
    const queryClient = new QueryClient()

    return (
      <QueryClientProvider client={queryClient}>
        <WrappedComponent {...props} />
      </QueryClientProvider>
    )
  }
  ComponentWithAllTheProviders.displayName = `withAllTheProviders(${displayName})`
  return ComponentWithAllTheProviders
}

export default withAllTheProviders
