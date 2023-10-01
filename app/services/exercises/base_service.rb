# frozen_string_literal: true

module Exercises
  class BaseService
    include ActiveModel::Validations
    validates :user_answer, :exercise_id, presence: true

    def initialize(user_answer, exercise_id)
      @user_answer = user_answer
      @exercise_id = exercise_id
    end

    attr_reader :user_answer, :exercise_id

    def safe_execute_query(query)
      # Read only connection to prevent malicious queries
      ActiveRecord::Base.connected_to(role: :reading) do
        ActiveRecord::Base.connection.execute(query).to_a
      end
    rescue ActiveRecord::ReadOnlyError, ActiveRecord::RecordNotFound => e
      raise I18n.t('errors.message', class: e.class)
    end

    private

    def exercise
      @exercise ||= Exercise.find_by(id: exercise_id)
    end
  end
end
