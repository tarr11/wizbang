# Wizbang

## Install
Add this to your gemfile:

`gem 'wizbang', github: 'https://github.com/tarr11/wizbang'`

## Problem:
Your state machine code for a wizard is spread out across your routes file, controller and models

## Solution:
DRY up your rails wizard code with wizbang by moving your state machine into a DSL that is integrated with `ActionDispatch::Routing`

## Benefits:
 
* Conventional controller actions, so auth gems like cancan will work
* Routes and generated urls are simple and easy to read
* Supports complex state machines with a powerful DSL embedded in your routes and avoids creating separate state management that gets stale
* Supports rails idioms  
* State machine is accessible in a modular way so you can send emails with the correct URL, run reports on who is at what step, etc

## Reasoning
Wizards are not inherently RESTful.  They often cross multiple resources and are bolted on to RESTful controllers.  If we embrace what they are, we can make them flexible enough to handle complex cases (like user onboarding) but still work effectively for simple cases (like a multi-step form for a single resource) 

For eexample. during user onboarding, you may end up creating several different resources in the context of a single wizard.  RESTful based routes simply can't handle this and most wizard code ends up looking very different than RESTful code.


## Wizard DSL embedded in restful routes file
```
Rails.application.routes.draw do
  wizard controller: :simple, resources; [:car] do
    step :step_1, create: true do |car|
      car.nil?
    end
    step :step_2 do |car|
      car.make.nil? || car.model.nil?
    end
    step :finished
  end
end
```

## Controller
The controller avoids most state machine code but still puts routes in the right place.  
Actions represent views and can be called indepenently
```
class SimpleController < ApplicationController
  acts_as_wizbang wizard: :simple

  before_action :set_car, only: [:show, :edit, :update, :destroy, :step_2, :step_2_update, :step_3]

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

<%= form_for(@car, url: simple_step_1_path) do |f| %>
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

## Access wizard status from anywhere 
(like emails or call to action on other views)
```
c = Car.find(3)
next_action = Wizbang.wizards[:simple].next_action(c)
FinishWizardMailer.mail(c, next_action) if next_action
```
