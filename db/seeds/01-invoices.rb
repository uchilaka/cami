# frozen_string_literal: true

Fixtures::Invoices.new.invoke(:load, [], verbose: Rails.env.development?)
