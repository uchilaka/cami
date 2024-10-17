import { Meta, StoryObj } from '@storybook/react'
import withFormik from '@bbbtech/storybook-formik'
import TextareaInput from '.'

const meta = {
  title: 'Components/TextareaInput',
  component: TextareaInput,
} satisfies Meta<typeof TextareaInput>

export default meta

type Story = StoryObj<typeof meta>

export const Default: Story = {
  decorators: [withFormik],
  args: {
    label: 'Description',
    id: 'description',
    name: 'description',
  },
  parameters: {
    formik: {
      initialValues: {
        description: '',
      },
      onSubmit: (values: any) => {
        console.log(values)
      },
    },
  },
}

export const WithError: Story = {
  decorators: [withFormik],
  args: {
    label: 'Description',
    id: 'description',
    name: 'description',
    error: true,
    hint: 'This field is invalid',
  },
  parameters: {
    formik: {
      initialValues: {
        description: '',
      },
      onSubmit: (values: any) => {
        console.log(values)
      },
    },
  },
}
