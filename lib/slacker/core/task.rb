# frozen_string_literal: true

module Slacker
  #  A discrete unit of work
  class Task
    def initialize(stack_path, task)
      @stack_path = stack_path
      @id = task["id"]
      @type = task["type"]
      @spec = task["spec"]
      @post = task["post"]
    end

    def apply(connection)
      raise "#{@type}[#{@spec["action"]}] not supported!" unless supported?

      send("action_#{@spec["action"]}", connection)
    end

    def to_s
      "TID# #{@id}: #{@type}[#{@spec}]"
    end

    def supported?
      type_class = Slacker.const_get(@type.capitalize)
      type_class.is_a?(Class) && type_class.method_defined?("action_#{@spec["action"]}".to_sym)
    rescue NameError
      false
    end
  end
end
