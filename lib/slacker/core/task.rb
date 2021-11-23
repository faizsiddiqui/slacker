# frozen_string_literal: true

module Slacker
  #  A discrete unit of work
  class Task
    ##
    # Task ID
    attr_accessor :id

    def initialize(stack_path, task)
      @stack_path = stack_path
      @id = task["id"]
      @type = task["type"]
      @spec = task["spec"]
      @post = task.fetch("post", [])
    end

    def apply(connection)
      raise "#{@type}[#{@spec["action"]}] not supported!" unless supported?

      # rubocop:disable Style/UnlessElse
      unless send("action_#{@spec["action"]}", connection)
        puts "[SKIPPED] #{self} \u2713\n"
      else
        # Perform post task
        @post.send(__method__, connection)
      end
      # rubocop:enable Style/UnlessElse
    end

    def to_s
      "\tTID# #{@id}: #{@type}[#{@spec}]"
    end

    def supported?
      type_class = Slacker.const_get(@type.capitalize)
      type_class.is_a?(Class) && type_class.method_defined?("action_#{@spec["action"]}".to_sym)
    rescue NameError
      false
    end
  end
end
