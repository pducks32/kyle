require 'spec_helper'

describe Kyle do
  it 'has a version number' do
    expect(Kyle::VERSION).not_to be nil
  end

  context "when run from command line" do
    it "receives argv" do
      expect(`exe/kyle which grep`).to include "bin/grep"
    end
  end
end
