# frozen_string_literal: true

require 'faker'

5.times { List.create(title: Faker::Hipster.sentence) }
