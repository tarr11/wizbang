class CarsController < ApplicationController
  acts_as_wizbang wizard_name: :simple

  before_action :set_car, only: [:show, :edit, :update, :destroy, :step_2, :step_2_update, :step_3]

  # GET /cars
  def index
    @cars = Car.all
  end

  def step_1
    @wiz = wizbang_wizard
    @car = Car.new
  end

  def step_1_create
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


  end


  # GET /cars/1
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars
  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to @car, notice: 'Car was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /cars/1
  def update
    if @car.update(car_params)
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cars/1
  def destroy
    @car.destroy
    redirect_to cars_url, notice: 'Car was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def car_params
      params.require(:car).permit(:make, :model, :color, :price, :year, :condition)
    end
end
