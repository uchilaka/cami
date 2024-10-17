import React, { FC, HTMLAttributes } from 'react'
import { Field } from 'formik'
import clsx from 'clsx'
import { FormInputProps } from '@/types'
import FormInputHint from '../FormInputHint'

export type TextareaInputProps = HTMLAttributes<HTMLTextAreaElement> & FormInputProps & { readOnly?: boolean }

const TextareaInput: FC<TextareaInputProps> = ({ id, label, placeholder, hint, error, success, readOnly, ...otherProps }) => {
  const labelStyle = clsx(
    'peer-focus:font-medium absolute text-lg duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6',
    {
      'text-gray-500 dark:text-gray-400 peer-focus:text-blue-600 peer-focus:dark:text-blue-500': !error && !success,
      'text-green-500 dark:text-green-400 peer-focus:text-green-600 peer-focus:dark:text-green-500': success,
      'text-red-500 dark:text-red-400 peer-focus:text-red-600 peer-focus:dark:text-red-500': error,
    },
  )
  const inputStyle = clsx(
    'block py-2.5 px-0 w-full text-lg border-0 border-b-2 bg-transparent appearance-none focus:outline-none focus:ring-0 peer',
    {
      'text-gray-900 border-gray-300 dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:border-blue-600':
        !error && !success,
      'text-green-900 border-green-300 dark:text-green dark:border-green-600 dark:focus:border-green-500 focus:border-green-600': success,
      'text-red-600 border-red-300 dark:text-red dark:border-red-600 dark:focus:border-red-300 focus:border-red-600': error,
    },
  )
  return (
    <div className="relative z-0 w-full mb-5 group">
      <Field as="textarea" {...otherProps} id={id} rows={4} className={inputStyle} placeholder={placeholder ?? ' '} readOnly={readOnly} />
      {label && (
        <label htmlFor={id} className={labelStyle}>
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

export default TextareaInput
