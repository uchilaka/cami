require 'rails_helper'

RSpec.describe 'invoices/index', type: :view do
  before(:each) do
    assign(:invoices, [Fabricate(:invoice), Fabricate(:invoice)])
  end

  it 'renders a list of invoices' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
