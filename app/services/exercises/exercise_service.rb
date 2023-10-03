# frozen_string_literal: true

module Exercises
  class ExerciseService < BaseService

    def call
      query_results_match?
      self
    rescue ActiveRecord::ReadOnlyError, ActiveRecord::RecordNotFound, StandardError => e
      # work around currently unable to use `errors << 'some error'` as the connection is readonly
      query_errors << e.message
      self
    end

    private

    def query_results_match?
      return true if execute_user_query == execute_exercise_query

      raise StandardError, I18n.t('exercises.errors.query_error', user_answer: user_answer)
    end

    def execute_user_query
      safe_execute_query(user_answer)
    end

    def execute_exercise_query
      safe_execute_query(exercise.query)
    end
  end
end
