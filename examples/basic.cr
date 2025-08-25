require "../src/term-terminfo"

# Get terminal size
size = Term::Terminfo.size
puts "Terminal size: #{size[:width]}x#{size[:height]}"

# Get individual dimensions
puts "Width: #{Term::Terminfo.width}"
puts "Height: #{Term::Terminfo.height}"

# Check if output is a terminal
puts "Is TTY? #{Term::Terminfo.tty?}"

# Get terminal type
puts "Terminal type: #{Term::Terminfo.type}"

# Get terminal attributes
attrs = Term::Terminfo.attributes
puts "\nTerminal attributes:"
puts "  Color support: #{attrs.color_support}"
puts "  Unicode support: #{attrs.unicode_support}"
puts "  Mouse support: #{attrs.mouse_support}"
puts "  Terminal program: #{attrs.term_program || "unknown"}"

# Shorthand for color support
puts "\nSupports color? #{Term::Terminfo.color?}"
