# frozen_string_literal: true

RSpec.describe Slacker::Task do
  let(:stack_path) { "./slack-lamp-stack" }
  let(:task_config) { { "id" => 1, "type" => "package", "spec" => { "action" => "install" }, "post" => [] } }
  let(:host_connection) do
    Slacker::Host.new({
                        "address" => "1.2.3.4",
                        "user" => "root",
                        "password" => "xxxxxxxxx"
                      }).connection
  end
  let(:subject) { Slacker::Task.new(stack_path, task_config, host_connection) }

  it "validate task object" do
    expect(subject).not_to be_nil
  end

  describe "#supported?" do
    context "when task type is package" do
      it "task is supported" do
        expect(subject.supported?).to be_truthy
      end
    end

    context "when task type is bash" do
      it "task is not supported" do
        task = Slacker::Task.new(stack_path, { "type" => "bash" }, host_connection)
        expect(task.supported?).to be_falsey
      end
    end
  end
end
