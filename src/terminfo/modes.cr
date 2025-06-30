module Term
  module Terminfo
    # Terminal modes management
    module Modes
      extend self

      # Terminal mode states
      record ModeState,
        raw_mode : Bool = false,
        echo : Bool = true,
        canonical : Bool = true,
        alternate_screen : Bool = false,
        cursor_visible : Bool = true,
        mouse_tracking : Bool = false,
        bracketed_paste : Bool = false,
        application_keypad : Bool = false,
        auto_wrap : Bool = true

      # Current mode state
      @@current_state = ModeState.new

      # Get current mode state
      def current : ModeState
        @@current_state
      end

      # Enable raw mode (disable echo, canonical mode, etc.)
      def enable_raw_mode(io = STDOUT)
        return unless io.tty?
        
        {% if flag?(:unix) || flag?(:linux) %}
          # Save current termios settings
          system("stty -echo -icanon min 1 time 0")
          @@current_state = @@current_state.copy_with(
            raw_mode: true,
            echo: false,
            canonical: false
          )
        {% end %}
      end

      # Disable raw mode (restore normal mode)
      def disable_raw_mode(io = STDOUT)
        return unless io.tty?
        
        {% if flag?(:unix) || flag?(:linux) %}
          system("stty echo icanon")
          @@current_state = @@current_state.copy_with(
            raw_mode: false,
            echo: true,
            canonical: true
          )
        {% end %}
      end

      # Enable alternate screen buffer
      def enable_alternate_screen(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.alternate_screen_enable)
        io.flush
        @@current_state = @@current_state.copy_with(alternate_screen: true)
      end

      # Disable alternate screen buffer
      def disable_alternate_screen(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.alternate_screen_disable)
        io.flush
        @@current_state = @@current_state.copy_with(alternate_screen: false)
      end

      # Show cursor
      def show_cursor(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.cursor_show)
        io.flush
        @@current_state = @@current_state.copy_with(cursor_visible: true)
      end

      # Hide cursor
      def hide_cursor(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.cursor_hide)
        io.flush
        @@current_state = @@current_state.copy_with(cursor_visible: false)
      end

      # Enable mouse tracking
      def enable_mouse_tracking(io = STDOUT, extended = false, sgr = true)
        return unless io.tty?
        
        if sgr
          io.print(Sequences.mouse_sgr_enable)
        elsif extended
          io.print(Sequences.mouse_tracking_extended_enable)
        else
          io.print(Sequences.mouse_tracking_enable)
        end
        io.flush
        @@current_state = @@current_state.copy_with(mouse_tracking: true)
      end

      # Disable mouse tracking
      def disable_mouse_tracking(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.mouse_tracking_disable)
        io.print(Sequences.mouse_tracking_extended_disable)
        io.print(Sequences.mouse_sgr_disable)
        io.flush
        @@current_state = @@current_state.copy_with(mouse_tracking: false)
      end

      # Enable bracketed paste mode
      def enable_bracketed_paste(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.bracketed_paste_enable)
        io.flush
        @@current_state = @@current_state.copy_with(bracketed_paste: true)
      end

      # Disable bracketed paste mode
      def disable_bracketed_paste(io = STDOUT)
        return unless io.tty?
        
        io.print(Sequences.bracketed_paste_disable)
        io.flush
        @@current_state = @@current_state.copy_with(bracketed_paste: false)
      end

      # Enable application keypad mode
      def enable_application_keypad(io = STDOUT)
        return unless io.tty?
        
        io.print("\e=")
        io.flush
        @@current_state = @@current_state.copy_with(application_keypad: true)
      end

      # Disable application keypad mode
      def disable_application_keypad(io = STDOUT)
        return unless io.tty?
        
        io.print("\e>")
        io.flush
        @@current_state = @@current_state.copy_with(application_keypad: false)
      end

      # Save current terminal state and execute block
      def with_raw_mode(io = STDOUT, &)
        enable_raw_mode(io)
        yield
      ensure
        disable_raw_mode(io)
      end

      # Execute block in alternate screen
      def with_alternate_screen(io = STDOUT, &)
        enable_alternate_screen(io)
        yield
      ensure
        disable_alternate_screen(io)
      end

      # Execute block with hidden cursor
      def with_hidden_cursor(io = STDOUT, &)
        hide_cursor(io)
        yield
      ensure
        show_cursor(io)
      end

      # Execute block with mouse tracking
      def with_mouse_tracking(io = STDOUT, extended = false, sgr = true, &)
        enable_mouse_tracking(io, extended, sgr)
        yield
      ensure
        disable_mouse_tracking(io)
      end

      # Reset all modes to defaults
      def reset_all(io = STDOUT)
        disable_raw_mode(io) if @@current_state.raw_mode
        disable_alternate_screen(io) if @@current_state.alternate_screen
        show_cursor(io) unless @@current_state.cursor_visible
        disable_mouse_tracking(io) if @@current_state.mouse_tracking
        disable_bracketed_paste(io) if @@current_state.bracketed_paste
        disable_application_keypad(io) if @@current_state.application_keypad
        
        @@current_state = ModeState.new
      end
    end
  end
end