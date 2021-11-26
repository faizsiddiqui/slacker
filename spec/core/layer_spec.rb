# frozen_string_literal: true

RSpec.describe Slacker::Layer do
  let(:stack_path) { "./slack-lamp-stack" }
  let(:task) { { "id" => 1, "type" => "package", "spec" => {}, "post" => [] } }
  let(:host_connection) do
    Slacker::Host.new({
                        "address" => "1.2.3.4",
                        "user" => "root",
                        "password" => "xxxxxxxxx"
                      }).connection
  end

  it "validate layer object" do
    tasks = [Slacker::Task.new(stack_path, task, host_connection), Slacker::Task.new(stack_path, task, host_connection)]
    layer = Slacker::Layer.new(tasks)

    expect(layer).not_to be_nil
    expect(layer.tasks).to all(be_an(Slacker::Task))
    expect(layer.respond_to?(:apply)).to be true
  end
end
