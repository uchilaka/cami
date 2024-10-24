# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/metadata_profiles').to route_to('metadata_profiles#index')
    end

    it 'routes to #new' do
      expect(get: '/metadata_profiles/new').to route_to('metadata_profiles#new')
    end

    it 'routes to #show' do
      expect(get: '/metadata_profiles/1').to route_to('metadata_profiles#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/metadata_profiles/1/edit').to route_to('metadata_profiles#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/metadata_profiles').to route_to('metadata_profiles#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/metadata_profiles/1').to route_to('metadata_profiles#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/metadata_profiles/1').to route_to('metadata_profiles#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/metadata_profiles/1').to route_to('metadata_profiles#destroy', id: '1')
    end
  end
end
