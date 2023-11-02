# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'factory_bot'


RSpec.describe Customer, type: :model do
  describe 'create' do
    let(:customer) { build(:customer) }
    let(:order) { Order.new }

    it 'creates a new customer' do
      expect(customer).to be_valid
    end

    it 'creates a new customer with an order' do
      customer.orders << order
      expect(customer.orders.first).to eq(order)
    end
  end
end
