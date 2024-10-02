import React, { ComponentType } from 'react'

export const withAllTheProviders = <P extends {}>(WrappedComponent: ComponentType<P>) => {
  const displayName = WrappedComponent.displayName ?? WrappedComponent.name ?? 'Component'
  const ComponentWithAllTheProviders = (props: any) => {
    return (
      <React.StrictMode>
        <WrappedComponent {...props} />
      </React.StrictMode>
    )
  }
  ComponentWithAllTheProviders.displayName = `withAllTheProviders(${displayName})`
  return ComponentWithAllTheProviders
}

export default withAllTheProviders
