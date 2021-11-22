# frozen_string_literal: true

RSpec.describe Slacker::Layer do
  let(:stack_path) { "./slack-lamp-stack" }
  let(:task) { { "id" => 1, "type" => "package", "spec" => {}, "post" => [] } }

  it "validate layer object" do
    tasks = [Slacker::Task.new(stack_path, task), Slacker::Task.new(stack_path, task)]
    layer = Slacker::Layer.new(tasks)

    expect(layer).not_to be_nil
    expect(layer.tasks).to all(be_an(Slacker::Task))
    expect(layer.respond_to?(:apply)).to be true
  end
end
