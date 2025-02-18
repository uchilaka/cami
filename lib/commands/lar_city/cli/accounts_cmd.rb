# frozen_string_literal: true

require 'terminal-table'
require_relative 'base_cmd'

module LarCity
  module CLI
    class AccountsCmd < BaseCmd
      attr_reader :accounts

      namespace 'accounts'

      option :query_string,
             desc: 'The query to search for',
             type: :string,
             aliases: %w[--qs -q]
      desc 'dedupe', 'Consolidate duplicate accounts'
      def dedupe
        with_interruption_rescue do
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
          @accounts = @query.result(distinct: true)
          puts
          if accounts.any?
            say "Found #{accounts.count} #{things(accounts.count, name: 'account')} that might be duplicates", :cyan
            puts

            if accounts.size > row_display_limit
              say "Displaying the first #{row_display_limit} of #{accounts.size} accounts", :magenta
              puts
            end

            until (@primary_account = prompt_for_primary_account_selection)
              output_matched_accounts(limited: accounts.size > row_display_limit)
            end
            # TODO: Offer to merge accounts by setting the most recently updated
            #   (should be the first in the list) as the "parent" account of
            #   the duplicates
          end
        end
      end

      no_commands do
        def qs
          @qs ||= options[:query_string]
        end

        def row_display_limit
          ENV.fetch('PREVIEW_ROW_DISPLAY_LIMIT', 5).to_i
        end

        def prompt_for_primary_account_selection
          raise StandardError, 'No accounts found' if accounts.blank?

          input = ask('Enter the number to select the primary account: ').chomp
          available_row_numbers = accounts_as_rows.map(&:first).map(&:to_s)
          # Handle invalid input
          unless available_row_numbers.include?(input)
            say 'Invalid selection. Please try again.', :red
            puts
            return
          end

          record_index = input.to_i - 1
          accounts[record_index].presence
        end

        def prompt_for_query_string_search
          @qs = ask('Enter a query string to search for accounts: ').chomp
        end

        def output_matched_accounts(limited: false)
          rows = limited ? accounts_as_rows.first(row_display_limit) : accounts_as_rows
          # TODO: Inspect the rows to see if the table is being built correctly
          table = ::Terminal::Table.new(
            headings: ['#', 'Slug', 'Display Name', 'Email', 'Tax ID'],
            rows:
          )
          puts table
          ap(rows) if verbose?
          puts
        end

        def accounts_row_numbers
          accounts_as_rows.map(&:first).map(&:to_s)
        end

        def accounts_as_rows
          @accounts_as_rows ||=
            accounts
              .pluck(:slug, :display_name, :email, :tax_id)
              .map.with_index do |account, index|
                [index + 1, account].flatten
              end
        end
      end
    end
  end
end
