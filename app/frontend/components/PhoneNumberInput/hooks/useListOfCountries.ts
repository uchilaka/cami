import { useEffect, useState } from 'react'

// See https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/slim-2/slim-2.json
interface ISO3166Country {
  id: string
  name: string
  alpha2: string
  dialCode: string
}

const useListOfCountries = () => {
  const [loading, setLoading] = useState(true)
  const [countries, setCountries] = useState<ISO3166Country[]>([])

  const get = async () => {
    setLoading(true)
    try {
      const result = await fetch('/api/form_data/countries?format=json')
      const data: ISO3166Country[] = await result.json()
      setCountries(data)
    } catch (_error) {
      // TODO: Handle the error from /api/form_data/countries
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    get()
  }, [])

  return { loading, countries }
}

export default useListOfCountries
