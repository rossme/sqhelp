
class ExercisesController < ApplicationController

  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find_by(id: params[:id])
  end

  def create
    service = Exercises::ExerciseService.new(user_answer: exercise_params[:user_answer], exercise_id: exercise_params[:exercise_id]).call
    if service.query_errors.any?
      flash[:alert] = service.query_errors.join(', ')
    else
      flash[:notice] = 'Correct!'
    end
    redirect_to exercise_path(exercise_params[:exercise_id])
  end

  private

  def exercise_params
    params.require(:exercise).permit(:user_answer, :exercise_id)
  end
end
