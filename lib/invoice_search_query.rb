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
    return if compose_filters.blank?

    @predicates = filters.each_with_object({}) do |(field, value), predicates|
      case field
      when 'dueAt'
        predicates[:due_at_gteq] = value
      else
        predicates[:"#{field}_eq"] = value
      end
    end
  end

  def compose_filters
    param_filters = @params['f'] || []
    return if param_filters.blank?

    @filters =
      if param_filters.is_a?(Hash)
        param_filters
      elsif param_filters.is_a?(Array)
        param_filters.each_with_object({}) do |filter, hash|
          hash[filter['field']] = filter['value']
        end
      else
        {}
      end
  end

  def compose_sorters
    param_sorters = @params['s'] || []
    return if param_sorters.blank?

    @sorters =
      if param_sorters.is_a?(Array)
        param_sorters.each_with_object([]) do |sorter, clauses|
          field, direction = sorter.values_at 'field', 'direction'
          clauses << compose_sorter_clause(field:, direction:)
        end
      elsif param_sorters.is_a?(Hash)
        param_sorters.each_with_object([]) do |(field, direction), clauses|
          clauses << compose_sorter_clause(field:, direction:)
        end
      else
        []
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
