require "../src/term-terminfo"

puts "=== Keyboard Input Demo ==="
puts "Press keys to see their codes. Press 'q' to quit."
puts "Try special keys like arrows, function keys, Tab, etc."
puts

# Enable raw mode to capture individual keypresses
Term::Terminfo.modes.with_raw_mode do
  Term::Terminfo.modes.with_hidden_cursor do
    loop do
      # Read a character or sequence
      char = STDIN.read_char
      break unless char
      
      # Build sequence string
      sequence = String.build do |str|
        str << char
        # Check for escape sequences
        if char == '\e'
          # Set a short timeout for reading escape sequence characters
          original_timeout = STDIN.read_timeout
          STDIN.read_timeout = 0.01.seconds
          
          begin
            # Read additional characters for escape sequence
            while next_char = STDIN.read_char
              str << next_char
            end
          rescue IO::TimeoutError
            # Timeout reached, escape sequence complete
          ensure
            # Restore original timeout
            STDIN.read_timeout = original_timeout
          end
        end
      end
      
      # Clear line and move cursor to beginning
      print Term::Terminfo.sequences.clear_line
      print "\r"
      
      # Parse the sequence
      if key = Term::Terminfo.keyboard.parse_sequence(sequence)
        key_name = Term::Terminfo.keyboard.key_name(key)
        print "Special key: #{key_name}"
        
        # Additional information
        info = [] of String
        info << "Control" if Term::Terminfo.keyboard.control?(key)
        info << "Function" if Term::Terminfo.keyboard.function_key?(key)
        info << "Arrow" if Term::Terminfo.keyboard.arrow_key?(key)
        info << "Navigation" if Term::Terminfo.keyboard.navigation_key?(key)
        info << "Mouse" if Term::Terminfo.keyboard.mouse_event?(key)
        
        print " (#{info.join(", ")})" unless info.empty?
      else
        # Regular character
        if sequence == "q"
          puts "\rQuitting..."
          break
        end
        
        print "Character: '#{sequence}'"
        if sequence.size == 1
          print " (ASCII: #{sequence.byte_at(0)})"
        end
      end
      
      # Show the raw sequence
      print " [Raw: #{sequence.bytes.map { |b| "\\x%02x" % b }.join}]"
      
      STDOUT.flush
    end
  end
end

puts "\nKeyboard demo ended."