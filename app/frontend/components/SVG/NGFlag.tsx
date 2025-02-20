import React from 'react'

const NGFlag = () => {
  return (
    <svg className="w-4 h-4 me-2" fill="none" viewBox="0 0 20 15">
      <rect width="19.1" height="13.5" x=".25" y=".75" fill="#fff" stroke="#F5F5F5" strokeWidth=".5" rx="1.75" />
      <mask id="a" style={{ maskType: 'luminance' }} width="20" height="15" x="0" y="0" maskUnits="userSpaceOnUse">
        <rect width="19.1" height="13.5" x=".25" y=".75" fill="#fff" stroke="#fff" strokeWidth=".5" rx="1.75" />
      </mask>
      <g mask="url(#a)">
        <path fill="#00833E" d="M13.067.5H19.6v14h-6.533z" />
        <path fill="#00833E" fillRule="evenodd" d="M0 14.5h6.533V.5H0v14z" clipRule="evenodd" />
      </g>
    </svg>
  )
}

export default NGFlag
