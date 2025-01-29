import React, { ButtonHTMLAttributes, FC, ReactNode } from 'react'
import clsx from 'clsx'
import { ButtonBaseProps, ButtonLoader } from '.'
import useButtonClassNames from '@/utils/hooks/useButtonClassNames'

type GroupActionButtonProps = ButtonHTMLAttributes<HTMLButtonElement> &
  Pick<ButtonBaseProps, 'loading' | 'size'> & {
    icon?: ReactNode
    position?: 'first' | 'last'
  }

const GroupActionButton: FC<GroupActionButtonProps> = ({
  id,
  children,
  loading,
  icon,
  position,
  size = 'base',
  className = 'inline-flex items-center font-medium text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:hover:text-white dark:hover:bg-gray-700 dark:focus:ring-blue-500 dark:focus:text-white',
  ...otherProps
}) => {
  const { buttonClassNames } = useButtonClassNames({ size, loading, disabled: otherProps.disabled })
  const buttonStyle = clsx(className, buttonClassNames, {
    'rounded-e-lg': position === 'last',
    'rounded-s-lg': position === 'first',
    'border-t border-b': !position,
  })

  return (
    <button type="button" {...otherProps} className={buttonStyle}>
      {loading ? (
        <ButtonLoader />
      ) : (
        <>
          {icon} {children}
        </>
      )}
    </button>
  )
}

export default GroupActionButton
