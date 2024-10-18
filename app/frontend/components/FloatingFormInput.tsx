import React, { FC, HTMLAttributes, InputHTMLAttributes, ReactNode } from 'react'
import clsx from 'clsx'
import { Field } from 'formik'
import { FormInputProps } from '@/types'
import FormInputHint from './FormInputHint'

export const InputRow: FC<HTMLAttributes<HTMLDivElement> & { children: ReactNode }> = ({ children, ...otherProps }) => {
  return (
    <div {...otherProps} className="relative z-0 w-full mb-5 group">
      {children}
    </div>
  )
}

export const InputGrid: FC<HTMLAttributes<HTMLDivElement> & { children: ReactNode; cols?: Number }> = ({ children, ...otherProps }) => {
  const childrenAsList = React.Children.toArray(children)
  const cols = otherProps.cols ?? childrenAsList.length
  const containerStyle = clsx('grid md:gap-6', `md:grid-cols-${cols}`)

  return (
    <div {...otherProps} className={containerStyle}>
      {childrenAsList.map((item) => item)}
    </div>
  )
}

export const FloatingFormInput: FC<InputHTMLAttributes<HTMLInputElement> & FormInputProps> = ({
  label,
  type,
  id,
  className,
  error,
  success,
  hint,
  readOnly,
  ...otherProps
}) => {
  const containerStyle = clsx('relative z-0 w-full mb-5 group', {
    'bg-slate-50 text-slate-500 border-slate-200 shadow-none': !!readOnly,
  })
  const inputStyle = clsx(
    'block py-2.5 px-0 w-full text-lg border-0 border-b-2 bg-transparent appearance-none focus:outline-none focus:ring-0 peer',
    {
      'text-gray-900 border-gray-300 dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:border-blue-600':
        !error && !success,
      'text-green-900 border-green-300 dark:text-green dark:border-green-600 dark:focus:border-green-500 focus:border-green-600': success,
      'text-red-600 border-red-300 dark:text-red dark:border-red-600 dark:focus:border-red-300 focus:border-red-600': error,
      'disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none': !!readOnly,
    },
  )
  const labelStyle = clsx(
    'absolute text-lg transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0',
    {
      'duration-300 peer-focus:font-medium peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-focus:scale-75 peer-focus:-translate-y-6':
        !readOnly,
      'text-gray-500 dark:text-gray-400 peer-focus:text-blue-600 peer-focus:dark:text-blue-500': !error && !success,
      'text-green-500 dark:text-green-400 peer-focus:text-green-600 peer-focus:dark:text-green-500': success,
      'text-red-500 dark:text-red-400 peer-focus:text-red-600 peer-focus:dark:text-red-500': error,
    },
  )
  return (
    <div className={containerStyle}>
      <Field
        {...otherProps}
        id={id}
        type={type ?? 'text'}
        className={inputStyle}
        placeholder={otherProps.placeholder ?? ' '}
        readOnly={readOnly}
      />
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

export default FloatingFormInput
