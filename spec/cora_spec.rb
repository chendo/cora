require 'spec_helper'

describe Cora do
  context "integration test" do

    class TestPlugin < Cora::Plugin

      listen_for /test/ do
        say "test!"
      end

      listen_for /foo/ do
        say "foo"
        set_state :waiting_for_bar
      end

      listen_for /bar/, within_state: :waiting_for_bar do
        say "bar get"
      end

    end

    let(:plugin) do
      TestPlugin.new.tap { |plugin| plugin.manager = subject }
    end

    before do
      subject.plugins << plugin
    end

    context "single state" do
      it "responds to a simple test hook" do

        subject.should_receive(:respond).with("test!")
        subject.process("this is a test")

      end
    end

    context "multiple state" do
      it "doesn't respond to listeners that don't have the required state" do
        subject.should_receive(:no_matches)

        subject.process("bar")
      end

      it "responds when in the correct state" do
        subject.process("foo")

        subject.should_receive(:respond).with("bar get")
        subject.process("bar")
      end
    end

    context "multiple plugins" do
      class TestPlugin2 < Cora::Plugin

        listen_for /test/ do
          say "test2"
        end

        listen_for /bar/ do
          say "bad bar"
        end

      end

      before do
        subject.plugins << TestPlugin2.new.tap { |plugin| plugin.manager = subject}
      end

      it "processes the plugins in order" do
        subject.should_receive(:respond).with("test!")
        subject.process("test")

        subject.plugins.reverse!
        subject.should_receive(:respond).with("test2")
        subject.process("test")
      end

      it "when state is set, cora should ignore other plugins" do
        subject.plugins.reverse! # So TestPlugin2's bar is checked first
        subject.process("foo")
        subject.should_receive(:respond).with("bar get")
        subject.process("bar")
      end
    end

  end
end
