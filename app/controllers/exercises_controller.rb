
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
      render json: { message: service.query_errors.join(', '), http: 206 }, status: :partial_content
    else
      render json: { message: 'CORRECT!', http: 200 }, status: :ok
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:user_answer, :exercise_id)
  end
end
