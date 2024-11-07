# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/accounts/1/profiles').to route_to('profiles#index', account_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/accounts/1/profiles/new').to route_to('profiles#new', account_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/accounts/1/profiles/1').to route_to('profiles#show', account_id: '1', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/accounts/1/profiles/1/edit').to route_to('profiles#edit', account_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/accounts/1/profiles').to route_to('profiles#create', account_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/accounts/1/profiles/1').to route_to('profiles#update', account_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/accounts/1/profiles/1').to route_to('profiles#update', account_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/accounts/1/profiles/1').to route_to('profiles#destroy', account_id: '1', id: '1')
    end
  end
end
