module Term
  module Terminfo
    # ANSI escape sequences and control codes
    module Sequences
      extend self

      # Control characters
      BEL = "\a"  # Bell
      BS  = "\b"  # Backspace
      HT  = "\t"  # Horizontal Tab
      LF  = "\n"  # Line Feed
      VT  = "\v"  # Vertical Tab
      FF  = "\f"  # Form Feed
      CR  = "\r"  # Carriage Return
      ESC = "\e"  # Escape
      CSI = "\e[" # Control Sequence Introducer

      # Cursor control sequences
      def cursor_up(n = 1) : String
        "#{CSI}#{n}A"
      end

      def cursor_down(n = 1) : String
        "#{CSI}#{n}B"
      end

      def cursor_forward(n = 1) : String
        "#{CSI}#{n}C"
      end

      def cursor_back(n = 1) : String
        "#{CSI}#{n}D"
      end

      def cursor_next_line(n = 1) : String
        "#{CSI}#{n}E"
      end

      def cursor_prev_line(n = 1) : String
        "#{CSI}#{n}F"
      end

      def cursor_horizontal_absolute(n = 1) : String
        "#{CSI}#{n}G"
      end

      def cursor_position(row = 1, col = 1) : String
        "#{CSI}#{row};#{col}H"
      end

      def cursor_home : String
        "#{CSI}H"
      end

      def cursor_save : String
        "#{ESC}7"
      end

      def cursor_restore : String
        "#{ESC}8"
      end

      def cursor_hide : String
        "#{CSI}?25l"
      end

      def cursor_show : String
        "#{CSI}?25h"
      end

      # Screen control sequences
      def clear_screen : String
        "#{CSI}2J"
      end

      def clear_screen_above : String
        "#{CSI}1J"
      end

      def clear_screen_below : String
        "#{CSI}J"
      end

      def clear_line : String
        "#{CSI}2K"
      end

      def clear_line_left : String
        "#{CSI}1K"
      end

      def clear_line_right : String
        "#{CSI}K"
      end

      def scroll_up(n = 1) : String
        "#{CSI}#{n}S"
      end

      def scroll_down(n = 1) : String
        "#{CSI}#{n}T"
      end

      # Text attributes
      def reset : String
        "#{CSI}0m"
      end

      def bold : String
        "#{CSI}1m"
      end

      def dim : String
        "#{CSI}2m"
      end

      def italic : String
        "#{CSI}3m"
      end

      def underline : String
        "#{CSI}4m"
      end

      def blink : String
        "#{CSI}5m"
      end

      def reverse : String
        "#{CSI}7m"
      end

      def hidden : String
        "#{CSI}8m"
      end

      def strikethrough : String
        "#{CSI}9m"
      end

      # Reset individual attributes
      def no_bold : String
        "#{CSI}22m"
      end

      def no_dim : String
        "#{CSI}22m"
      end

      def no_italic : String
        "#{CSI}23m"
      end

      def no_underline : String
        "#{CSI}24m"
      end

      def no_blink : String
        "#{CSI}25m"
      end

      def no_reverse : String
        "#{CSI}27m"
      end

      def no_hidden : String
        "#{CSI}28m"
      end

      def no_strikethrough : String
        "#{CSI}29m"
      end

      # Colors - 8 color mode
      def fg_color(color : Int32) : String
        "#{CSI}#{30 + color}m"
      end

      def bg_color(color : Int32) : String
        "#{CSI}#{40 + color}m"
      end

      # Colors - 256 color mode
      def fg_color_256(color : Int32) : String
        "#{CSI}38;5;#{color}m"
      end

      def bg_color_256(color : Int32) : String
        "#{CSI}48;5;#{color}m"
      end

      # Colors - True color (24-bit) mode
      def fg_color_rgb(r : Int32, g : Int32, b : Int32) : String
        "#{CSI}38;2;#{r};#{g};#{b}m"
      end

      def bg_color_rgb(r : Int32, g : Int32, b : Int32) : String
        "#{CSI}48;2;#{r};#{g};#{b}m"
      end

      # Terminal modes
      def alternate_screen_enable : String
        "#{CSI}?1049h"
      end

      def alternate_screen_disable : String
        "#{CSI}?1049l"
      end

      def bracketed_paste_enable : String
        "#{CSI}?2004h"
      end

      def bracketed_paste_disable : String
        "#{CSI}?2004l"
      end

      def mouse_tracking_enable : String
        "#{CSI}?1000h"
      end

      def mouse_tracking_disable : String
        "#{CSI}?1000l"
      end

      def mouse_tracking_extended_enable : String
        "#{CSI}?1002h"
      end

      def mouse_tracking_extended_disable : String
        "#{CSI}?1002l"
      end

      def mouse_sgr_enable : String
        "#{CSI}?1006h"
      end

      def mouse_sgr_disable : String
        "#{CSI}?1006l"
      end

      # Line drawing characters (ACS - Alternate Character Set)
      def acs_enable : String
        "#{ESC}(0"
      end

      def acs_disable : String
        "#{ESC}(B"
      end

      # ACS line drawing characters
      ACS_ULCORNER = "l" # Upper left corner
      ACS_LLCORNER = "m" # Lower left corner
      ACS_URCORNER = "k" # Upper right corner
      ACS_LRCORNER = "j" # Lower right corner
      ACS_LTEE     = "t" # Left tee
      ACS_RTEE     = "u" # Right tee
      ACS_BTEE     = "v" # Bottom tee
      ACS_TTEE     = "w" # Top tee
      ACS_HLINE    = "q" # Horizontal line
      ACS_VLINE    = "x" # Vertical line
      ACS_PLUS     = "n" # Plus (cross)
      ACS_DIAMOND  = "`" # Diamond
      ACS_CKBOARD  = "a" # Checkerboard
      ACS_DEGREE   = "f" # Degree symbol
      ACS_PLMINUS  = "g" # Plus/minus
      ACS_BULLET   = "~" # Bullet

      # Utility methods
      def strip_ansi(text : String) : String
        # Remove all ANSI escape sequences
        text.gsub(/\e\[[0-9;]*[a-zA-Z]/, "")
      end

      def length_without_ansi(text : String) : Int32
        strip_ansi(text).size
      end
    end
  end
end
