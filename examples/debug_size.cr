require "../src/term-terminfo"

puts "=== Terminal Size Debug ==="
puts "STDOUT.tty?: #{STDOUT.tty?}"
puts "STDERR.tty?: #{STDERR.tty?}"
puts

# Test environment variables
puts "Environment variables:"
puts "  COLUMNS: #{ENV["COLUMNS"]?}"
puts "  LINES: #{ENV["LINES"]?}"
puts

# Test tput directly
puts "Direct command tests:"
begin
  tput_cols = `tput cols 2>&1`.strip
  puts "  tput cols: #{tput_cols}"
rescue ex
  puts "  tput cols failed: #{ex.message}"
end

begin
  tput_lines = `tput lines 2>&1`.strip
  puts "  tput lines: #{tput_lines}"
rescue ex
  puts "  tput lines failed: #{ex.message}"
end

begin
  tput_cols_tty = `tput cols 2>/dev/tty`.strip
  puts "  tput cols (via /dev/tty): #{tput_cols_tty}"
rescue ex
  puts "  tput cols (via /dev/tty) failed: #{ex.message}"
end

begin
  stty_size = `stty size 2>&1`.strip
  puts "  stty size: #{stty_size}"
rescue ex
  puts "  stty size failed: #{ex.message}"
end

begin
  stty_size_tty = `stty size < /dev/tty 2>&1`.strip
  puts "  stty size (via /dev/tty): #{stty_size_tty}"
rescue ex
  puts "  stty size (via /dev/tty) failed: #{ex.message}"
end

puts
puts "Term::Terminfo results:"
size = Term::Terminfo.size
puts "  Size: #{size[:width]}x#{size[:height]}"

# Try to call individual detection methods through reflection
puts
puts "Testing which commands:"
puts "  which tput: #{system("which tput > /dev/null 2>&1")}"
puts "  which stty: #{system("which stty > /dev/null 2>&1")}"