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
        prompt_for_query_string_search if qs.blank?
        filtered_params =
          ActionController::Parameters
            .new(options.merge(s: { updatedAt: 'desc' }))
            .permit(:q, f: {}, s: {})
        if verbose?
          input = { qs:, filtered_params: }
          ap input
        end
        @search_query = AccountSearchQuery.new(qs, params: filtered_params)
        if verbose?
          output = {
            predicates: @search_query.predicates,
            sorters: @search_query.sorters
          }
          ap output
        end
        @query = Account.ransack(@search_query.predicates)
        @query.sorts = @search_query.sorters if @search_query.sorters.any?
        accounts = @query.result(distinct: true)
        say "Found #{accounts.count} #{things(accounts.count, name: 'account')} that might be duplicates", :yellow
        # TODO: Offer to merge accounts by setting the most recently updated
        #   (should be the first in the list) as the "parent" account of
        #   the duplicates
      end

      no_commands do
        def qs
          @qs ||= options[:query_string]
        end

        def prompt_for_query_string_search
          @qs = ask('Enter a query string to search for accounts: ').chomp
        end
      end
    end
  end
end
