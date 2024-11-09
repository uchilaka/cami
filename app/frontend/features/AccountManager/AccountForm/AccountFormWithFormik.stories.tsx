import React, { FC, useEffect } from 'react'
import { Decorator, Meta, StoryObj } from '@storybook/react'
import AccountForm, { AccountFormProps } from '../AccountFormWithFormik'
import AccountProvider from '../AccountProvider'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import LogTransportProvider from '@/components/LogTransportProvider'
import FeatureFlagsProvider from '@/components/FeatureFlagsProvider'
import { emitLoadAccountEvent } from '@/utils/events'

const queryClient = new QueryClient()

const AccountMockForm: FC<AccountFormProps> = (props) => {
  useEffect(() => {
    setTimeout(() => emitLoadAccountEvent('1234'), 3000)
  }, [])

  return <AccountForm {...props} />
}

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

const accountDataDecorator: Decorator = (Story, { args }) => {
  console.debug('Loading mock account data...')

  return <Story {...args} />
}

const meta: Meta<typeof AccountMockForm> = {
  decorators: [accountDataDecorator, accountProviderDecorator],
  title: 'AccountManager/AccountFormWithFormik',
  component: AccountMockForm,
}

export default meta

type Story = StoryObj<typeof meta>

export const Default: Story = {
  args: { readOnly: true, compact: false },
}

export const BusinessForm: Story = {
  args: { initialType: 'Business' },
}

export const IndividualForm: Story = {
  args: { initialType: 'Individual' },
}
