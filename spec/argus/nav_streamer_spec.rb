require 'spec_helper'

module Argus
  describe NavStreamer do
    Given(:socket) { flexmock("Socket", send: nil).should_ignore_missing }
    Given(:streamer) { NavStreamer.new(socket) }

    context "starting the stream" do
      When { streamer.start }
      Then { socket.should have_received(:bind).with(String, Object) }
      Then { socket.should have_received(:send) }
    end

    context "when receiving good data" do
      Given(:bytes) { Bytes.make_nav_data(Bytes.make_header(0x1234, 0, 0)) }
      Given { socket.should_receive(:recvfrom => bytes) }
      When(:nav_data) { streamer.receive_data }
      Then { nav_data.state_mask == 0x1234}
    end

    context "when receiving bad data" do
      Given(:bytes) { [0x89, 0x77, 0x66, 0x55, 0x34, 0x12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].pack("C*") }
      Given { socket.should_receive(:recvfrom => bytes) }
      When(:nav_data) { streamer.receive_data }
      Then { nav_data.nil? }
    end
  end
end
