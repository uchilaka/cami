import React from 'react'
import { Invoice } from '@/features/InvoiceManager/types'
import { screen, render } from '@testing-library/react'
import { v4 as uuidv4 } from 'uuid'
import { faker } from '@faker-js/faker'
import InvoiceableInfo from '@/features/InvoiceManager/InvoiceableInfo'
import { GenericAccount } from '@/utils/api/GenericAccount'

describe('InvoiceManager', () => {
  describe('InvoiceableInfo', () => {
    test('should render the account name and email', async () => {
      const displayName = faker.company.name()
      const account: GenericAccount = {
        id: uuidv4(),
        displayName,
        email: faker.internet.email(),
        slug: faker.helpers.slugify(displayName),
        status: 'guest',
      }
      const invoice: Partial<Invoice> = {
        id: uuidv4(),
        account,
      }
      render(<InvoiceableInfo invoice={invoice as Invoice} />)
      screen.findByText(displayName)
      screen.findByText(account.email as string)
    })
  })
})
