import React, { FC, HTMLAttributes } from 'react'
import clsx from 'clsx'

export type ButtonProps = HTMLAttributes<HTMLButtonElement> & {
  variant?: 'primary' | 'secondary' | 'caution'
  size?: 'xs' | 'sm' | 'base' | 'lg' | 'xl'
}

const Button: FC<ButtonProps> = ({ id, children, variant = 'secondary', size = 'base', ...otherProps }) => {
  const buttonStyle = clsx('btn rounded-lg font-medium text-sm text-center me-2 mb-2 focus:ring-4', {
    'text-white bg-gradient-to-br from-green-400 to-blue-600 hover:bg-gradient-to-bl focus:outline-none focus:ring-green-200 dark:focus:ring-green-800':
      variant === 'primary',
    'text-gray-900 bg-white border border-gray-300 focus:outline-none hover:bg-gray-100 focus:ring-gray-100 dark:bg-gray-800 dark:text-white dark:border-gray-600 dark:hover:bg-gray-700 dark:hover:border-gray-600 dark:focus:ring-gray-700':
      variant === 'secondary',
    'hover:text-white border focus:outline-none dark:hover:text-white text-red-700 border-red-700 hover:bg-red-800 focus:ring-red-300 dark:border-red-500 dark:text-red-500 dark:hover:bg-red-600 dark:focus:ring-red-900':
      variant === 'caution',
    'text-xs px-3 py-2': size === 'xs',
    'text-sm px-3 py-2': size === 'sm',
    'text-sm px-5 py-2.5': size === 'base',
    'text-base px-5 py-3': size === 'lg',
    'text-base px-6 py-3.5': size === 'xl',
  })

  return (
    <button type="button" {...otherProps} id={id} className={buttonStyle}>
      {children}
    </button>
  )
}

export default Button
