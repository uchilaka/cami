import React from 'react'
import { Decorator, Meta, StoryObj } from '@storybook/react'
import AccountForm from '.'
import AccountProvider from '../AccountProvider'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient()

const accountProviderDecorator: Decorator = (Story, { args }) => (
  <QueryClientProvider client={queryClient}>
    <AccountProvider>
      <Story {...args} />
    </AccountProvider>
  </QueryClientProvider>
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