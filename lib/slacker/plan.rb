# frozen_string_literal: true

require_relative "core/stack"
require_relative "core/layer"

require_relative "tasks/file"
require_relative "tasks/package"
require_relative "tasks/service"

module Slacker
  # A execution plan on host
  class Plan
    def initialize(stack_path, host)
      @stack_path = stack_path
      @host = Slacker::Host.new(host)
      @stack = Slacker::Stack.new(metadata(stack_path), layers(stack_path), @host)
    end

    def apply
      @stack.send(__method__)
    end

    private

    def metadata(stack_path)
      JSON.parse(::File.read("#{stack_path}/stack.json"))
    rescue Errno::ENOENT, JSON::ParserError => e
      abort("Specify a correct stack.json file, error => #{e.message}")
    end

    def layers(stack_path)
      Dir.glob("#{stack_path}/layers/*.json").sort.map do |layer|
        tasks = JSON.parse(::File.read(layer)).map do |task|
          post_tasks = task.fetch("post", []).map do |post_task|
            Slacker.const_get(post_task["type"].capitalize).new(@stack_path, post_task, @host.connection)
          end
          task["post"] = Slacker::Layer.new(post_tasks) if post_tasks.count.positive?

          Slacker.const_get(task["type"].capitalize).new(@stack_path, task, @host.connection)
        end
        Slacker::Layer.new(tasks)
      end
    rescue Errno::ENOENT, JSON::ParserError => e
      abort("Specify correct layer files, error => #{e.message}")
    end
  end
end
