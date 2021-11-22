# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures package
  class Package < Task
    def action_install(connection)
      if installed?(connection)
        puts "Action already fulfilled!"
      else
        connection.execute("sudo apt -y install #{@spec["name"]}")
      end
    end

    def action_remove(connection)
      if installed?(connection)
        connection.execute("sudo apt -y remove #{@spec["name"]}")
      else
        puts "Action already fulfilled!"
      end
    end

    private

    def installed?(connection)
      connection.execute("sudo apt list -i #{@spec["name"]} 2> /dev/null").include?("installed")
    end
  end
end
