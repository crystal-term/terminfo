require "../spec_helper"

describe Term::Terminfo::Sequences do
  describe "cursor control" do
    it "generates cursor movement sequences" do
      Term::Terminfo::Sequences.cursor_up.should eq("\e[1A")
      Term::Terminfo::Sequences.cursor_up(5).should eq("\e[5A")
      Term::Terminfo::Sequences.cursor_down(2).should eq("\e[2B")
      Term::Terminfo::Sequences.cursor_forward(3).should eq("\e[3C")
      Term::Terminfo::Sequences.cursor_back(4).should eq("\e[4D")
    end

    it "generates cursor positioning sequences" do
      Term::Terminfo::Sequences.cursor_position.should eq("\e[1;1H")
      Term::Terminfo::Sequences.cursor_position(10, 20).should eq("\e[10;20H")
      Term::Terminfo::Sequences.cursor_home.should eq("\e[H")
    end

    it "generates cursor visibility sequences" do
      Term::Terminfo::Sequences.cursor_hide.should eq("\e[?25l")
      Term::Terminfo::Sequences.cursor_show.should eq("\e[?25h")
    end
  end

  describe "screen control" do
    it "generates clear sequences" do
      Term::Terminfo::Sequences.clear_screen.should eq("\e[2J")
      Term::Terminfo::Sequences.clear_line.should eq("\e[2K")
      Term::Terminfo::Sequences.clear_line_right.should eq("\e[K")
    end

    it "generates scroll sequences" do
      Term::Terminfo::Sequences.scroll_up.should eq("\e[1S")
      Term::Terminfo::Sequences.scroll_down(2).should eq("\e[2T")
    end
  end

  describe "text attributes" do
    it "generates style sequences" do
      Term::Terminfo::Sequences.bold.should eq("\e[1m")
      Term::Terminfo::Sequences.dim.should eq("\e[2m")
      Term::Terminfo::Sequences.italic.should eq("\e[3m")
      Term::Terminfo::Sequences.underline.should eq("\e[4m")
      Term::Terminfo::Sequences.blink.should eq("\e[5m")
      Term::Terminfo::Sequences.reverse.should eq("\e[7m")
      Term::Terminfo::Sequences.hidden.should eq("\e[8m")
      Term::Terminfo::Sequences.strikethrough.should eq("\e[9m")
      Term::Terminfo::Sequences.reset.should eq("\e[0m")
    end
  end

  describe "colors" do
    it "generates 8-color sequences" do
      Term::Terminfo::Sequences.fg_color(1).should eq("\e[31m")  # Red
      Term::Terminfo::Sequences.bg_color(2).should eq("\e[42m")  # Green
    end

    it "generates 256-color sequences" do
      Term::Terminfo::Sequences.fg_color_256(123).should eq("\e[38;5;123m")
      Term::Terminfo::Sequences.bg_color_256(200).should eq("\e[48;5;200m")
    end

    it "generates RGB color sequences" do
      Term::Terminfo::Sequences.fg_color_rgb(255, 128, 0).should eq("\e[38;2;255;128;0m")
      Term::Terminfo::Sequences.bg_color_rgb(0, 255, 0).should eq("\e[48;2;0;255;0m")
    end
  end

  describe "terminal modes" do
    it "generates alternate screen sequences" do
      Term::Terminfo::Sequences.alternate_screen_enable.should eq("\e[?1049h")
      Term::Terminfo::Sequences.alternate_screen_disable.should eq("\e[?1049l")
    end

    it "generates mouse tracking sequences" do
      Term::Terminfo::Sequences.mouse_tracking_enable.should eq("\e[?1000h")
      Term::Terminfo::Sequences.mouse_sgr_enable.should eq("\e[?1006h")
    end
  end

  describe "utility methods" do
    it "strips ANSI sequences from text" do
      text = "\e[1mBold\e[0m text"
      Term::Terminfo::Sequences.strip_ansi(text).should eq("Bold text")
    end

    it "calculates length without ANSI sequences" do
      text = "\e[31mRed\e[0m \e[1mBold\e[0m"
      Term::Terminfo::Sequences.length_without_ansi(text).should eq(8)  # "Red Bold"
    end
  end
end