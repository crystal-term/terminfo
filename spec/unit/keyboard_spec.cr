require "../spec_helper"

describe Term::Terminfo::Keyboard do
  describe ".parse_sequence" do
    it "parses control characters" do
      Term::Terminfo::Keyboard.parse_sequence("\x01").should eq(Term::Terminfo::Keyboard::Key::CtrlA)
      Term::Terminfo::Keyboard.parse_sequence("\t").should eq(Term::Terminfo::Keyboard::Key::Tab)
      Term::Terminfo::Keyboard.parse_sequence("\r").should eq(Term::Terminfo::Keyboard::Key::Enter)
      Term::Terminfo::Keyboard.parse_sequence("\e").should eq(Term::Terminfo::Keyboard::Key::Escape)
      Term::Terminfo::Keyboard.parse_sequence("\x7f").should eq(Term::Terminfo::Keyboard::Key::Delete)
    end

    it "parses arrow key sequences" do
      Term::Terminfo::Keyboard.parse_sequence("\e[A").should eq(Term::Terminfo::Keyboard::Key::Up)
      Term::Terminfo::Keyboard.parse_sequence("\e[B").should eq(Term::Terminfo::Keyboard::Key::Down)
      Term::Terminfo::Keyboard.parse_sequence("\e[C").should eq(Term::Terminfo::Keyboard::Key::Right)
      Term::Terminfo::Keyboard.parse_sequence("\e[D").should eq(Term::Terminfo::Keyboard::Key::Left)
    end

    it "parses function key sequences" do
      Term::Terminfo::Keyboard.parse_sequence("\eOP").should eq(Term::Terminfo::Keyboard::Key::F1)
      Term::Terminfo::Keyboard.parse_sequence("\eOQ").should eq(Term::Terminfo::Keyboard::Key::F2)
      Term::Terminfo::Keyboard.parse_sequence("\e[15~").should eq(Term::Terminfo::Keyboard::Key::F5)
    end

    it "parses special key sequences" do
      Term::Terminfo::Keyboard.parse_sequence("\e[H").should eq(Term::Terminfo::Keyboard::Key::Home)
      Term::Terminfo::Keyboard.parse_sequence("\e[F").should eq(Term::Terminfo::Keyboard::Key::End)
      Term::Terminfo::Keyboard.parse_sequence("\e[5~").should eq(Term::Terminfo::Keyboard::Key::PageUp)
      Term::Terminfo::Keyboard.parse_sequence("\e[6~").should eq(Term::Terminfo::Keyboard::Key::PageDown)
    end

    it "returns nil for regular characters" do
      Term::Terminfo::Keyboard.parse_sequence("a").should be_nil
      Term::Terminfo::Keyboard.parse_sequence("Z").should be_nil
      Term::Terminfo::Keyboard.parse_sequence("5").should be_nil
    end
  end

  describe ".key_name" do
    it "returns human-readable key names" do
      Term::Terminfo::Keyboard.key_name(Term::Terminfo::Keyboard::Key::CtrlC).should eq("Ctrl+C")
      Term::Terminfo::Keyboard.key_name(Term::Terminfo::Keyboard::Key::Tab).should eq("Tab")
      Term::Terminfo::Keyboard.key_name(Term::Terminfo::Keyboard::Key::F1).should eq("F1")
      Term::Terminfo::Keyboard.key_name(Term::Terminfo::Keyboard::Key::Up).should eq("Up")
    end
  end

  describe "key type checks" do
    it "checks if key is control character" do
      Term::Terminfo::Keyboard.control?(Term::Terminfo::Keyboard::Key::CtrlA).should be_true
      Term::Terminfo::Keyboard.control?(Term::Terminfo::Keyboard::Key::Enter).should be_true
      Term::Terminfo::Keyboard.control?(Term::Terminfo::Keyboard::Key::F1).should be_false
    end

    it "checks if key is function key" do
      Term::Terminfo::Keyboard.function_key?(Term::Terminfo::Keyboard::Key::F1).should be_true
      Term::Terminfo::Keyboard.function_key?(Term::Terminfo::Keyboard::Key::F12).should be_true
      Term::Terminfo::Keyboard.function_key?(Term::Terminfo::Keyboard::Key::Enter).should be_false
    end

    it "checks if key is arrow key" do
      Term::Terminfo::Keyboard.arrow_key?(Term::Terminfo::Keyboard::Key::Up).should be_true
      Term::Terminfo::Keyboard.arrow_key?(Term::Terminfo::Keyboard::Key::Left).should be_true
      Term::Terminfo::Keyboard.arrow_key?(Term::Terminfo::Keyboard::Key::Home).should be_false
    end

    it "checks if key is navigation key" do
      Term::Terminfo::Keyboard.navigation_key?(Term::Terminfo::Keyboard::Key::Home).should be_true
      Term::Terminfo::Keyboard.navigation_key?(Term::Terminfo::Keyboard::Key::PageUp).should be_true
      Term::Terminfo::Keyboard.navigation_key?(Term::Terminfo::Keyboard::Key::Up).should be_true
      Term::Terminfo::Keyboard.navigation_key?(Term::Terminfo::Keyboard::Key::Enter).should be_false
    end
  end
end