module Term
  module Terminfo
    module Attributes
      extend self

      record Info,
        color_support : Bool,
        unicode_support : Bool,
        mouse_support : Bool,
        term_program : String?

      def get(io = STDOUT) : Info
        Info.new(
          color_support: detect_color_support(io),
          unicode_support: detect_unicode_support,
          mouse_support: detect_mouse_support,
          term_program: detect_term_program
        )
      end

      private def detect_color_support(io)
        # Check if output is a TTY
        return false unless io.tty?

        # Check COLORTERM for truecolor support
        return true if ENV["COLORTERM"]? == "truecolor"

        # Check TERM for color indicators
        term = ENV["TERM"]?
        return false unless term

        # Common color-capable terminal types
        color_terms = [
          "xterm-256color", "screen-256color", "tmux-256color",
          "rxvt-unicode-256color", "linux", "cygwin", "ansi",
          "color", "console", "konsole", "terminator",
        ]

        color_terms.any? { |ct| term.includes?(ct) }
      end

      private def detect_unicode_support
        # Check locale settings
        lang = ENV["LANG"]? || ENV["LC_ALL"]? || ENV["LC_CTYPE"]? || ""
        return true if lang.downcase.includes?("utf-8") || lang.downcase.includes?("utf8")

        # Check terminal type
        term = ENV["TERM"]?
        return true if term && (term.includes?("xterm") || term.includes?("rxvt"))

        # Check if we're in a known Unicode-capable environment
        return true if ENV["WT_SESSION"]? # Windows Terminal
        return true if ENV["TERMINAL_EMULATOR"]? == "JetBrains-JediTerm"

        false
      end

      private def detect_mouse_support
        term = ENV["TERM"]?
        return false unless term

        # Terminals known to support mouse
        mouse_terms = ["xterm", "rxvt", "gnome", "konsole", "putty"]
        mouse_terms.any? { |mt| term.includes?(mt) }
      end

      private def detect_term_program
        # Try to detect the actual terminal program
        ENV["TERM_PROGRAM"]? || ENV["TERMINAL_EMULATOR"]?
      end
    end
  end
end
