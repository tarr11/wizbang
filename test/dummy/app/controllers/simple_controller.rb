class SimpleController < ApplicationController

  include Wizbang::ActsAsWizbang
  acts_as_wizbang wizard: :simple
  before_action :set_car
  before_action :set_store

  def step_1
    @wiz = wizbang_wizard
    @car = Car.new
  end

  def step_1_update
    @car = Car.create(car_params)
    redirect_to_next_action
  end

  def step_2

  end

  def step_2_update
    @car.update(car_params)
    redirect_to_next_action
  end

  def finished
    redirect_to @car


  end
  private
    # Only allow a trusted parameter "white list" through.
    def car_params
      params.require(:car).permit(:make, :model, :color, :price, :year, :condition)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:store_id]) if params[:store_id]
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:car_id]) if params[:car_id]
    end
end

