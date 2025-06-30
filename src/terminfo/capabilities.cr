module Term
  module Terminfo
    # Terminal capability detection and management
    module Capabilities
      extend self

      # Boolean capabilities
      record BooleanCaps,
        auto_left_margin : Bool = false,
        auto_right_margin : Bool = false,
        back_color_erase : Bool = false,
        can_change_color : Bool = false,
        eat_newline_glitch : Bool = false,
        has_meta_key : Bool = false,
        has_status_line : Bool = false,
        insert_null_glitch : Bool = false,
        move_insert_mode : Bool = false,
        move_standout_mode : Bool = false,
        over_strike : Bool = false,
        xon_xoff : Bool = false

      # Numeric capabilities
      record NumericCaps,
        columns : Int32 = 80,
        lines : Int32 = 24,
        colors : Int32 = 0,
        color_pairs : Int32 = 0,
        max_attributes : Int32 = 0,
        tab_size : Int32 = 8

      # Get all capabilities for the current terminal
      def get : NamedTuple(boolean: BooleanCaps, numeric: NumericCaps)
        {
          boolean: detect_boolean_capabilities,
          numeric: detect_numeric_capabilities
        }
      end

      # Get boolean capabilities
      def boolean_capabilities : BooleanCaps
        detect_boolean_capabilities
      end

      # Get numeric capabilities  
      def numeric_capabilities : NumericCaps
        detect_numeric_capabilities
      end

      # Check if terminal supports a specific capability
      def supports?(capability : Symbol) : Bool
        case capability
        when :colors
          supports_color?
        when :color
          supports_color?
        when :unicode
          supports_unicode?
        when :mouse
          supports_mouse?
        when :bold
          supports_bold?
        when :underline
          supports_underline?
        when :blink
          supports_blink?
        when :reverse
          supports_reverse?
        when :dim
          supports_dim?
        when :italic
          supports_italic?
        when :strikethrough
          supports_strikethrough?
        when :truecolor
          supports_truecolor?
        when :"256color"
          supports_256color?
        when :alt_screen
          supports_alt_screen?
        else
          false
        end
      end

      private def detect_boolean_capabilities : BooleanCaps
        term = ENV["TERM"]? || ""
        
        BooleanCaps.new(
          auto_right_margin: !term.includes?("dumb"),
          back_color_erase: term.includes?("xterm") || term.includes?("screen"),
          can_change_color: term.includes?("xterm") || term.includes?("linux"),
          eat_newline_glitch: term.includes?("xterm"),
          has_meta_key: !term.includes?("dumb"),
          move_standout_mode: true,
          xon_xoff: false
        )
      end

      private def detect_numeric_capabilities : NumericCaps
        size = Size.get
        colors = detect_color_count
        
        NumericCaps.new(
          columns: size[:width],
          lines: size[:height],
          colors: colors,
          color_pairs: calculate_color_pairs(colors),
          max_attributes: 7,
          tab_size: 8
        )
      end

      private def detect_color_count : Int32
        return 0 unless Attributes.get.color_support
        
        # Check for true color
        return 16777216 if ENV["COLORTERM"]? == "truecolor"
        
        # Check terminal type
        term = ENV["TERM"]? || ""
        case
        when term.includes?("256color")
          256
        when term.includes?("color")
          16
        else
          8
        end
      end

      private def calculate_color_pairs(colors : Int32) : Int32
        return 0 if colors == 0
        
        # For true color, return a reasonable number instead of colors²
        # which would overflow Int32
        case colors
        when 16777216  # True color
          # Return max reasonable pairs (same as 256-color mode)
          65536
        when 256
          # 256 * 256 = 65536
          65536
        when 16
          # 16 * 16 = 256
          256
        when 8
          # 8 * 8 = 64
          64
        else
          # For other values, cap at a reasonable maximum
          colors.to_i64 * colors > Int32::MAX ? 65536 : colors * colors
        end
      end

      private def supports_color? : Bool
        Attributes.get.color_support
      end

      private def supports_unicode? : Bool
        Attributes.get.unicode_support
      end

      private def supports_mouse? : Bool
        Attributes.get.mouse_support
      end

      private def supports_bold? : Bool
        # Most modern terminals support bold
        term = ENV["TERM"]? || ""
        !term.includes?("dumb")
      end

      private def supports_underline? : Bool
        term = ENV["TERM"]? || ""
        !term.includes?("dumb")
      end

      private def supports_blink? : Bool
        term = ENV["TERM"]? || ""
        term.includes?("xterm") || term.includes?("rxvt") || term.includes?("screen")
      end

      private def supports_reverse? : Bool
        term = ENV["TERM"]? || ""
        !term.includes?("dumb")
      end

      private def supports_dim? : Bool
        term = ENV["TERM"]? || ""
        term.includes?("xterm") || term.includes?("rxvt") || term.includes?("screen")
      end

      private def supports_italic? : Bool
        term = ENV["TERM"]? || ""
        term.includes?("xterm") || term.includes?("tmux") || term.includes?("screen")
      end

      private def supports_strikethrough? : Bool
        # Limited support, mainly in modern terminals
        term_program = ENV["TERM_PROGRAM"]? || ""
        term_program.includes?("iTerm") || term_program.includes?("Terminal.app") ||
          !!(ENV["VTE_VERSION"]? || ENV["KONSOLE_VERSION"]?)
      end

      private def supports_truecolor? : Bool
        ENV["COLORTERM"]? == "truecolor" || ENV["COLORTERM"]? == "24bit"
      end

      private def supports_256color? : Bool
        term = ENV["TERM"]? || ""
        term.includes?("256color") || supports_truecolor?
      end

      private def supports_alt_screen? : Bool
        term = ENV["TERM"]? || ""
        !term.includes?("dumb") && (term.includes?("xterm") || term.includes?("screen"))
      end
    end
  end
end