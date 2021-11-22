# frozen_string_literal: true

module Slacker
  # A group of tasks
  class Layer
    def initialize(tasks)
      @tasks = tasks
    end

    def apply(connection)
      @tasks.each do |task|
        puts "\n#{task}\n"
        task.send(__method__, connection)
      end
    end
  end
end
