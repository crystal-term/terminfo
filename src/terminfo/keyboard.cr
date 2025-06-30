module Term
  module Terminfo
    # Keyboard key mappings and detection
    module Keyboard
      extend self

      # Key codes
      enum Key
        # Control keys
        Null      = 0
        CtrlA     = 1
        CtrlB     = 2
        CtrlC     = 3
        CtrlD     = 4
        CtrlE     = 5
        CtrlF     = 6
        CtrlG     = 7
        Backspace = 8
        Tab       = 9
        CtrlJ     = 10
        CtrlK     = 11
        CtrlL     = 12
        Enter     = 13
        CtrlN     = 14
        CtrlO     = 15
        CtrlP     = 16
        CtrlQ     = 17
        CtrlR     = 18
        CtrlS     = 19
        CtrlT     = 20
        CtrlU     = 21
        CtrlV     = 22
        CtrlW     = 23
        CtrlX     = 24
        CtrlY     = 25
        CtrlZ     = 26
        Escape    = 27
        Delete    = 127

        # Special keys (using high values)
        Up        = 1000
        Down      = 1001
        Right     = 1002
        Left      = 1003
        Home      = 1004
        End       = 1005
        PageUp    = 1006
        PageDown  = 1007
        Insert    = 1008
        F1        = 1009
        F2        = 1010
        F3        = 1011
        F4        = 1012
        F5        = 1013
        F6        = 1014
        F7        = 1015
        F8        = 1016
        F9        = 1017
        F10       = 1018
        F11       = 1019
        F12       = 1020

        # Modified keys
        ShiftTab  = 1021
        ShiftUp   = 1022
        ShiftDown = 1023
        ShiftRight = 1024
        ShiftLeft = 1025

        # Mouse events
        MouseLeft = 2000
        MouseRight = 2001
        MouseMiddle = 2002
        MouseRelease = 2003
        MouseWheelUp = 2004
        MouseWheelDown = 2005
      end

      # Key sequences mapping
      KEY_SEQUENCES = {
        # Arrow keys
        "\e[A" => Key::Up,
        "\e[B" => Key::Down,
        "\e[C" => Key::Right,
        "\e[D" => Key::Left,
        "\eOA" => Key::Up,    # Application mode
        "\eOB" => Key::Down,
        "\eOC" => Key::Right,
        "\eOD" => Key::Left,

        # Home/End
        "\e[H" => Key::Home,
        "\e[F" => Key::End,
        "\e[1~" => Key::Home,
        "\e[4~" => Key::End,
        "\e[7~" => Key::Home,
        "\e[8~" => Key::End,
        "\eOH" => Key::Home,
        "\eOF" => Key::End,

        # Page Up/Down
        "\e[5~" => Key::PageUp,
        "\e[6~" => Key::PageDown,

        # Insert/Delete
        "\e[2~" => Key::Insert,
        "\e[3~" => Key::Delete,

        # Function keys
        "\eOP" => Key::F1,
        "\eOQ" => Key::F2,
        "\eOR" => Key::F3,
        "\eOS" => Key::F4,
        "\e[15~" => Key::F5,
        "\e[17~" => Key::F6,
        "\e[18~" => Key::F7,
        "\e[19~" => Key::F8,
        "\e[20~" => Key::F9,
        "\e[21~" => Key::F10,
        "\e[23~" => Key::F11,
        "\e[24~" => Key::F12,

        # Modified keys
        "\e[Z" => Key::ShiftTab,
        "\e[1;2A" => Key::ShiftUp,
        "\e[1;2B" => Key::ShiftDown,
        "\e[1;2C" => Key::ShiftRight,
        "\e[1;2D" => Key::ShiftLeft,

        # Common alternatives
        "\e[a" => Key::ShiftUp,
        "\e[b" => Key::ShiftDown,
        "\e[c" => Key::ShiftRight,
        "\e[d" => Key::ShiftLeft,
      }

      # Parse key sequence to Key enum
      def parse_sequence(sequence : String) : Key?
        # Single byte
        if sequence.size == 1
          byte = sequence.byte_at(0)
          case byte
          when 0..31, 127
            Key.from_value(byte.to_i32)
          else
            nil  # Regular character, not a special key
          end
        else
          # Multi-byte sequence
          KEY_SEQUENCES[sequence]?
        end
      end

      # Get key name
      def key_name(key : Key) : String
        case key
        when .null?      then "Null"
        when .ctrl_a?    then "Ctrl+A"
        when .ctrl_b?    then "Ctrl+B"
        when .ctrl_c?    then "Ctrl+C"
        when .ctrl_d?    then "Ctrl+D"
        when .ctrl_e?    then "Ctrl+E"
        when .ctrl_f?    then "Ctrl+F"
        when .ctrl_g?    then "Ctrl+G"
        when .backspace? then "Backspace"
        when .tab?       then "Tab"
        when .ctrl_j?    then "Ctrl+J"
        when .ctrl_k?    then "Ctrl+K"
        when .ctrl_l?    then "Ctrl+L"
        when .enter?     then "Enter"
        when .ctrl_n?    then "Ctrl+N"
        when .ctrl_o?    then "Ctrl+O"
        when .ctrl_p?    then "Ctrl+P"
        when .ctrl_q?    then "Ctrl+Q"
        when .ctrl_r?    then "Ctrl+R"
        when .ctrl_s?    then "Ctrl+S"
        when .ctrl_t?    then "Ctrl+T"
        when .ctrl_u?    then "Ctrl+U"
        when .ctrl_v?    then "Ctrl+V"
        when .ctrl_w?    then "Ctrl+W"
        when .ctrl_x?    then "Ctrl+X"
        when .ctrl_y?    then "Ctrl+Y"
        when .ctrl_z?    then "Ctrl+Z"
        when .escape?    then "Escape"
        when .delete?    then "Delete"
        when .up?        then "Up"
        when .down?      then "Down"
        when .right?     then "Right"
        when .left?      then "Left"
        when .home?      then "Home"
        when .end?       then "End"
        when .page_up?   then "PageUp"
        when .page_down? then "PageDown"
        when .insert?    then "Insert"
        when .f1?        then "F1"
        when .f2?        then "F2"
        when .f3?        then "F3"
        when .f4?        then "F4"
        when .f5?        then "F5"
        when .f6?        then "F6"
        when .f7?        then "F7"
        when .f8?        then "F8"
        when .f9?        then "F9"
        when .f10?       then "F10"
        when .f11?       then "F11"
        when .f12?       then "F12"
        when .shift_tab? then "Shift+Tab"
        when .shift_up?  then "Shift+Up"
        when .shift_down? then "Shift+Down"
        when .shift_right? then "Shift+Right"
        when .shift_left? then "Shift+Left"
        when .mouse_left? then "MouseLeft"
        when .mouse_right? then "MouseRight"
        when .mouse_middle? then "MouseMiddle"
        when .mouse_release? then "MouseRelease"
        when .mouse_wheel_up? then "MouseWheelUp"
        when .mouse_wheel_down? then "MouseWheelDown"
        else
          "Unknown"
        end
      end

      # Check if key is printable
      def printable?(key : Key) : Bool
        key.value >= 32 && key.value < 127
      end

      # Check if key is control character
      def control?(key : Key) : Bool
        key.value < 32 || key.value == 127
      end

      # Check if key is function key
      def function_key?(key : Key) : Bool
        key.value >= Key::F1.value && key.value <= Key::F12.value
      end

      # Check if key is arrow key
      def arrow_key?(key : Key) : Bool
        case key
        when .up?, .down?, .left?, .right?
          true
        else
          false
        end
      end

      # Check if key is navigation key
      def navigation_key?(key : Key) : Bool
        case key
        when .home?, .end?, .page_up?, .page_down?
          true
        else
          arrow_key?(key)
        end
      end

      # Check if key is mouse event
      def mouse_event?(key : Key) : Bool
        key.value >= 2000 && key.value < 3000
      end
    end
  end
end