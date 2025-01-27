# frozen_string_literal: true

class InvoiceSearchQuery
  attr_reader :query_string, :params, :filters, :sorters, :predicates

  def initialize(query_string = nil, params: {})
    @query_string = query_string
    @params = params
    @filters ||= {}
    @sorters ||= []
    @predicates ||= {}
    build
  end

  def extend(params)
    @params = @params.merge(params)
    rebuild
  end

  def build
    compose_predicates
    compose_sorters
  end

  alias rebuild build

  private

  def compose_predicates
    @predicates =
      if compose_filters.present?
        filters.each_with_object({}) do |(field, value), predicates|
          case field
          when 'dueAt'
            predicates[:due_at_gteq] = value
          when 'status'
            predicates[:status_eq] = value.downcase
          else
            predicates[:"#{field}_cont"] = value
          end
        end
      else
        {}
      end
    return predicates unless query_param.present?

    account_search_predicate =
      Invoice.fuzzy_search_predicate_key(
        'display_name', 'email',
        model_name: :invoiceable,
        association: 'Account',
        polymorphic: true,
        matcher: nil
      )
    invoice_search_predicate =
      Invoice.fuzzy_search_predicate_key('invoice_number', matcher: nil)
    compound_cont_predicate =
      [invoice_search_predicate, account_search_predicate].join('_or_')
    @predicates["#{compound_cont_predicate}_cont"] = query_param
  end

  def compose_filters
    return filters if filter_params.blank?

    @filters =
      if filter_params.is_a?(Hash)
        filter_params
      elsif filter_params.is_a?(Array)
        filter_params.each_with_object({}) do |filter, hash|
          hash[filter['field']] = filter['value']
        end
      else
        filters
      end
  end

  def compose_sorters
    return sorters if sort_params.blank?

    @sorters =
      if sort_params.is_a?(Array)
        sort_params.each_with_object([]) do |sorter, clauses|
          field, direction = sorter.values_at 'field', 'direction'
          clauses << compose_sorter_clause(field:, direction:)
        end
      elsif sort_params.is_a?(Hash)
        sort_params.each_with_object([]) do |(field, direction), clauses|
          clauses << compose_sorter_clause(field:, direction:)
        end
      else
        sorters
      end
  end

  def query_param
    params.permit(:q)[:q]
  end

  def filter_params
    extract_search_params('f')
  end

  def sort_params
    extract_search_params('s', [])
  end

  def extract_search_params(key, default_value = {})
    # TODO: Filter params here based on whether we're trying for an array or a hash
    if params[key].present?
      begin
        {}.merge(params[key] || {})
      rescue TypeError => _e
        params[key].to_a
      end
    else
      default_value
    end
  end

  def compose_sorter_clause(field:, direction: 'asc')
    case field
    when 'dueAt'
      "due_at #{direction}".strip
    else
      "#{field.parameterize} #{direction}".strip
    end
  end
end
