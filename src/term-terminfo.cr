# Cross-platform terminal information library
require "./terminfo/version"
require "./terminfo/size"
require "./terminfo/attributes"
require "./terminfo/capabilities"
require "./terminfo/sequences"
require "./terminfo/keyboard"
require "./terminfo/modes"
require "./terminfo/database"

module Term
  module Terminfo
    extend self

    # Get terminal size (width, height)
    def size
      Size.get
    end

    # Get terminal width
    def width
      size[:width]
    end

    # Get terminal height
    def height
      size[:height]
    end

    # Check if output is a terminal
    def tty?(io = STDOUT)
      io.tty?
    end

    # Get terminal attributes
    def attributes(io = STDOUT)
      Attributes.get(io)
    end

    # Check if terminal supports color
    def color?
      attributes.color_support
    end

    # Get terminal type from environment
    def type
      ENV["TERM"]? || "unknown"
    end

    # Get all terminal capabilities
    def capabilities
      Capabilities.get
    end

    # Check if terminal supports a specific capability
    def supports?(capability : Symbol)
      Capabilities.supports?(capability)
    end

    # Get escape sequences
    def sequences
      Sequences
    end

    # Get keyboard module
    def keyboard
      Keyboard
    end

    # Get modes module
    def modes
      Modes
    end

    # Get database module
    def database
      Database
    end

    # Convenience methods for common operations

    # Clear the screen
    def clear_screen(io = STDOUT)
      io.print(Sequences.clear_screen)
      io.flush
    end

    # Move cursor to position
    def move_cursor(row : Int32, col : Int32, io = STDOUT)
      io.print(Sequences.cursor_position(row, col))
      io.flush
    end

    # Hide cursor
    def hide_cursor(io = STDOUT)
      Modes.hide_cursor(io)
    end

    # Show cursor
    def show_cursor(io = STDOUT)
      Modes.show_cursor(io)
    end

    # Save cursor position
    def save_cursor(io = STDOUT)
      io.print(Sequences.cursor_save)
      io.flush
    end

    # Restore cursor position
    def restore_cursor(io = STDOUT)
      io.print(Sequences.cursor_restore)
      io.flush
    end

    # Apply text style
    def style(text : String, *styles : Symbol) : String
      result = text
      styles.each do |style|
        prefix = case style
                 when :bold          then Sequences.bold
                 when :dim           then Sequences.dim
                 when :italic        then Sequences.italic
                 when :underline     then Sequences.underline
                 when :blink         then Sequences.blink
                 when :reverse       then Sequences.reverse
                 when :hidden        then Sequences.hidden
                 when :strikethrough then Sequences.strikethrough
                 else                     ""
                 end
        result = prefix + result unless prefix.empty?
      end
      result + Sequences.reset
    end

    # Apply color
    def color(text : String, fg : Int32? = nil, bg : Int32? = nil) : String
      result = ""
      result += Sequences.fg_color(fg) if fg
      result += Sequences.bg_color(bg) if bg
      result + text + Sequences.reset
    end

    # Apply 256 color
    def color_256(text : String, fg : Int32? = nil, bg : Int32? = nil) : String
      result = ""
      result += Sequences.fg_color_256(fg) if fg
      result += Sequences.bg_color_256(bg) if bg
      result + text + Sequences.reset
    end

    # Apply RGB color
    def color_rgb(text : String, fg : Tuple(Int32, Int32, Int32)? = nil, bg : Tuple(Int32, Int32, Int32)? = nil) : String
      result = ""
      result += Sequences.fg_color_rgb(fg[0], fg[1], fg[2]) if fg
      result += Sequences.bg_color_rgb(bg[0], bg[1], bg[2]) if bg
      result + text + Sequences.reset
    end
  end
end
