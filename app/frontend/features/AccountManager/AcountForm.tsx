import clsx from 'clsx'
import { Form, Formik } from 'formik'
import React, { FC, ReactNode } from 'react'
import * as Yup from 'yup'
import FormInput, { InputGrid } from '@/components/FloatingFormInput'
import { useAccountContext } from './AccountProvider'
import { isBusinessAccount } from '@/utils/api/types'

type AccountFormData = {
  displayName: string
  email: string
  type: 'Individual' | 'Business'
  phone?: string
}

interface AccountFormProps {
  compact?: boolean
  children?: ReactNode
}

const validationSchema = Yup.object({
  displayName: Yup.string().required('A display name is required'),
  email: Yup.string()
    .email('must be a valid email address')
    .test({
      name: 'is-valid-email',
      skipAbsent: false,
      test(value, ctx) {
        const source: AccountFormData = ctx.parent
        if (source.type === 'Business' && !value) {
          return ctx.createError({ message: 'Email address is required for a business' })
        }
        return true
      },
    }),
})

/**
 * Form with floating labels: https://flowbite.com/docs/components/forms/#floating-labels
 */
export const AccountForm: FC<AccountFormProps> = ({ compact, children }) => {
  const formClassName = clsx('mx-auto', { 'max-w-lg': !compact })

  const { loading, account } = useAccountContext()

  const initialValues: AccountFormData = {
    displayName: account?.displayName ?? '',
    email: account?.email ?? '',
    phone: (isBusinessAccount(account) ? account?.phone : '') ?? '',
    type: account?.type ?? 'Business',
  }

  return (
    <Formik validateOnBlur initialValues={initialValues} validationSchema={validationSchema} onSubmit={() => {}}>
      {(formikProps) => {
        const { handleChange, handleReset, handleBlur, handleSubmit, values, errors } = formikProps
        console.debug({ values, errors })
        return (
          <Form className={formClassName} onSubmit={handleSubmit}>
            <FormInput
              id="displayName"
              type="text"
              label={'Company (Ex. Google)'}
              autoComplete="off"
              name="displayName"
              error={!!errors.displayName}
              hint={errors.displayName}
              onReset={handleReset}
              onChange={handleChange}
              onBlur={handleBlur}
              readOnly={loading}
              required
            />

            <InputGrid>
              <FormInput
                id="email"
                type="email"
                label="Email address"
                name="email"
                error={!!errors.email}
                hint={errors.email}
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
                readOnly={loading}
              />
              <FormInput
                id="phone"
                type="phone"
                label="Phone number"
                name="phone"
                hint={errors.phone}
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
                readOnly={loading}
              />
            </InputGrid>

            <InputGrid>
              <FormInput
                type="text"
                id="givenName"
                name="givenName"
                label="First name"
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
              />
              <FormInput type="text" id="familyName" name="familyName" label="Last name" placeholder=" " />
            </InputGrid>
            {children}
          </Form>
        )
      }}
    </Formik>
  )
}

export default AccountForm
