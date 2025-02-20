import React, { forwardRef, InputHTMLAttributes, useEffect, useRef, useState } from 'react'
import clsx from 'clsx'
import { Dropdown } from 'flowbite'
import { v4 as uuidv4 } from 'uuid'
import { Field, useFormikContext } from 'formik'
import parsePhoneNumber, { AsYouType } from 'libphonenumber-js'

import { FormInputProps } from '@/types'
import useInputClassNames from '@/utils/hooks/useInputClassNames'
import FormInputHint from '../FormInputHint'
import { RefButton as Button } from '../Button'
import { useLogTransport } from '../LogTransportProvider'
import USFlag from '../SVG/USFlag'
import useListOfCountries from './hooks/useListOfCountries'
import UKFlag from '../SVG/UKFlag'
import AUFlag from '../SVG/AUFlag'
import DEFlag from '../SVG/DEFlag'
import FRFlag from '../SVG/FRFlag'

type PhoneNumberInputProps = InputHTMLAttributes<HTMLInputElement> & FormInputProps & { international?: boolean }

const PhoneNumberComboInput = forwardRef<HTMLInputElement, PhoneNumberInputProps>(function RefPhoneNumberInput(
  { id, type = 'tel', name, label, value, success, error, hint, readOnly, onChange, ...otherProps },
  ref,
) {
  const [dropdownEl, setDropdownEl] = useState<Dropdown | null>(null)
  const countryControlRef = useRef<HTMLButtonElement>(null)
  const countryTargetRef = useRef<HTMLDivElement>(null)
  const countryButtonId = ['dropdown-phone-button', id].filter((x) => x).join('--')
  const countryDropdownId = ['dropdown-phone', id].filter((x) => x).join('--')
  const inputId = id ?? uuidv4()
  // See https://www.npmjs.com/package/libphonenumber-js#as-you-type-formatter
  const formatter = new AsYouType()

  const [showCountryDropdown, setShowCountryDropdown] = useState(false)

  const { containerClassNames, labelClassNames, inputElementClassNames } = useInputClassNames({
    readOnly: !!readOnly,
    error: !!error,
    success: !!success,
  })
  const containerClassName = clsx(containerClassNames, 'flex items-center')
  const labelClassName = clsx(labelClassNames, 'peer-placeholder-shown:left-28')
  const countryDropdownClassName = clsx(
    'flex-shrink-0 z-10 inline-flex items-center absolute top-12 bg-white divide-y divide-gray-100 rounded-lg shadow w-52 dark:bg-gray-700',
    {
      hidden: !showCountryDropdown,
    },
  )

  const { logger } = useLogTransport()
  const { values, handleBlur, handleReset, handleChange, setFieldValue } = useFormikContext<Record<string, string>>()
  const { loading, countries } = useListOfCountries()

  // Setup the country dropdown
  useEffect(() => {
    const $targetEl = countryTargetRef.current
    const $controlEl = countryControlRef.current

    if ($targetEl && $controlEl) {
      const dropdown = new Dropdown(
        $targetEl,
        $controlEl,
        {
          placement: 'bottom-start',
          triggerType: 'click',
        },
        { id: countryDropdownId, override: true },
      )
      setDropdownEl(dropdown)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [countryTargetRef, countryControlRef])

  // Handle formatting the phone number
  useEffect(() => {
    const newValue = values[name]
    if (newValue) {
      const phoneNumber = parsePhoneNumber(newValue)
      const formattedValue = phoneNumber?.formatNational()
      logger.debug('PhoneNumberComboInput#useEffect', { value, formattedValue })
      if (formattedValue) setFieldValue(name, formattedValue, true)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [values[name]])

  // For country flag images, see: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes#Current_ISO_3166_country_codes
  return (
    <div className={containerClassName}>
      <Button
        size="lg"
        loading={loading}
        id={countryButtonId}
        className="flex-shrink-0 inline-flex z-10 rounded-0 text-gray-900 border-0 border-b-2 border-gray-300 focus:ring-4 focus:outline-none focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-white dark:border-gray-600"
        variant="transparent"
        ref={countryControlRef}
        onClick={() => setShowCountryDropdown(!showCountryDropdown)}
      >
        <USFlag /> +1{' '}
        <svg className="w-2.5 h-2.5 ms-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
          <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m1 1 4 4 4-4" />
        </svg>
      </Button>
      <div id={countryDropdownId} ref={countryTargetRef} className={countryDropdownClassName}>
        <ul className="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdown-phone-button">
          <li>
            <button
              type="button"
              className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              <USFlag />
              <span className="inline-flex items-center">United States (+1)</span>
            </button>
          </li>
          <li>
            <button
              type="button"
              className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              <span className="inline-flex items-center">
                <UKFlag /> United Kingdom (+44)
              </span>
            </button>
          </li>
          <li>
            <button
              type="button"
              className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              <span className="inline-flex items-center">
                <AUFlag /> Australia (+61)
              </span>
            </button>
          </li>
          <li>
            <button
              type="button"
              className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              <span className="inline-flex items-center">
                <DEFlag /> Germany (+49)
              </span>
            </button>
          </li>
          <li>
            <button
              type="button"
              className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              <span className="inline-flex items-center">
                <FRFlag /> France (+33)
              </span>
            </button>
          </li>
          {countries.map((country) => (
            <li key={country.alpha2}>
              <button
                type="button"
                className="inline-flex w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600 dark:hover:text-white"
                role="menuitem"
              >
                <div className="inline-flex items-center space-between">
                  {/* <img src={country.flag} alt={country.name} className="w-4 h-4" /> */}
                  <span className="bg-gray-100 text-gray-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-gray-700 dark:text-gray-300">
                    {country.alpha2}
                  </span>
                  <span>{country.name}</span>
                  <span>({country.dialCode})</span>
                </div>
              </button>
            </li>
          ))}
        </ul>
      </div>
      <Field
        {...otherProps}
        id={inputId}
        name={name}
        type={type}
        innerRef={ref}
        className={inputElementClassNames}
        onBlur={handleBlur}
        onReset={handleReset}
        onChange={handleChange}
        placeholder={otherProps.placeholder ?? ' '}
        pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
        readOnly={readOnly}
      />
      {label && (
        <label htmlFor={id} className={labelClassName}>
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
})

export default PhoneNumberComboInput
