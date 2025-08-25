require "../spec_helper"

describe Term::Terminfo::Size do
  describe ".get" do
    it "returns a named tuple with width and height" do
      size = Term::Terminfo::Size.get
      size.should be_a(NamedTuple(width: Int32, height: Int32))
    end

    it "returns positive values" do
      size = Term::Terminfo::Size.get
      size[:width].should be > 0
      size[:height].should be > 0
    end

    it "returns default values when no detection method works" do
      # This is hard to test without mocking, but we can at least
      # verify the method doesn't crash
      size = Term::Terminfo::Size.get(IO::Memory.new)
      size[:width].should eq(80)
      size[:height].should eq(24)
    end
  end

  describe "fallback detection methods" do
    it "can read from environment variables" do
      # Test will only pass if COLUMNS and LINES are set
      if ENV["COLUMNS"]? && ENV["LINES"]?
        size = Term::Terminfo::Size.get
        size[:width].should eq(ENV["COLUMNS"].to_i)
        size[:height].should eq(ENV["LINES"].to_i)
      end
    end
  end
end
