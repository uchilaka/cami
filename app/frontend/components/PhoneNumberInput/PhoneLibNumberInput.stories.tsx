import React from 'react'
import { Decorator, Meta, StoryObj, StrictArgs } from '@storybook/react'
import { Formik, FormikConfig } from 'formik'
import PhoneLibNumberInput from './PhoneLibNumberInput'

const meta = {
  title: 'Components/PhoneLibNumberInput',
  component: PhoneLibNumberInput,
} satisfies Meta<typeof PhoneLibNumberInput>

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

export const Default: Story = {
  decorators: [withFormikDecorator],
  args: {
    label: 'Phone Number',
    id: 'phone',
    name: 'phone',
    readOnly: false,
    disabled: false,
    international: false,
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
