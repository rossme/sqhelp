# frozen_string_literal: true

module Exercises
  class ExerciseService < BaseService

    def call
      query_results_match?
    end

    private

    def query_results_match?
      user_query == exercise_query
    end

    def user_query
      raise ActiveRecord::RecordNotFound unless user_answer

      safe_execute_query(user_answer)
    end

    def exercise_query
      raise ActiveRecord::RecordNotFound unless exercise

      safe_execute_query(exercise.query)
    end
  end
end
