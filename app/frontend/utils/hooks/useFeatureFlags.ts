import { useEffect, useState } from 'react'
import { getFeatureFlags } from '../api'

export interface FeatureFlagsProps {
  loading: boolean
  error: Error | unknown
  flags: Record<string, boolean>
  refetch: () => Promise<Record<string, boolean> | null>
}

export default function useFeatureFlags() {
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | unknown>()
  const [flags, setFlags] = useState<Record<string, boolean>>({})

  const asyncFetch = async () => {
    try {
      const latestFlags = await getFeatureFlags()
      setFlags(latestFlags)
      return latestFlags
    } catch (err) {
      setError(err)
      return null
    } finally {
      setLoading(false)
    }
  }

  console.debug({ loading, flags })

  useEffect(() => {
    asyncFetch()
  }, [])

  return { loading, error, flags, refetch: asyncFetch }
}