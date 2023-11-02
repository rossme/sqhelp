# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe ExercisesController do

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful # expects an HTTP Status code of 200
    end
  end

  describe 'GET #show' do
    let(:exercise) { create(:exercise) }

    it 'returns a success response' do
      get :show, params: { id: exercise.to_param } # to_param converts the id to a string
      expect(response).to be_successful # expects an HTTP Status code of 200
    end
  end

  describe 'GET #create' do
    let(:exercise) { build(:exercise) }

    it 'returns a success response' do
      get :create, params: { exercise: { id: exercise.to_param, user_answer: 'SELECT * FROM customers' } }
      expect(response).to be_successful # expects an HTTP Status code of 200
    end
  end

  describe 'Uses strong parameters' do
    it 'raises an error without all required parameters' do
      expect do
        post :create, params: { exercise_id: '1', user_answer: 'SELECT * FROM customers' }
      end.to raise_error(ActionController::ParameterMissing)
    end
  end
end
