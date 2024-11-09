import clsx from 'clsx'
import { Form, Formik } from 'formik'
import React, { FC, useState } from 'react'
import snakecaseKeys from 'snakecase-keys'
import * as Yup from 'yup'
import FormInput from '@/components/FloatingFormInput'
import PhoneInput from '@/components/PhoneNumberInput/PhoneLibNumberInput'
import { useAccountContext } from '../AccountProvider'
import { arrayHasItems, isActionableAccount, isBusinessAccount, isIndividualAccount } from '@/utils/api/types'
import TextareaInput from '@/components/TextareaInput'
import Button from '@/components/Button'
import { useMutation } from '@tanstack/react-query'
import useCsrfToken from '@/utils/hooks/useCsrfToken'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'
import { useLogTransport } from '@/components/LogTransportProvider'
import ButtonLink from '@/components/Button/ButtonLink'

type ProfileFormData = {
  givenName: string
  familyName: string
  phone?: string
}

type AccountFormData = Partial<ProfileFormData> & {
  displayName: string
  email: string
  type: 'Individual' | 'Business'
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
 * Form with floating labels: https://flowbite.com/docs/components/forms/#floating-labels.
 *
 * The form story will have editing phone numbers disabled by default. To enable it, review
 * the `editable_phone_numbers` feature flag at `<project-root>/spec/fixtures/feature_flags.json`.
 */
export const AccountForm: FC<AccountFormProps> = ({ compact, readOnly }) => {
  const { logger } = useLogTransport()
  const [isReadOnly, setIsReadOnly] = useState(readOnly ?? true)
  const [saved, setSaved] = useState<boolean>()
  const { loading, account } = useAccountContext()
  const { loading: loadingFeatureFlags, isEnabled } = useFeatureFlagsContext()
  const disablePhoneNumbers = !isEnabled('editable_phone_numbers')
  const { csrfToken } = useCsrfToken()

  const formClassName = clsx('mx-auto', { 'max-w-lg': !compact })

  const initialValues: AccountFormData = {
    displayName: account?.displayName ?? '',
    email: account?.email ?? '',
    readme: account?.readme,
    phone: (isBusinessAccount(account) ? account?.phone : '') ?? '',
    type: account?.type ?? 'Business',
    ...(isIndividualAccount(account)
      ? {
          givenName: account?.profile?.givenName ?? '',
          familyName: account?.profile?.familyName ?? '',
          phone: account?.profile?.phone ?? '',
        }
      : {}),
  }

  const updateAccount = useMutation({
    mutationFn: async (values: AccountFormData) => {
      if (isActionableAccount(account)) {
        // Submit the form
        const { edit } = account.actions
        const { givenName, familyName, phone, ...rest } = values
        const payload = {
          [account.type.toLowerCase()]: rest,
          profile: { givenName, familyName, phone },
        }
        return fetch(edit.url, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken,
          },
          body: JSON.stringify(snakecaseKeys(payload)),
        })
      } else {
        // TODO: Raise AccountNotActionableError
      }
    },
    onSuccess: (_result) => setSaved(true),
  })

  logger.debug({ account, loading })

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
          logger.debug({ values, errors: validationErrors })
        } else {
          logger.debug({ values })
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
        const { handleChange, handleReset, handleBlur, handleSubmit, isValid, isValidating, isSubmitting, errors } = formikProps

        return (
          <Form className={formClassName} onSubmit={handleSubmit}>
            <FormInput
              id="displayName"
              type="text"
              label={isBusinessAccount(account) ? 'Company (Ex. Google)' : 'Display name'}
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
              <PhoneInput
                id="phone"
                type="phone"
                label="Phone number"
                name="phone"
                placeholder=" "
                international
                hint={errors.phone}
                onReset={handleReset}
                onChange={handleChange}
                onBlur={handleBlur}
                readOnly={loading || loadingFeatureFlags || disablePhoneNumbers || isReadOnly}
              />
            </div>

            {/**
             * TODO: Detect if there is a (metadata) profile and offer
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
              {isReadOnly && (
                <>
                  {arrayHasItems(account?.invoices) ? (
                    <ButtonLink href={account?.actions.transactionsIndex.url}>Transactions</ButtonLink>
                  ) : (
                    <Button disabled>Transactions</Button>
                  )}
                  {account?.actions.showProfile ? (
                    <ButtonLink href={account.actions.showProfile.url}>Profile</ButtonLink>
                  ) : (
                    <>{isIndividualAccount(account) && <ButtonLink href={account.actions.profilesIndex.url}>Profiles</ButtonLink>}</>
                  )}
                  <Button variant="primary" onClick={() => setIsReadOnly(false)}>
                    Edit
                  </Button>
                </>
              )}
            </div>
          </Form>
        )
      }}
    </Formik>
  )
}

export default AccountForm
