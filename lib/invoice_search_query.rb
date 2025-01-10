# frozen_string_literal: true

class InvoiceSearchQuery
  attr_reader :query_string, :params, :filters, :sorters, :predicates

  def initialize(query_string = nil, params: {})
    @query_string = query_string
    @params = params.with_indifferent_access
    @filters ||= {}
    @sorters ||= []
    @predicates ||= {}
    build
  end

  def extend(params)
    @params = @params.merge(params).with_indifferent_access
    rebuild
  end

  def build
    compose_filters
    compose_sorters
    compose_predicates
  end

  alias rebuild build

  private

  def compose_predicates
    return if filters.blank?

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
    param_filters = @params[:f] || []
    return if param_filters.blank?
    return unless param_filters.is_a?(Array)

    @filters = param_filters.each_with_object({}) do |filter, hash|
      hash[filter['field']] = filter['value']
    end
  end

  def compose_sorters
    param_sorters = @params[:s] || []
    return if param_sorters.blank?
    return unless param_sorters.is_a?(Array)

    @sorters = param_sorters.each_with_object([]) do |sorter, clauses|
      clauses <<
        case sorter['field']
        when 'dueAt'
          "due_at #{sorter['direction']}".strip
        else
          "#{sorter['field'].parameterize} #{sorter['direction']}".strip
        end
    end
  end
end
