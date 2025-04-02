import type { Preview } from '@storybook/react'
import { initialize, mswLoader } from 'msw-storybook-addon'
import { http, HttpResponse, delay } from 'msw'
import mockFeaturesResponse from '../spec/fixtures/msw/feature_flags.json'
import mockIndividualAccountResponse from '../spec/fixtures/msw/accounts/individual.json'
import mockBusinessAccountResponse from '../spec/fixtures/msw/accounts/business.json'
import mockCountriesResponse from '../spec/fixtures/msw/countries.json'

/*
 * Initializes MSW
 * See https://github.com/mswjs/msw-storybook-addon#configuring-msw
 * to learn how to customize it
 */
initialize()

import 'tailwindcss/tailwind.css'
import 'flowbite/dist/flowbite.css'

const preview: Preview = {
  tags: ['autodocs'],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    msw: {
      handlers: [
        http.get('/api/features?format=json', async () => {
          await delay(150)
          return HttpResponse.json(mockFeaturesResponse)
        }),
        http.get('/accounts/1234?format=json', async () => {
          await delay(150)
          return HttpResponse.json(mockIndividualAccountResponse)
        }),
        http.get('/accounts/4321?format=json', async () => {
          await delay(150)
          return HttpResponse.json(mockBusinessAccountResponse)
        }),
        http.get('/api/form_data/countries?format=json', async () => {
          await delay(150)
          return HttpResponse.json(mockCountriesResponse)
        }),
      ],
    },
  },
  loaders: [mswLoader],
}

export default preview
