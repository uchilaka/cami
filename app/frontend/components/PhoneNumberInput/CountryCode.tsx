import React, { FC } from 'react'

import { ISO3166Country } from './hooks/useListOfCountries'
import CountryFlag from './CountryFlag'

const CountryCode: FC<{ country?: ISO3166Country }> = ({ country }) => {
  return (
    <>
      <CountryFlag alpha2={country?.alpha2} /> <span>{country?.dialCode ?? '- -'}</span>
    </>
  )
}

export default CountryCode
