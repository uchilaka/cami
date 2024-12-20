import React, { ComponentProps, FC } from 'react'

const OutboundLink: FC<ComponentProps<'a'>> = ({ children, ...props }) => {
  return (
    <a {...props} className="font-medium text-blue-600 dark:text-blue-500 hover:underline">
      {children}
    </a>
  )
}

export default OutboundLink
