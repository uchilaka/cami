import React from 'react'
import { Meta, StoryObj } from '@storybook/react'
import CountryFlag from '../PhoneNumberInput/CountryFlag'
import USFlag from './USFlag'
import AUFlag from './AUFlag'
import UKFlag from './UKFlag'
import DEFlag from './DEFlag'
import FRFlag from './FRFlag'
import NGFlag from './NGFlag'

const meta: Meta<typeof CountryFlag> = {
  title: 'Components/CountryFlag',
  component: CountryFlag,
}

export default meta

type Story = StoryObj<typeof meta>

export const AllFlags: Story = {
  render: (_args) => (
    <div className="flex flex-row">
      <USFlag />
      <UKFlag />
      <NGFlag />
      <AUFlag width={40} height="auto" />
      <DEFlag />
      <FRFlag />
    </div>
  ),
}

export const Default: Story = {
  args: { alpha2: 'US' },
}
