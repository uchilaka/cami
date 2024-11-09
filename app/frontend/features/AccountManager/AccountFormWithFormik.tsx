import React, { FC, useState } from 'react'
import { Console } from 'node:console'
import snakecaseKeys from 'snakecase-keys'
import FormInput from '@/components/FloatingFormInput'
import PhoneInput from '@/components/PhoneNumberInput/PhoneLibNumberInput'
import { useAccountContext } from './AccountProvider'
import TextareaInput from '@/components/TextareaInput'
import Button from '@/components/Button'
import { useMutation } from '@tanstack/react-query'
import ButtonLink from '@/components/Button/ButtonLink'
import { Form, Field, FormikProps, withFormik, FormikBag, FormikComputedProps } from 'formik'
import * as Yup from 'yup'
import { UseMutationResult } from '@tanstack/react-query'
import { Logger, useLogTransport } from '@/components/LogTransportProvider'
import {
  arrayHasItems,
  BusinessAccount,
  IndividualAccount,
  isActionableAccount,
  isBusinessAccount,
  isIndividualAccount,
} from '@/utils/api/types'
import { useFeatureFlagsContext } from '@/components/FeatureFlagsProvider'
import useCsrfToken from '@/utils/hooks/useCsrfToken'
import clsx from 'clsx'

export type ProfileFormData = {
  givenName: string
  familyName: string
  phone?: string
}

export type AccountFormData = Partial<ProfileFormData> & {
  displayName: string
  email: string
  type: 'Individual' | 'Business'
  readme?: string
}

export interface AccountFormProps {
  compact?: boolean
  initialType?: AccountFormData['type']
  initialValues?: AccountFormData
  readOnly?: boolean
}

type AccountInnerFormProps = AccountFormProps & {
  logger: Console | Logger
  account?: IndividualAccount | BusinessAccount | null
  updateAccount?: UseMutationResult<Response | undefined, Error, AccountFormData>
} & FormikComputedProps<AccountFormData>

export const validationSchema = Yup.object({
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

const AccountInnerForm: FC<AccountInnerFormProps> = ({ compact }) => {
  const formClassName = clsx('mx-auto', { 'max-w-lg': !compact })

  return (
    <Form>
      <Field name="email" type="email" />
      <Field name="password" type="password" />
      <button type="submit">Submit</button>
    </Form>
  )
}

export const AccountFormWithFormik = withFormik<AccountInnerFormProps, AccountFormData>({
  validationSchema,
  validateOnBlur: true,
  mapPropsToValues: ({
    initialType,
    initialValues = {
      displayName: '',
      email: '',
      readme: '',
      type: initialType ?? 'Business',
    },
  }) => ({
    ...initialValues,
  }),
  handleSubmit: async (values, { setSubmitting, validateForm, props }) => {
    const { logger, account, updateAccount } = props
    setSubmitting(true)
    const validationErrors = await validateForm(values)
    if (Object.keys(validationErrors).length > 0) {
      // Errors were reported
      logger.debug({ values, errors: validationErrors })
    } else {
      logger.debug({ values })
      if (updateAccount && isActionableAccount(account)) {
        // Submit the form
        updateAccount.mutate(values)
      } else {
        // Set an error
      }
    }
    setSubmitting(false)
  },
})(AccountInnerForm)

const AccountForm: FC<AccountFormProps> = ({ compact, ...props }) => {
  const [saved, setSaved] = useState<boolean>()
  const { logger } = useLogTransport()
  const { loading, account } = useAccountContext()
  const { loading: loadingFeatureFlags, isEnabled } = useFeatureFlagsContext()
  const disablePhoneNumbers = !isEnabled('editable_phone_numbers')
  const { csrfToken } = useCsrfToken()

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

  const mappedProps = {
    compact,
    ...props,
    dirty: false,
    initialErrors: {},
    initialTouched: {},
    // isSubmitting: false,
    isValid: false,
    // isValidating: false,
    // submitCount: 0,
  }

  return <AccountFormWithFormik {...mappedProps} logger={logger} initialValues={initialValues} updateAccount={updateAccount} />
}

export default AccountForm
