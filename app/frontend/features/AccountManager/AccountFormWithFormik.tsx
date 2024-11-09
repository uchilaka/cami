import React, { FC } from 'react'
import { Console } from 'node:console'
import { Form, Field, FormikProps, withFormik } from 'formik'
import * as Yup from 'yup'
import { UseMutationResult } from '@tanstack/react-query'
import { Logger } from '@/components/LogTransportProvider'
import { BusinessAccount, IndividualAccount, isActionableAccount } from '@/utils/api/types'

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

export type AccountFormProps = {
  logger: Console | Logger
  compact?: boolean
  initialType?: AccountFormData['type']
  readOnly?: boolean
  account?: IndividualAccount | BusinessAccount | null
  updateAccount?: UseMutationResult<Response | undefined, Error, AccountFormData>
} & FormikProps<AccountFormData>

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

const AccountInnerForm: FC<AccountFormProps> = () => {
  return (
    <Form>
      <Field name="email" type="email" />
      <Field name="password" type="password" />
      <button type="submit">Submit</button>
    </Form>
  )
}

const AccountInnerFormWithFormik = withFormik<AccountFormProps, AccountFormData>({
  validationSchema,
  validateOnBlur: true,
  mapPropsToValues: ({ initialType }) => ({ displayName: '', email: '', readme: '', type: initialType ?? 'Business' }),
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

export default AccountInnerFormWithFormik
