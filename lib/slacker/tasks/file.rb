# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures file
  class File < Task
    def action_create(connection)
      if same?(connection)
        puts "Action already fulfilled!"
      else
        connection.execute("echo -e '#{content.inspect.scan(/"(.*)"/)[0][0].gsub('\"',
                                                                                 '"')}' | sudo tee #{@spec["dest"]} 1>/dev/null")
        connection.execute("sudo chmod #{@spec["mode"]} #{@spec["dest"]}")
        connection.execute("sudo chown #{@spec["owner"]}:#{@spec["group"]} #{@spec["dest"]}")
      end
    end

    def action_delete(connection)
      if exists?(connection)
        connection.execute("sudo rm -f #{@spec["dest"]}")
      else
        puts "Action already fulfilled!"
      end
    end

    private

    def exists?(connection)
      command = "(sudo ls #{@spec["dest"]} >> /dev/null 2>&1 && echo yes) || echo no"
      connection.execute(command, log_output: false).include?("yes")
    end

    def same?(connection)
      return false unless exists?(connection) && stat(connection).eql?([@spec["mode"], @spec["owner"], @spec["group"]])

      # check content
      current_state = current(connection)
      new_state = content
      current_state.eql?(new_state)
    end

    def current(connection)
      connection.execute("sudo cat #{@spec["dest"]}", log_output: false).chomp.gsub(/\r\n?/, "\n")
    end

    def content
      ::File.read("#{@stack_path}/#{@spec["src"]}").chomp
    end

    def stat(connection)
      connection.execute("sudo stat -c '%a,%U,%G' #{@spec["dest"]}", log_output: false).chomp.split(",")
    end
  end
end
