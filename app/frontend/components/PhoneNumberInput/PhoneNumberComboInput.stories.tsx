import React from 'react'
import { Decorator, Meta, StoryObj, StrictArgs } from '@storybook/react'
import { Formik, FormikConfig } from 'formik'
import PhoneNumberInput from './PhoneNumberComboInput'
import LogTransportProvider from '../LogTransportProvider'

const meta = {
  title: 'Components/PhoneNumberComboInput',
  component: PhoneNumberInput,
} satisfies Meta<typeof PhoneNumberInput>

export default meta

type Story = StoryObj<typeof meta>

const withFormikDecorator: Decorator<StrictArgs> = (Story, { args, parameters }) => {
  const { initialValues, onSubmit } = parameters.formik as FormikConfig<any>
  return (
    <Formik initialValues={initialValues} onSubmit={onSubmit}>
      <Story {...args} />
    </Formik>
  )
}

const withLogTransportDecorator: Decorator<StrictArgs> = (Story, { args, parameters }) => {
  return (
    <LogTransportProvider>
      <Story {...args} />
    </LogTransportProvider>
  )
}

export const Default: Story = {
  decorators: [withLogTransportDecorator, withFormikDecorator],
  args: {
    label: 'Phone Number',
    id: 'phone',
    name: 'phone',
  },
  parameters: {
    formik: {
      initialValues: {
        phone: '',
      },
      onSubmit: (values: any) => {
        console.log(values)
      },
    },
  },
}

export const WithInitialValue: Story = {
  decorators: [withLogTransportDecorator, withFormikDecorator],
  args: {
    label: 'Phone Number',
    name: 'phone',
  },
  parameters: {
    formik: {
      initialValues: {
        phone: '+17405678900',
      },
      onSubmit: (values: any) => {
        console.log(values)
      },
    },
  },
}
