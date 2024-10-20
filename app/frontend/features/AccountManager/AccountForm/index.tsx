import clsx from 'clsx'
import { Form, Formik } from 'formik'
import React, { FC, useState } from 'react'
import * as Yup from 'yup'
import FormInput from '@/components/FloatingFormInput'
import { useAccountContext } from '../AccountProvider'
import { isActionableAccount, isBusinessAccount, isIndividualAccount } from '@/utils/api/types'
import TextareaInput from '@/components/TextareaInput'
import Button from '@/components/Button'
import { useMutation } from '@tanstack/react-query'
import useCsrfToken from '@/utils/hooks/useCsrfToken'

type AccountFormData = {
  displayName: string
  email: string
  type: 'Individual' | 'Business'
  givenName?: string
  familyName?: string
  phone?: string
  readme?: string
}

interface AccountFormProps {
  readOnly?: boolean
  compact?: boolean
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
export const AccountForm: FC<AccountFormProps> = ({ compact, readOnly }) => {
  const [isReadOnly, setIsReadOnly] = useState(readOnly ?? true)
  const { loading, account } = useAccountContext()
  const { csrfToken } = useCsrfToken()

  const formClassName = clsx('mx-auto', { 'max-w-lg': !compact })

  const initialValues: AccountFormData = {
    displayName: account?.displayName ?? '',
    email: account?.email ?? '',
    readme: account?.readme,
    phone: (isBusinessAccount(account) ? account?.phone : '') ?? '',
    type: account?.type ?? 'Business',
  }

  const updateAccount = useMutation({
    mutationFn: async (values: AccountFormData) => {
      if (isActionableAccount(account)) {
        // Submit the form
        const { edit } = account.actions
        const payload = { [account.type.toLowerCase()]: values }
        return fetch(edit.url, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken,
          },
          body: JSON.stringify(payload),
        })
      } else {
        // TODO: Raise AccountNotActionableError
      }
    },
  })

  console.debug({ account, loading })

  return (
    <Formik
      validateOnBlur
      initialValues={initialValues}
      validationSchema={validationSchema}
      onSubmit={async (values, { setSubmitting, validateForm }) => {
        setSubmitting(true)
        const validationErrors = await validateForm(values)
        if (Object.keys(validationErrors).length > 0) {
          // Errors were reported
          console.debug({ values, errors: validationErrors })
        } else {
          console.debug({ values })
          if (isActionableAccount(account)) {
            // Submit the form
            updateAccount.mutate(values)
          } else {
            // Set an error
          }
        }
        setSubmitting(false)
      }}
    >
      {(formikProps) => {
        const { handleChange, handleReset, handleBlur, handleSubmit, isValid, isValidating, isSubmitting, values, errors } = formikProps

        return (
          <Form className={formClassName} onSubmit={handleSubmit}>
            <FormInput
              id="displayName"
              type="text"
              label={'Company (Ex. Google)'}
              autoComplete="off"
              name="displayName"
              placeholder=" "
              error={!!errors.displayName}
              hint={errors.displayName}
              onReset={handleReset}
              onChange={handleChange}
              onBlur={handleBlur}
              readOnly={loading || isReadOnly}
              required
            />

            <div className="grid md:gap-6 md:grid-cols-2">
              <FormInput
                id="email"
                type="email"
                label="Email address"
                name="email"
                placeholder=" "
                error={!!errors.email}
                hint={errors.email}
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
                readOnly={loading || isReadOnly}
              />
              <FormInput
                id="phone"
                type="phone"
                label="Phone number"
                name="phone"
                placeholder=" "
                hint={errors.phone}
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
                readOnly={loading || isReadOnly}
              />
            </div>

            {/**
             * TODO: Detect if there is a user account and offer
             * to create one to save givenName and familyName
             */}
            {isIndividualAccount(account) && (
              <div className="grid md:gap-6 md:grid-cols-2">
                <FormInput
                  type="text"
                  id="givenName"
                  name="givenName"
                  label="First name"
                  placeholder=" "
                  onReset={handleReset}
                  onChange={handleChange}
                  onBlur={handleBlur}
                  readOnly={loading || isReadOnly}
                />
                <FormInput
                  type="text"
                  id="familyName"
                  name="familyName"
                  label="Last name"
                  placeholder=" "
                  onReset={handleReset}
                  onChange={handleChange}
                  onBlur={handleBlur}
                  readOnly={loading || isReadOnly}
                />
              </div>
            )}

            {/* @TODO Figure out how to handle trix-content via react frontend */}
            <TextareaInput
              id="readme"
              name="readme"
              label="Description"
              placeholder=" "
              onReset={handleReset}
              onChange={handleChange}
              onBlur={handleBlur}
              readOnly={loading || isReadOnly}
            />

            <div className="flex justify-end items-center space-x-2">
              {!isReadOnly && (
                <>
                  <Button onClick={() => setIsReadOnly(true)}>Cancel</Button>
                  <Button disabled variant="caution">
                    Delete this account
                  </Button>
                  <Button variant="primary" type="submit" disabled={loading || !isValid || isValidating || isSubmitting}>
                    Save
                  </Button>
                </>
              )}
              {isReadOnly && <Button onClick={() => setIsReadOnly(false)}>Edit</Button>}
            </div>
          </Form>
        )
      }}
    </Formik>
  )
}

export default AccountForm
