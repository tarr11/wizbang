# Wizbang

Goal is to DRY up your wizard related code by moving wizard flow logic and state machines to routing


## Wizard DSL embedded in restful routes file
```
Rails.application.routes.draw do
  resources :cars do
    wizard :simple, :car do
      step :step_1, create: true do |car|
        car.nil?
      end
      step :step_2 do |car|
        car.make.nil? || car.model.nil?
      end
      step :finished
    end
  end
end
```

## Controller
The controller avoids most state machine code but still puts routes in the right place.  
Actions represent views and can be called indepenently
```
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
```

## Views
Views are nothing special, you just post (on create) or patch (on update) to the appropriate step
```
<h1>Step 1</h1>

<%= form_for(@car, url: step_1_cars_path) do |f| %>
  <% if @car.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@car.errors.count, "error") %> prohibited this car from being saved:</h2>

      <ul>
      <% @car.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :make %><br>
    <%= f.text_field :make %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```
