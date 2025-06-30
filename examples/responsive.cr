require "../src/term-terminfo"

# Track if we need to redraw
needs_redraw = true

# Example of creating a responsive terminal application
def draw_box(message)
  size = Term::Terminfo.size
  width = size[:width]
  height = size[:height]

  # Calculate box dimensions (80% of terminal size)
  box_width = (width * 0.8).to_i.clamp(20, width - 4)
  box_height = (height * 0.3).to_i.clamp(5, height - 4)

  # Calculate position to center the box
  start_x = (width - box_width) // 2
  start_y = (height - box_height) // 2

  # Clear screen
  Term::Terminfo.clear_screen

  # Draw top border
  Term::Terminfo.move_cursor(start_y, start_x)
  print "┌" + "─" * (box_width - 2) + "┐"

  # Draw sides and content
  (1...box_height - 1).each do |i|
    Term::Terminfo.move_cursor(start_y + i, start_x)
    print "│" + " " * (box_width - 2) + "│"
  end

  # Draw message in center
  msg_y = start_y + box_height // 2
  msg_x = start_x + (box_width - message.size) // 2
  Term::Terminfo.move_cursor(msg_y, msg_x)
  print message

  # Draw bottom border
  Term::Terminfo.move_cursor(start_y + box_height - 1, start_x)
  print "└" + "─" * (box_width - 2) + "┘"

  # Add resize hint
  Term::Terminfo.move_cursor(height - 2, 2)
  print "Terminal size: #{width}x#{height} (resize terminal to see changes)"

  # Move cursor to bottom
  Term::Terminfo.move_cursor(height - 1, 1)
  print "Press 'q' to quit, 'r' to redraw: "
  STDOUT.flush
end

# Signal handler for terminal resize
Signal::WINCH.trap do
  needs_redraw = true
end

# Check if terminal supports unicode for box drawing
if Term::Terminfo.attributes.unicode_support
  # Main loop
  Term::Terminfo.modes.with_raw_mode do
    Term::Terminfo.modes.with_hidden_cursor do
      # Initial draw
      draw_box("Responsive Terminal Box")

      loop do
        # Check if we need to redraw due to resize
        if needs_redraw
          needs_redraw = false
          draw_box("Responsive Terminal Box")
        end

        # Check for input with timeout
        original_timeout = STDIN.read_timeout
        STDIN.read_timeout = 0.1.seconds

        begin
          if char = STDIN.read_char
            case char
            when 'q', 'Q'
              break
            when 'r', 'R'
              draw_box("Responsive Terminal Box")
            end
          end
        rescue IO::TimeoutError
          # No input, continue loop
        ensure
          STDIN.read_timeout = original_timeout
        end
      end
    end
  end

  # Clear screen and show final message
  Term::Terminfo.clear_screen
  Term::Terminfo.move_cursor(1, 1)
  puts "Thanks for using the responsive terminal demo!"
else
  puts "Terminal size: #{Term::Terminfo.size[:width]}x#{Term::Terminfo.size[:height]}"
  puts "Note: Unicode support not detected, box drawing might not work correctly"
end
