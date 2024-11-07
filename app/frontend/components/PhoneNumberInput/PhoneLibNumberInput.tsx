import React, { FC, InputHTMLAttributes } from 'react'
import PhoneLibInput from 'react-phone-number-input'
import { useFormikContext } from 'formik'
import clsx from 'clsx'
import { FormInputProps } from '@/types'
import useInputClassNames from '@/utils/hooks/useInputClassNames'
import FormInputHint from '../FormInputHint'

import 'react-phone-number-input/style.css'

type PhoneNumberInputProps = InputHTMLAttributes<HTMLInputElement> & FormInputProps

const StyledInput: FC<InputHTMLAttributes<HTMLInputElement>> = ({ name = 'phone', ...otherProps }) => {
  const { handleChange, handleBlur, handleReset } = useFormikContext<Record<string, string>>()

  return <input name={name} {...otherProps} className="border-0 w-full" onChange={handleChange} onBlur={handleBlur} onReset={handleReset} />
}

const PhoneLibNumberInput: FC<PhoneNumberInputProps> = ({ id, type = 'tel', label, success, error, hint, readOnly, ...otherProps }) => {
  const { containerClassNames, labelClassNames, inputElementClassNames } = useInputClassNames({
    readOnly: !!readOnly,
    error: !!error,
    success: !!success,
  })
  const inputClassName = clsx(inputElementClassNames, 'border-0')
  const { handleChange, errors, values = {} } = useFormikContext<Record<string, string>>()

  return (
    <div className={containerClassNames}>
      <PhoneLibInput
        {...otherProps}
        international
        inputComponent={StyledInput}
        id={id}
        className={inputClassName}
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
