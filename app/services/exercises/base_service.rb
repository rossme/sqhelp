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
      matches = malicious_query_check.select { |mq| user_answer.upcase.scan(/\b#{Regexp.escape(mq)}\b/).any? }
      return unless matches.any?

      raise ActiveRecord::ReadOnlyError, 'This database is strictly read-only'
    end

    def malicious_query_check
      blacklisted_queries = Rails.root.join('app', 'assets', 'files', 'blacklisted_queries.txt')
      File.read(blacklisted_queries).split("\n").freeze
    end

    def safe_parse(obj)
      JSON.parse(obj)
    rescue JSON::ParserError => _e
      obj
    end
  end
end
