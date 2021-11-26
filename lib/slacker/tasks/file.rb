# frozen_string_literal: true

require_relative "../core/task"

module Slacker
  # Configures file
  class File < Task
    def action_create
      return false if same?

      @connection.execute("echo -e '#{content.inspect.scan(/"(.*)"/)[0][0].gsub('\"',
                                                                                '"')}' | sudo tee #{@spec["dest"]} 1>/dev/null")
      @connection.execute("sudo chmod #{@spec["mode"]} #{@spec["dest"]}")
      @connection.execute("sudo chown #{@spec["owner"]}:#{@spec["group"]} #{@spec["dest"]}")
    end

    def action_delete
      return false unless exists?

      @connection.execute("sudo rm -f #{@spec["dest"]}")
    end

    def to_s
      "🔸 TID# #{@id}: #{@type}[#{@spec["src"]} -> #{@spec["dest"]} (#{@spec["action"]})]"
    end

    private

    def exists?
      command = "(sudo ls #{@spec["dest"]} >> /dev/null 2>&1 && echo yes) || echo no"
      @connection.execute(command, log_output: false).include?("yes")
    end

    def same?
      return false unless exists? && stat.eql?([@spec["mode"], @spec["owner"], @spec["group"]])

      # check content
      current_state = current
      new_state = content
      current_state.eql?(new_state)
    end

    def current
      @connection.execute("sudo cat #{@spec["dest"]}", log_output: false).chomp.gsub(/\r\n?/, "\n")
    end

    def content
      ::File.read("#{@stack_path}/#{@spec["src"]}").chomp
    end

    def stat
      @connection.execute("sudo stat -c '%a,%U,%G' #{@spec["dest"]}", log_output: false).chomp.split(",")
    end
  end
end
