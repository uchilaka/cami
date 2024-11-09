import React, { FC, forwardRef, InputHTMLAttributes, useEffect } from 'react'
import PhoneLibInput, { isValidPhoneNumber, formatPhoneNumberIntl } from 'react-phone-number-input'
import { useFormikContext } from 'formik'
import clsx from 'clsx'
import { FormInputProps } from '@/types'
import useInputClassNames from '@/utils/hooks/useInputClassNames'
import FormInputHint from '../FormInputHint'

import 'react-phone-number-input/style.css'

type PhoneNumberInputProps = InputHTMLAttributes<HTMLInputElement> & FormInputProps

const StyledInput = forwardRef<HTMLInputElement, PhoneNumberInputProps>(function StyledPhoneInput(
  { id, name, value, onChange, ...otherProps },
  ref,
) {
  const { handleBlur, handleReset, setFieldValue } = useFormikContext<Record<string, string>>()

  const classNames = clsx('border-0 w-full bg-transparent', {
    'cursor-not-allowed': otherProps.readOnly || otherProps.disabled,
  })

  console.debug({ id, name, value })

  useEffect(() => {
    const valueString = `${value}`
    if (isValidPhoneNumber(valueString)) {
      const intlValue = formatPhoneNumberIntl(valueString)
      const e164Value = intlValue.replace(/\s/g, '')
      setFieldValue(name, e164Value, true)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [value])

  return (
    <input
      id={id}
      ref={ref}
      name={name}
      {...otherProps}
      className={classNames}
      placeholder={otherProps.placeholder ?? ' '}
      defaultValue={value}
      onChange={onChange}
      onBlur={handleBlur}
      onReset={handleReset}
    />
  )
})

const PhoneLibNumberInput: FC<PhoneNumberInputProps> = ({ id, label, success, error, hint, readOnly, ...otherProps }) => {
  const { containerClassNames, labelClassNames, inputElementClassNames } = useInputClassNames({
    readOnly: !!readOnly,
    error: !!error,
    success: !!success,
  })
  const inputClassName = clsx(inputElementClassNames, 'pb-0', { 'cursor-not-allowed': readOnly || otherProps.disabled })
  const { handleChange, errors, values = {} } = useFormikContext<Record<string, string>>()
  const message = errors[otherProps.name] ?? hint

  return (
    <div className={containerClassNames}>
      <PhoneLibInput
        {...otherProps}
        id={id}
        international
        inputComponent={StyledInput}
        className={inputClassName}
        defaultCountry="US"
        value={values[otherProps.name]}
        onChange={handleChange}
        readOnly={readOnly}
      />
      {label && (
        <label htmlFor={id} className={labelClassNames}>
          {label}
        </label>
      )}
      {message && (
        <FormInputHint error={error} success={success}>
          {message}
        </FormInputHint>
      )}
    </div>
  )
}

export default PhoneLibNumberInput
