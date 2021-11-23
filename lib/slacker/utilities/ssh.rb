# frozen_string_literal: true

require "net/ssh"

module Slacker
  # SSH to any node
  class SSH
    ##
    # Node Name/IP on which to execute a command
    attr_reader :node

    # @param node [String] Node name or IP Address
    # @param options [Hash] default: { user: 'root', password: 'password', verify_host_key: :never }
    # ===== Example
    #    ssh = Slacker::SSH.new('<ip-address>', user: 'root', password: '<password>')
    def initialize(node, options = {})
      @node = node
      @options = { user: "root", password: "password", verify_host_key: :never }.merge(options)
    end

    # Executes command on a node
    #
    # @param command [String] Command to execute
    # @param options [Hash] default: { log_output: true, timeout: 300, retries: 3 }
    # @return [String] Output of the executed command
    # ===== Example
    #    ssh = Slacker::SSH.new('<ip-address>', user: 'root', password: '<password>')
    #    ssh.execute('hostname')
    #    ssh.execute('uptime')
    def execute(command, options = {})
      options = { log_output: true, timeout: 300, retries: 3 }.merge(options)
      1.upto(options[:retries]) do |retry_count|
        output = ""
        st = 140
        Net::SSH.start(node, @options[:user], {
                         password: @options[:password],
                         verify_host_key: @options[:verify_host_key],
                         timeout: options[:timeout]
                       }) do |session|
          ch = session.open_channel do |channel|
            channel.on_request "exit-status" do |_ch, data|
              st = data.read_long
            end
            channel.request_pty
            channel.exec(command) do
              channel.on_data do |_, data|
                puts(data) if options[:log_output]
                output += data
              end
            end
          end
          ch.wait
        end

        raise "Command #{command.inspect} on #{node} finished with exit code #{st}." unless st.zero?

        return output
      rescue StandardError => e
        puts("Exception occured connecting to #{node} : #{e.message}")
        raise("#{self.class}.#{__method__} : #{e}") unless retry_count < options[:retries]

        puts("Retrying connection to #{node} after 60 seconds... [##{retry_count}]")
        sleep 60
      end
    end

    ##
    # Hide sensitive variables from output
    def inspect
      super.gsub(/:password=>[^ ]+/, ":password=>HIDDEN_VALUE,")
    end
  end
end
