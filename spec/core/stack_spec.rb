# frozen_string_literal: true

RSpec.describe Slacker::Stack do
  let(:metadata) do
    {
      "name" => "slack-app",
      "description" => "Slack Ops Challenge Stack",
      "version" => "1.0.0",
      "author" => "faize.sid@gmail.com"
    }
  end

  let(:host) do
    Slacker::Host.new({
                        "address" => "1.2.3.4",
                        "user" => "root",
                        "password" => "xxxxxxxxx"
                      })
  end

  it "validate stack object" do
    layers = [Slacker::Layer.new([]), Slacker::Layer.new([])]
    stack = Slacker::Stack.new(metadata, layers, host)

    expect(stack).not_to be_nil
    expect(stack.layers).to all(be_an(Slacker::Layer))
    expect(stack.respond_to?(:apply)).to be true
  end
end
