# frozen_string_literal: true

require "json"

module Slacker
  # A group of layers
  class Stack
    ##
    # Layers in the stack
    attr_accessor :layers

    def initialize(metadata, layers)
      @metadata = metadata
      @layers = layers
    end

    def apply(host)
      @layers.each.with_index(1) do |layer, index|
        puts "\n#{"=" * 80}\nApplying layer ##{index} on #{host}\n#{"=" * 80}"
        layer.send(__method__, host.connection)
      end
    end
  end
end
