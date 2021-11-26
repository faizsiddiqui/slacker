# frozen_string_literal: true

require "json"

module Slacker
  # A group of layers
  class Stack
    ##
    # Layers in the stack
    attr_accessor :layers

    def initialize(metadata, layers, host)
      @metadata = metadata
      @layers = layers
      @host = host
    end

    def apply
      @layers.each.with_index(1) do |layer, index|
        puts "\n#{"=" * 80}\n🔹 Applying layer ##{index} on #{@host}\n#{"=" * 80}"
        layer.send(__method__)
      end
    end
  end
end
