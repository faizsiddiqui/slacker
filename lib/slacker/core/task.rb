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
      @post = task["post"]
    end

    def apply(connection)
      raise "#{@type}[#{@spec["action"]}] not supported!" unless supported?

      # rubocop:disable Style/UnlessElse
      unless send("action_#{@spec["action"]}", connection)
        puts "[SKIPPED] #{self} ✅\n"
      else
        puts "[DONE] #{self} ✅\n"

        # Perform post task
        unless @post.nil?
          puts "\n\t[POST] #{"-" * 45}"
          @post.send(__method__, connection)
        end
      end
      # rubocop:enable Style/UnlessElse
    end

    def to_s
      "\t🔸 TID# #{@id}: #{@type}[#{@spec}]"
    end

    def supported?
      type_class = Slacker.const_get(@type.capitalize)
      type_class.is_a?(Class) && type_class.method_defined?("action_#{@spec["action"]}".to_sym)
    rescue NameError
      false
    end
  end
end
