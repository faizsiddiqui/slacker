# frozen_string_literal: true

require_relative "utilities/ssh"

module Slacker
  # A remote machine
  class Host
    def initialize(host)
      @address = host["address"]
      @user = host["user"]
      @password = host["password"]
    end

    def to_s
      "#{@user}@#{@address}"
    end

    ##
    # Hide sensitive variables from output
    def inspect
      super.gsub(/:password=>[^ ]+/, ":password=>HIDDEN_VALUE,")
    end

    def connection
      Slacker::SSH.new(@address, user: @user, password: @password)
    end
  end
end
