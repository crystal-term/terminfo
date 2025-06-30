require "../src/term-terminfo"

puts "=== Terminal Modes Demo ==="
puts "Current terminal: #{Term::Terminfo.type}"
puts

# Demonstrate alternate screen
puts "Press Enter to switch to alternate screen..."
gets

Term::Terminfo.modes.with_alternate_screen do
  Term::Terminfo.clear_screen
  Term::Terminfo.move_cursor(1, 1)

  puts "=== ALTERNATE SCREEN ==="
  puts "This is the alternate screen buffer."
  puts "It's like a separate terminal window."
  puts "When we exit, the original screen will be restored."
  puts
  puts "Press Enter to see cursor movement..."
  gets

  # Demonstrate cursor movement
  Term::Terminfo.clear_screen

  # Draw a box using cursor movement
  width = 40
  height = 10
  start_row = 5
  start_col = 10

  # Top border
  Term::Terminfo.move_cursor(start_row, start_col)
  print "┌" + "─" * (width - 2) + "┐"

  # Sides
  (1...height - 1).each do |i|
    Term::Terminfo.move_cursor(start_row + i, start_col)
    print "│"
    Term::Terminfo.move_cursor(start_row + i, start_col + width - 1)
    print "│"
  end

  # Bottom border
  Term::Terminfo.move_cursor(start_row + height - 1, start_col)
  print "└" + "─" * (width - 2) + "┘"

  # Message in the box
  message = "Cursor positioning works!"
  Term::Terminfo.move_cursor(start_row + height // 2, start_col + (width - message.size) // 2)
  print message

  # Move cursor below box
  Term::Terminfo.move_cursor(start_row + height + 2, 1)
  puts "Press Enter to test hidden cursor..."
  gets

  # Demonstrate hidden cursor
  Term::Terminfo.hide_cursor
  Term::Terminfo.move_cursor(start_row + height + 4, 1)
  print "Cursor is now hidden. Watch the spinner: "

  spinner_chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
  20.times do |i|
    print spinner_chars[i % spinner_chars.size]
    STDOUT.flush
    sleep 0.1.seconds
    print "\b"
  end

  Term::Terminfo.show_cursor
  puts "\nCursor is visible again."

  puts "\nPress Enter to return to main screen..."
  gets
end

puts "=== BACK TO MAIN SCREEN ==="
puts "The alternate screen has been closed."
puts "Notice how the original content is restored."
puts

# Demonstrate raw mode
puts "Press Enter to test raw mode (press 'q' to exit)..."
gets

puts "Raw mode active. Keys won't be echoed. Press 'q' to quit:"
Term::Terminfo.modes.with_raw_mode do
  loop do
    if char = STDIN.read_char
      break if char == 'q'
      print "You pressed: '#{char}' (#{char.ord}) "
      STDOUT.flush
    end
  end
end

puts "\n\nRaw mode disabled. Echo is back to normal."
puts

# Show current mode state
puts "=== Current Mode State ==="
state = Term::Terminfo.modes.current
puts "Raw mode: #{state.raw_mode}"
puts "Echo: #{state.echo}"
puts "Canonical: #{state.canonical}"
puts "Alternate screen: #{state.alternate_screen}"
puts "Cursor visible: #{state.cursor_visible}"
puts "Mouse tracking: #{state.mouse_tracking}"
puts "Bracketed paste: #{state.bracketed_paste}"
puts "Application keypad: #{state.application_keypad}"
puts "Auto wrap: #{state.auto_wrap}"
