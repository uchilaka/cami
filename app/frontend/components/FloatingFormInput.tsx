import React, { FC, HTMLAttributes, InputHTMLAttributes, ReactNode } from 'react'
import clsx from 'clsx'
import { Field } from 'formik'

interface ValidationFeedbackProps {
  success?: boolean
  error?: boolean
}

export const InputRow: FC<HTMLAttributes<HTMLDivElement> & { children: ReactNode }> = ({ children, ...otherProps }) => {
  return (
    <div {...otherProps} className="relative z-0 w-full mb-5 group">
      {children}
    </div>
  )
}

export const InputGrid: FC<HTMLAttributes<HTMLDivElement> & { children: ReactNode }> = ({ children, ...otherProps }) => {
  const childrenAsList = React.Children.toArray(children)
  const cols = childrenAsList.length
  const containerStyle = clsx(`grid md:grid-cols-${cols} md:gap-6`)

  return (
    <div {...otherProps} className={containerStyle}>
      {childrenAsList.map((item) => item)}
    </div>
  )
}

const FloatingFormInputHint: FC<HTMLAttributes<HTMLParagraphElement> & ValidationFeedbackProps & { children: ReactNode }> = ({
  children,
  error,
  success,
  ...otherProps
}) => {
  const labelStyle = clsx('mt-2 text-sm', {
    'text-gray-500 dark:text-gray-400': !error && !success,
    'text-green-600 dark:text-green-400': success,
    'text-red-600 dark:text-red-400': error,
  })
  return (
    <p {...otherProps} className={labelStyle}>
      {children}
    </p>
  )
}

interface FloatingFormInputProps extends ValidationFeedbackProps {
  label: string
  hint?: ReactNode
}

export const FloatingFormInput: FC<InputHTMLAttributes<{}> & FloatingFormInputProps> = ({
  label,
  type,
  id,
  className,
  error,
  success,
  hint,
  ...otherProps
}) => {
  const inputStyle = clsx(
    'block py-2.5 px-0 w-full text-lg border-0 border-b-2 bg-transparent appearance-none focus:outline-none focus:ring-0 peer',
    {
      'text-gray-900 border-gray-300 dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:border-blue-600':
        !error && !success,
      'text-green-900 border-green-300 dark:text-green dark:border-green-600 dark:focus:border-green-500 focus:border-green-600': success,
      'text-red-600 border-red-300 dark:text-red dark:border-red-600 dark:focus:border-red-300 focus:border-red-600': error,
    },
  )
  const labelStyle = clsx(
    'peer-focus:font-medium absolute text-lg duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6',
    {
      'text-gray-500 dark:text-gray-400 peer-focus:text-blue-600 peer-focus:dark:text-blue-500': !error && !success,
      'text-green-500 dark:text-green-400 peer-focus:text-green-600 peer-focus:dark:text-green-500': success,
      'text-red-500 dark:text-red-400 peer-focus:text-red-600 peer-focus:dark:text-red-500': error,
    },
  )
  return (
    <div className="relative z-0 w-full mb-5 group">
      <Field {...otherProps} id={id} type={type ?? 'text'} className={inputStyle} placeholder={otherProps.placeholder ?? ' '} />
      {label && (
        <label htmlFor={id} className={labelStyle}>
          {label}
        </label>
      )}
      {hint && (
        <FloatingFormInputHint error={error} success={success}>
          {hint}
        </FloatingFormInputHint>
      )}
    </div>
  )
}

export default FloatingFormInput
