# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures service
  class Service < Task
    def action_start(connection)
      if running?(connection)
        puts "Action already fulfilled!"
      else
        connection.execute("sudo systemctl start #{@spec["name"]}")
      end
    end

    def action_restart(connection)
      connection.execute("sudo systemctl restart #{@spec["name"]}")
    end

    private

    def running?(connection)
      connection.execute("sudo systemctl status #{@spec["name"]}").include?("running")
    end
  end
end
