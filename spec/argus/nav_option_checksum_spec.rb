require 'spec_helper'

module Argus

  describe NavOptionChecksum do
    Given(:raw_data) { [NavTag::CHECKSUM, 8, 0x12345678].pack("vvV") }
    Given(:csum) { NavOptionChecksum.new(raw_data) }

    describe ".tag" do
      Then { NavOptionChecksum.tag == NavTag::CHECKSUM }
    end

    describe "data fields" do
      Then { csum.tag == NavOptionChecksum.tag }
      Then { csum.size == raw_data.size }
      Then { csum.checksum == 0x12345678 }
    end
  end

end
