# frozen_string_literal: true

require 'rails_helper'

load_lib_script 'commands', 'hello_cmd', ext: 'thor'

RSpec.describe HelloCmd, type: :thor do
  let(:command) { described_class.new }

  describe 'hello' do
    context 'when no name is provided' do
      it 'says hello to the world' do
        expect { command.invoke(:hello) }.to output(/👋🏽 Hello, world!/).to_stdout
      end
    end

    context 'when a name is provided' do
      it 'says hello to the provided name' do
        expect { command.invoke(:hello, [], name: 'Alice') }.to output(/👋🏽 Hello, Alice!/).to_stdout
      end
    end

    context 'when the operating system is detected' do
      before do
        allow(command).to receive(:friendly_os_name).and_return(:linux)
        # allow(command).to receive(:human_friendly_os_names_map).and_return({ linux: 'Linux' })
      end

      it 'includes the operating system in the output' do
        expect { command.invoke(:hello) }.to output(/You're running on Linux 💻/).to_stdout
      end
    end

    context 'when the operating system is unsupported' do
      before do
        allow(command).to receive(:friendly_os_name).and_return(:unsupported)
      end

      it 'does not include the operating system in the output' do
        expect { command.invoke(:hello) }.to output(/👋🏽 Hello, world!/).to_stdout
      end
    end
  end
end