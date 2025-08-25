require "./spec_helper"

describe Term::Terminfo do
  describe ".size" do
    it "returns terminal size as named tuple" do
      size = Term::Terminfo.size
      size.should be_a(NamedTuple(width: Int32, height: Int32))
      size[:width].should be > 0
      size[:height].should be > 0
    end
  end

  describe ".width" do
    it "returns terminal width" do
      width = Term::Terminfo.width
      width.should be_a(Int32)
      width.should be > 0
    end
  end

  describe ".height" do
    it "returns terminal height" do
      height = Term::Terminfo.height
      height.should be_a(Int32)
      height.should be > 0
    end
  end

  describe ".tty?" do
    it "checks if output is a terminal" do
      # This will be true when running tests in a terminal
      # and false in CI environments without TTY
      Term::Terminfo.tty?.should be_a(Bool)
    end

    it "accepts IO argument" do
      Term::Terminfo.tty?(STDERR).should be_a(Bool)
    end
  end

  describe ".type" do
    it "returns terminal type from environment" do
      type = Term::Terminfo.type
      type.should be_a(String)
      type.should_not be_empty
    end
  end

  describe ".attributes" do
    it "returns terminal attributes" do
      attrs = Term::Terminfo.attributes
      attrs.should be_a(Term::Terminfo::Attributes::Info)
      attrs.color_support.should be_a(Bool)
      attrs.unicode_support.should be_a(Bool)
      attrs.mouse_support.should be_a(Bool)
      attrs.term_program.should be_a(String?)
    end
  end

  describe ".color?" do
    it "returns color support status" do
      Term::Terminfo.color?.should be_a(Bool)
    end
  end
end
