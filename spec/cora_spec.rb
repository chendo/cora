require 'spec_helper'

describe Cora do
  context "integration test" do

    class TestPlugin < Cora::Plugin

      listen_for /test/ do
        say "test!"
      end

    end

    before do
      subject.plugins << TestPlugin
    end

    it "responds to a simple test hook" do
      subject.process("this is a test")

      subject.should_receive(:respond).with("test!")
    end

  end
end
