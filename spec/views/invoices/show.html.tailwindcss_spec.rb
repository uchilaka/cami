require 'rails_helper'

RSpec.describe 'invoices/show', type: :view do
  before(:each) do
    assign(:invoice, Fabricate(:invoice))
  end

  it 'renders attributes in <p>' do
    render
  end
end
