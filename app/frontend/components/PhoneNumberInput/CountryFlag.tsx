import React, { FC, ReactNode } from 'react'

import USFlag from '../SVG/USFlag'
import UKFlag from '../SVG/UKFlag'
import AUFlag from '../SVG/AUFlag'
import DEFlag from '../SVG/DEFlag'
import FRFlag from '../SVG/FRFlag'
import CountryCodeBadge from './CountryCodeBadge'
import { CountryFlagProps } from '../SVG/types'

const knownFlagsDictionary: Record<string, ReactNode> = {
  US: <USFlag size="sm" className="mx-2" />,
  UK: <UKFlag size="sm" className="mx-2" />,
  AU: <AUFlag size="sm" className="mx-2" />,
  DE: <DEFlag size="sm" className="mx-2" />,
  FR: <FRFlag size="sm" className="mx-2" />,
}

const CountryFlag: FC<CountryFlagProps> = ({ alpha2 }) => {
  return (
    <>
      {alpha2 && knownFlagsDictionary[alpha2]}
      {alpha2 && !knownFlagsDictionary[alpha2] && <CountryCodeBadge code={alpha2} />}
    </>
  )
}

export default CountryFlag
