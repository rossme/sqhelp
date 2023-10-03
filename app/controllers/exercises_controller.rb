
class ExercisesController < ApplicationController

  def index
    @exercises = Exercise.all.order(:id)
  end

  def show
    @exercise = Exercise.find(params[:id])
    @next_exercise = Exercise.where('id > ?', @exercise.id).first
  end

  def create
    service = Exercises::ExerciseService.new(user_answer: exercise_params[:user_answer], exercise_id: exercise_params[:exercise_id]).call

    # handled by Stimulus controller
    if service.query_errors.any?
      render json: { message: service.query_errors.join(', ') }, status: :unprocessable_entity
    else
      render json: { message: 'Correct!' }, status: :ok
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:user_answer, :exercise_id)
  end
end
