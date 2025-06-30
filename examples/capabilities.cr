require "../src/term-terminfo"

puts "=== Terminal Information ==="
puts "Terminal type: #{Term::Terminfo.type}"
puts "Size: #{Term::Terminfo.width}x#{Term::Terminfo.height}"
puts "Is TTY: #{Term::Terminfo.tty?}"
puts

puts "=== Terminal Attributes ==="
attrs = Term::Terminfo.attributes
puts "Color support: #{attrs.color_support}"
puts "Unicode support: #{attrs.unicode_support}"
puts "Mouse support: #{attrs.mouse_support}"
puts "Terminal program: #{attrs.term_program || "unknown"}"
puts

puts "=== Boolean Capabilities ==="
caps = Term::Terminfo.capabilities
bool_caps = caps[:boolean]
puts "Auto right margin: #{bool_caps.auto_right_margin}"
puts "Auto left margin: #{bool_caps.auto_left_margin}"
puts "Back color erase: #{bool_caps.back_color_erase}"
puts "Can change color: #{bool_caps.can_change_color}"
puts "Has meta key: #{bool_caps.has_meta_key}"
puts "Move in standout mode: #{bool_caps.move_standout_mode}"
puts "Eat newline glitch: #{bool_caps.eat_newline_glitch}"
puts

puts "=== Numeric Capabilities ==="
num_caps = caps[:numeric]
puts "Columns: #{num_caps.columns}"
puts "Lines: #{num_caps.lines}"
puts "Colors: #{num_caps.colors}"
puts "Color pairs: #{num_caps.color_pairs}"
puts "Tab size: #{num_caps.tab_size}"
puts

puts "=== Feature Support ==="
features = {
  bold: "Bold text",
  underline: "Underline",
  italic: "Italic",
  blink: "Blinking",
  reverse: "Reverse video",
  dim: "Dim/half-bright",
  strikethrough: "Strikethrough",
  color: "Basic colors",
  "256color": "256 colors",
  truecolor: "True color (24-bit)",
  unicode: "Unicode",
  mouse: "Mouse tracking",
  alt_screen: "Alternate screen"
}

features.each do |feature, description|
  supported = Term::Terminfo.supports?(feature)
  status = supported ? "✓" : "✗"
  puts "#{status} #{description}"
end
puts

puts "=== Terminfo Database ==="
# Try to get entry for current terminal
if entry = Term::Terminfo.database.get_entry
  puts "Terminal name: #{entry.name}"
  puts "Description: #{entry.description}"
  puts "Aliases: #{entry.aliases.join(", ")}" unless entry.aliases.empty?
  puts "Total capabilities: #{entry.capabilities.size}"
  
  # Show some common capabilities
  puts "\nCommon string capabilities:"
  ["clear", "cup", "cuu1", "cud1", "bold", "sgr0"].each do |cap|
    if value = entry.capabilities[cap]?
      puts "  #{cap}: #{value.value.inspect}"
    end
  end
end
puts

puts "=== Environment Variables ==="
["TERM", "COLORTERM", "TERM_PROGRAM", "LANG", "LC_ALL", "COLUMNS", "LINES"].each do |var|
  value = ENV[var]?
  puts "#{var}: #{value || "(not set)"}"
end