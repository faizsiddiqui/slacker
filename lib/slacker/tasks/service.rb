# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures service
  class Service < Task
    def action_start
      return false if running?

      @connection.execute("sudo systemctl start #{@spec["name"]}")
    end

    def action_restart
      @connection.execute("sudo systemctl restart #{@spec["name"]}")
    end

    def to_s
      "🔸 TID# #{@id}: #{@type}[#{@spec["name"]} (#{@spec["action"]})]"
    end

    private

    def running?
      @connection.execute("sudo systemctl status #{@spec["name"]}").include?("running")
    end
  end
end
