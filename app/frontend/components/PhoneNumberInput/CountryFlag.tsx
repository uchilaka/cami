import React, { FC, ReactNode } from 'react'

import USFlag from '../SVG/USFlag'
import UKFlag from '../SVG/UKFlag'
import AUFlag from '../SVG/AUFlag'
import DEFlag from '../SVG/DEFlag'
import FRFlag from '../SVG/FRFlag'
import CountryCodeBadge from './CountryCodeBadge'

const knownFlagsDictionary: Record<string, ReactNode> = {
  US: <USFlag />,
  UK: <UKFlag />,
  AU: <AUFlag />,
  DE: <DEFlag />,
  FR: <FRFlag />,
}

// Generate a type from the keys of the dictionary.
type KnownFlagKeys = keyof typeof knownFlagsDictionary

const CountryFlag: FC<{ alpha2?: string | KnownFlagKeys }> = ({ alpha2 }) => {
  return (
    <>
      {alpha2 && knownFlagsDictionary[alpha2]}
      {alpha2 && !knownFlagsDictionary[alpha2] && <CountryCodeBadge code={alpha2} />}
    </>
  )
}

export default CountryFlag
