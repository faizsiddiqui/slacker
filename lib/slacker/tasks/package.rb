# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures package
  class Package < Task
    def action_install
      return false if installed?

      @connection.execute("sudo apt -y install #{@spec["name"]}")
    end

    def action_remove
      return false unless installed?

      @connection.execute("sudo apt -y remove #{@spec["name"]}")
    end

    def to_s
      "🔸 TID# #{@id}: #{@type}[#{@spec["name"]} (#{@spec["action"]})]"
    end

    private

    def installed?
      @connection.execute("sudo apt list -i #{@spec["name"]} 2> /dev/null").include?("installed")
    end
  end
end
