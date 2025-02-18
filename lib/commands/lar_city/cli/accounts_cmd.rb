# frozen_string_literal: true

require_relative 'base_cmd'

module LarCity
  module CLI
    class AccountsCmd < BaseCmd
      namespace 'accounts'

      option :query_string,
             desc: 'The query to search for',
             type: :string,
             aliases: %w[--qs -q]
      desc 'dedupe', 'Consolidate duplicate accounts'
      def dedupe
        filtered_params =
          ActionController::Parameters
            .new(options)
            .permit(:q, f: {}, s: {})
        if verbose?
          input = { qs:, filtered_params: }
          ap input
        end
        @search_query = AccountSearchQuery.new(qs, params: filtered_params)
        ap @search_query.predicates if verbose?
        @query = Account.ransack(@search_query.predicates)
        @query.sorts = @search_query.sorters if @search_query.sorters.any?
        accounts = @query.result(distinct: true)
        say "Found #{accounts.count} #{things(accounts.count, name: 'account')} that might be duplicates", :green
      end

      no_commands do
        def qs
          options[:query_string]
        end
      end
    end
  end
end
