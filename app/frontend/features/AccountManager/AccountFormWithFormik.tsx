import React, { Dispatch, FC, SetStateAction, useCallback, useEffect, useState } from 'react'
import { Console } from 'node:console'
import snakecaseKeys from 'snakecase-keys'
import FormInput from '@/components/FloatingFormInput'
import PhoneInput from '@/components/PhoneNumberInput/PhoneLibNumberInput'
import { useAccountContext } from './AccountProvider'
import TextareaInput from '@/components/TextareaInput'
import Button from '@/components/Button'
import { useMutation } from '@tanstack/react-query'
import ButtonLink from '@/components/Button/ButtonLink'
import { Form, withFormik, FormikComputedProps, useFormikContext, setIn } from 'formik'
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
  setReadOnly: Dispatch<SetStateAction<boolean>>
  accountId?: string
  compact?: boolean
  loading?: boolean
  initialType?: AccountFormData['type']
  initialValues?: AccountFormData
  readOnly?: boolean
  saved?: boolean
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

const composeFormValues = (account?: IndividualAccount | BusinessAccount | null, initialType?: AccountFormData['type']) => {
  return {
    displayName: account?.displayName ?? '',
    email: account?.email ?? '',
    /**
     * TODO: There's a warning about this output (how we're processing it
     * on the backend using :to_plain_text on the ActionText::RichText object)
     * not being HTML safe:
     * https://api.rubyonrails.org/v8.0.0/classes/ActionText/RichText.html#method-i-to_plain_text
     */
    readme: account?.readme?.plaintext ?? '',
    phone: (isBusinessAccount(account) ? account?.phone : '') ?? '',
    type: account?.type ?? initialType ?? 'Business',
    ...(isIndividualAccount(account)
      ? {
          givenName: account?.profile?.givenName ?? '',
          familyName: account?.profile?.familyName ?? '',
          phone: account?.profile?.phone ?? '',
        }
      : {}),
  }
}

const AccountInnerForm: FC<AccountInnerFormProps> = ({
  compact,
  loading,
  saved,
  initialType,
  readOnly,
  setReadOnly,
  logger,
  account: initialAccount,
}) => {
  const [account, setAccount] = useState(() => initialAccount)
  const { handleChange, handleReset, handleBlur, handleSubmit, isValid, isValidating, isSubmitting, errors, values, setValues } =
    useFormikContext<AccountFormData>()
  const { loading: loadingFeatureFlags, isEnabled } = useFeatureFlagsContext()
  const { loading: loadingAccount, account: loadedAccount } = useAccountContext()
  const disablePhoneNumbers = !isEnabled('editable_phone_numbers')
  const formClassName = clsx('mx-auto', { 'max-w-lg': !compact })

  logger.debug('AccountInnerForm:', { account, isReadOnly: readOnly, initialType, saved })

  useEffect(() => {
    if (account) setValues(composeFormValues(account))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [account])

  useEffect(() => {
    if (loadedAccount && readOnly) setAccount(loadedAccount)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loadingAccount, loadedAccount, readOnly])

  return (
    <Form className={formClassName} onSubmit={handleSubmit}>
      <FormInput
        id="displayName"
        type="text"
        label={values.type === 'Business' ? 'Company (Ex. Google)' : 'Display name'}
        autoComplete="off"
        name="displayName"
        placeholder=" "
        error={!!errors.displayName}
        hint={errors.displayName}
        onReset={handleReset}
        onChange={handleChange}
        onBlur={handleBlur}
        readOnly={loading || readOnly}
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
          readOnly={loading || readOnly}
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
          readOnly={loading || loadingFeatureFlags || disablePhoneNumbers || readOnly}
        />
      </div>

      {/**
       * TODO: Detect if there is a (metadata) profile and offer
       * to create one to save givenName and familyName
       */}
      {values.type === 'Individual' && (
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
            readOnly={loading || readOnly}
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
            readOnly={loading || readOnly}
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
        readOnly={loading || readOnly}
      />

      <div className="flex justify-end items-center space-x-2">
        {!readOnly && (
          <>
            <Button onClick={() => setReadOnly(true)}>Cancel</Button>
            <Button disabled variant="caution">
              Delete this account
            </Button>
            <Button variant="primary" type="submit" disabled={loading || !isValid || isValidating || isSubmitting}>
              Save
            </Button>
          </>
        )}
        {readOnly && (
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
            <Button variant="primary" onClick={() => setReadOnly(false)}>
              Edit
            </Button>
          </>
        )}
      </div>
    </Form>
  )
}

export const AccountFormWithFormik = withFormik<AccountInnerFormProps, AccountFormData>({
  validationSchema,
  validateOnBlur: true,
  mapPropsToValues: ({ initialValues }) => ({
    givenName: '',
    familyName: '',
    phone: '',
    readme: '',
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

const AccountForm: FC<Omit<AccountFormProps, 'setReadOnly'>> = ({ compact, initialType, readOnly, saved, accountId, ...props }) => {
  const [hasBeenSaved, setHasBeenSaved] = useState<boolean | undefined>(saved)
  const [isReadOnly, setIsReadOnly] = useState(readOnly ?? true)
  const { logger } = useLogTransport()
  const { loading, account, setAccountId } = useAccountContext()
  const [currentAccount, setCurrentAccount] = useState(account)
  const { csrfToken } = useCsrfToken()

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
    onSuccess: async (result) => {
      const account = await result?.json()
      logger.debug('Account updated:', { account })
      setHasBeenSaved(true)
      /**
       * IMPORTANT: Enabling read-only mode signals to the form that
       * the account data has been updated and passes the condition(s) for
       * the form to be reloaded.
       */
      setIsReadOnly(true)
      setCurrentAccount(account)
    },
  })

  logger.debug('Account Form (withFormik):', { account, loading })

  const mappedProps = {
    compact,
    loading,
    ...props,
    dirty: false,
    initialType,
    initialErrors: {},
    initialTouched: {},
    isValid: false,
    saved: hasBeenSaved,
    readOnly: isReadOnly,
    setReadOnly: setIsReadOnly,
  }

  useEffect(() => {
    // Capture the account ID property and set it in the context
    if (accountId && readOnly) setAccountId(accountId)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [accountId, readOnly])

  return (
    <AccountFormWithFormik
      {...mappedProps}
      logger={logger}
      initialValues={{
        displayName: '',
        givenName: '',
        familyName: '',
        phone: '',
        email: '',
        readme: '',
        type: initialType ?? 'Business',
      }}
      account={currentAccount}
      updateAccount={updateAccount}
    />
  )
}

export default AccountForm
