import React, { FC, InputHTMLAttributes } from 'react'
import { FormInputProps } from '@/types'
import PhoneInput from 'react-phone-number-input'
import { Field, useFormikContext } from 'formik'
import useInputClassNames from '@/utils/hooks/useInputClassNames'
import FormInputHint from '../FormInputHint'

import 'react-phone-number-input/style.css'

type PhoneNumberInputProps = InputHTMLAttributes<HTMLInputElement> & FormInputProps

const PhoneLibNumberInput: FC<PhoneNumberInputProps> = ({ id, type = 'tel', label, success, error, hint, readOnly, ...otherProps }) => {
  const { containerClassNames, labelClassNames, inputElementClassNames } = useInputClassNames({
    readOnly: !!readOnly,
    error: !!error,
    success: !!success,
  })
  const { handleChange, values = {} } = useFormikContext<Record<string, string>>()

  return (
    <div className={containerClassNames}>
      <PhoneInput
        {...otherProps}
        id={id}
        className={inputElementClassNames}
        defaultCountry="US"
        value={values[otherProps.name]}
        onChange={handleChange}
      />
      {label && (
        <label htmlFor={id} className={labelClassNames}>
          {label}
        </label>
      )}
      {hint && (
        <FormInputHint error={error} success={success}>
          {hint}
        </FormInputHint>
      )}
    </div>
  )
}

export default PhoneLibNumberInput
