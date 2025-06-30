# Term::Terminfo

A comprehensive cross-platform Crystal library for terminal information detection, control sequences, and terminal manipulation without external dependencies.

## Features

- **Cross-platform**: Works on Unix/Linux, macOS, and Windows
- **No external dependencies**: Pure Crystal implementation
- **Complete terminal control**: Size detection, cursor movement, colors, styles, and more
- **Keyboard input mapping**: Parse and identify special keys and sequences
- **Terminal capabilities**: Detect what features your terminal supports
- **Terminal modes**: Raw mode, alternate screen, mouse tracking, and more
- **Terminfo database**: Access terminal capability information
- **ANSI escape sequences**: Full suite of control sequences for terminal manipulation
- **Multiple fallback strategies**: Ensures terminal info is always available

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  term-terminfo:
    github: crystal-term/terminfo
```

## Usage

### Basic Information

```crystal
require "term-terminfo"

# Get terminal size
size = Term::Terminfo.size
puts "Terminal: #{size[:width]}x#{size[:height]}"

# Get dimensions individually
puts "Width: #{Term::Terminfo.width}"
puts "Height: #{Term::Terminfo.height}"

# Check if output is a terminal
if Term::Terminfo.tty?
  puts "Running in a terminal"
end

# Get terminal type
puts "Terminal type: #{Term::Terminfo.type}"
```

### Terminal Attributes

```crystal
# Get all terminal attributes
attrs = Term::Terminfo.attributes
puts "Color support: #{attrs.color_support}"
puts "Unicode support: #{attrs.unicode_support}"
puts "Mouse support: #{attrs.mouse_support}"
puts "Terminal program: #{attrs.term_program}"

# Quick color check
if Term::Terminfo.color?
  puts "Terminal supports colors!"
end
```

### Terminal Capabilities

```crystal
# Get all capabilities
caps = Term::Terminfo.capabilities
puts "Boolean capabilities: #{caps.boolean}"
puts "Numeric capabilities: #{caps.numeric}"

# Check specific capabilities
if Term::Terminfo.supports?(:bold)
  puts "Terminal supports bold text"
end

if Term::Terminfo.supports?(:256color)
  puts "Terminal supports 256 colors"
end

if Term::Terminfo.supports?(:truecolor)
  puts "Terminal supports true color (24-bit)"
end
```

### Cursor Control

```crystal
# Move cursor
Term::Terminfo.move_cursor(10, 20)  # row 10, column 20

# Save and restore cursor position
Term::Terminfo.save_cursor
puts "Some text"
Term::Terminfo.restore_cursor

# Hide and show cursor
Term::Terminfo.hide_cursor
# Do some work...
Term::Terminfo.show_cursor

# Using sequences directly
print Term::Terminfo.sequences.cursor_up(5)
print Term::Terminfo.sequences.cursor_forward(10)
```

### Screen Manipulation

```crystal
# Clear screen
Term::Terminfo.clear_screen

# Clear using sequences
print Term::Terminfo.sequences.clear_line
print Term::Terminfo.sequences.clear_screen_below

# Scrolling
print Term::Terminfo.sequences.scroll_up(3)
```

### Text Styling

```crystal
# Apply styles to text
puts Term::Terminfo.style("Bold text", :bold)
puts Term::Terminfo.style("Underlined text", :underline)
puts Term::Terminfo.style("Bold and italic", :bold, :italic)

# Apply colors (8-color mode)
puts Term::Terminfo.color("Red text", fg: 1)
puts Term::Terminfo.color("Green on blue", fg: 2, bg: 4)

# Apply 256 colors
puts Term::Terminfo.color_256("Orange text", fg: 208)
puts Term::Terminfo.color_256("Purple background", bg: 93)

# Apply RGB colors (true color)
puts Term::Terminfo.color_rgb("Custom color", fg: {255, 128, 0})
puts Term::Terminfo.color_rgb("Gradient", fg: {255, 0, 255}, bg: {0, 255, 255})

# Using sequences directly
print Term::Terminfo.sequences.bold
print "Bold text"
print Term::Terminfo.sequences.reset
```

### Terminal Modes

```crystal
# Raw mode (disable echo and line buffering)
Term::Terminfo.modes.with_raw_mode do
  # Get single keypress without echo
  char = STDIN.read_char
end

# Alternate screen (like vim, less, etc.)
Term::Terminfo.modes.with_alternate_screen do
  puts "This is on the alternate screen"
  # Original screen is restored when block exits
end

# Hide cursor during operation
Term::Terminfo.modes.with_hidden_cursor do
  # Perform operations without visible cursor
end

# Enable mouse tracking
Term::Terminfo.modes.with_mouse_tracking do
  # Receive mouse events
end

# Manually control modes
Term::Terminfo.modes.enable_raw_mode
Term::Terminfo.modes.enable_alternate_screen
Term::Terminfo.modes.enable_mouse_tracking
# Don't forget to disable them!
Term::Terminfo.modes.reset_all
```

### Keyboard Input

```crystal
# Parse key sequences
key = Term::Terminfo.keyboard.parse_sequence("\e[A")
case key
when .up?
  puts "Up arrow pressed"
when .enter?
  puts "Enter pressed"
when .f1?
  puts "F1 pressed"
end

# Get key name
if key
  puts "Key pressed: #{Term::Terminfo.keyboard.key_name(key)}"
end

# Check key types
if key && Term::Terminfo.keyboard.arrow_key?(key)
  puts "Arrow key pressed"
end
```

### Terminfo Database

```crystal
# Get terminal entry
entry = Term::Terminfo.database.get_entry("xterm-256color")
if entry
  puts "Terminal: #{entry.name}"
  puts "Description: #{entry.description}"
  puts "Capabilities: #{entry.capabilities.size}"
end

# Get specific capability
cols = Term::Terminfo.database.get_numeric("cols")
puts "Default columns: #{cols}"

# Check for capability
if Term::Terminfo.database.has_capability?("bce")
  puts "Terminal supports background color erase"
end
```

### Advanced Sequences

```crystal
sequences = Term::Terminfo.sequences

# Line drawing (ACS - Alternate Character Set)
print sequences.acs_enable
print Term::Terminfo::Sequences::ACS_ULCORNER + Term::Terminfo::Sequences::ACS_HLINE * 10 + Term::Terminfo::Sequences::ACS_URCORNER
print sequences.acs_disable

# Bracketed paste mode
print sequences.bracketed_paste_enable
# Paste operations will be wrapped with markers

# SGR mouse tracking
print sequences.mouse_sgr_enable
# Get precise mouse coordinates

# Strip ANSI from text
text = "\e[1mBold\e[0m text"
clean = sequences.strip_ansi(text)  # "Bold text"
length = sequences.length_without_ansi(text)  # 9
```

## Complete API Reference

### Main Module (Term::Terminfo)

- `size` - Get terminal dimensions
- `width` - Get terminal width
- `height` - Get terminal height  
- `tty?(io = STDOUT)` - Check if IO is a terminal
- `type` - Get terminal type from TERM
- `attributes` - Get terminal attributes
- `color?` - Check color support
- `capabilities` - Get all capabilities
- `supports?(capability)` - Check specific capability
- `clear_screen` - Clear the screen
- `move_cursor(row, col)` - Move cursor to position
- `hide_cursor` - Hide cursor
- `show_cursor` - Show cursor
- `save_cursor` - Save cursor position
- `restore_cursor` - Restore cursor position
- `style(text, *styles)` - Apply text styles
- `color(text, fg, bg)` - Apply 8-color
- `color_256(text, fg, bg)` - Apply 256-color
- `color_rgb(text, fg, bg)` - Apply RGB color

### Submodules

- `Term::Terminfo.sequences` - ANSI escape sequences
- `Term::Terminfo.keyboard` - Keyboard input parsing
- `Term::Terminfo.modes` - Terminal mode management
- `Term::Terminfo.database` - Terminfo database access
- `Term::Terminfo.capabilities` - Capability detection

## Examples

See the `examples/` directory for complete examples:

- `basic.cr` - Basic terminal information
- `responsive.cr` - Responsive box drawing
- `colors.cr` - Color demonstrations
- `keyboard.cr` - Keyboard input handling
- `modes.cr` - Terminal modes usage
- `capabilities.cr` - Capability detection

## Detection Methods

### Terminal Size
1. Windows Console API (Windows) - Native WinAPI calls
2. Environment variables (COLUMNS/LINES) - Quick check for preset values
3. `tput` command - Primary method on Unix/Linux systems
   - Attempts `/dev/tty` for direct terminal access
   - Falls back to standard output
4. `stty` command - Secondary Unix/Linux method
   - Attempts `/dev/tty` for direct terminal access
   - Falls back to standard input
5. Default fallback (80x24) - Industry standard default

The library uses multiple detection strategies to ensure it works in various environments:
- Interactive terminals (TTY)
- SSH sessions
- Terminal multiplexers (tmux, screen)
- Docker containers
- CI/CD environments

### Terminal Capabilities
- Boolean capabilities from TERM environment
- Numeric capabilities from terminal type
- Color detection via COLORTERM and TERM
- Unicode detection via locale settings
- Mouse support based on terminal type
- Terminal program detection

### Keyboard Sequences
- Standard ANSI escape sequences
- Application mode sequences
- Extended key sequences
- Mouse event sequences

## Development

```bash
# Run tests
crystal spec

# Run specific test file
crystal spec spec/unit/capabilities_spec.cr

# Run tests with verbose output
crystal spec --verbose

# Format code
crystal tool format

# Run examples
crystal run examples/basic.cr
```

## Contributing

1. Fork it (<https://github.com/crystal-term/terminfo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).