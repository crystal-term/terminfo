require "../spec_helper"

describe Term::Terminfo::Capabilities do
  describe ".get" do
    it "returns both boolean and numeric capabilities" do
      caps = Term::Terminfo::Capabilities.get
      caps.should be_a(NamedTuple(boolean: Term::Terminfo::Capabilities::BooleanCaps, numeric: Term::Terminfo::Capabilities::NumericCaps))
    end
  end

  describe ".boolean_capabilities" do
    it "returns boolean capabilities" do
      caps = Term::Terminfo::Capabilities.boolean_capabilities
      caps.should be_a(Term::Terminfo::Capabilities::BooleanCaps)
      caps.auto_right_margin.should be_a(Bool)
      caps.back_color_erase.should be_a(Bool)
      caps.move_standout_mode.should be_a(Bool)
    end
  end

  describe ".numeric_capabilities" do
    it "returns numeric capabilities" do
      caps = Term::Terminfo::Capabilities.numeric_capabilities
      caps.should be_a(Term::Terminfo::Capabilities::NumericCaps)
      caps.columns.should be > 0
      caps.lines.should be > 0
      caps.colors.should be >= 0
      caps.tab_size.should eq(8)
    end
  end

  describe ".supports?" do
    it "checks for color support" do
      Term::Terminfo::Capabilities.supports?(:color).should be_a(Bool)
      Term::Terminfo::Capabilities.supports?(:colors).should be_a(Bool)
    end

    it "checks for unicode support" do
      Term::Terminfo::Capabilities.supports?(:unicode).should be_a(Bool)
    end

    it "checks for style support" do
      Term::Terminfo::Capabilities.supports?(:bold).should be_a(Bool)
      Term::Terminfo::Capabilities.supports?(:underline).should be_a(Bool)
      Term::Terminfo::Capabilities.supports?(:italic).should be_a(Bool)
    end

    it "checks for advanced color support" do
      Term::Terminfo::Capabilities.supports?(:truecolor).should be_a(Bool)
      Term::Terminfo::Capabilities.supports?(:"256color").should be_a(Bool)
    end

    it "returns false for unknown capabilities" do
      Term::Terminfo::Capabilities.supports?(:unknown_capability).should be_false
    end
  end
end
