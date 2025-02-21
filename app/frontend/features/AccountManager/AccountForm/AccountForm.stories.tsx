import React from 'react'
import { Decorator, Meta, StoryObj } from '@storybook/react'
import AccountForm from './AccountForm'
import AccountProvider from '../AccountProvider'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import LogTransportProvider from '@/components/LogTransportProvider'
import FeatureFlagsProvider from '@/components/FeatureFlagsProvider'

const queryClient = new QueryClient()

const accountProviderDecorator: Decorator = (Story, { args }) => (
  <LogTransportProvider>
    <FeatureFlagsProvider>
      <QueryClientProvider client={queryClient}>
        <AccountProvider>
          <Story {...args} />
        </AccountProvider>
      </QueryClientProvider>
    </FeatureFlagsProvider>
  </LogTransportProvider>
)

const meta: Meta<typeof AccountForm> = {
  decorators: [accountProviderDecorator],
  title: 'AccountManager/AccountForm',
  component: AccountForm,
}

export default meta

type Story = StoryObj<typeof meta>

export const Default: Story = {
  args: { readOnly: true, compact: false },
}
