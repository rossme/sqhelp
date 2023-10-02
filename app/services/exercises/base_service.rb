# frozen_string_literal: true

module Exercises
  class BaseService
    include ActiveModel::Validations
    validates :user_answer, :exercise_id, presence: true

    def initialize(user_answer:, exercise_id:)
      @user_answer  = user_answer
      @exercise_id  = exercise_id
      @query_errors = []
    end

    attr_reader :user_answer, :exercise_id, :query_errors

    def safe_execute_query(query)
      valid_query_check
      ActiveRecord::Base.connected_to(role: :reading, prevent_writes: true) do
        ActiveRecord::Base.connection.execute(query).to_a
      end
    end

    private

    def exercise
      @exercise ||= Exercise.find_by(id: exercise_id)
    end

    def valid_query_check
      matches = MALICIOUS_QUERIES.select { |mq| user_answer.upcase.scan(/\b#{Regexp.escape(mq)}\b/).any? }
      return unless matches.any?

      raise ActiveRecord::ReadOnlyError, 'Your query is a potentially malicious query'
    end

    MALICIOUS_QUERIES = %w[DROP DELETE UPDATE INSERT CREATE ALTER DROP DATABASE].freeze
  end
end
