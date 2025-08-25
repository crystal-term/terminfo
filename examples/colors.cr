require "../src/term-terminfo"

# Demonstrate color capabilities
puts "=== Terminal Color Capabilities ==="
puts "Supports color: #{Term::Terminfo.color?}"
puts "Color count: #{Term::Terminfo.capabilities[:numeric].colors}"
puts "256 color support: #{Term::Terminfo.supports?(:"256color")}"
puts "True color support: #{Term::Terminfo.supports?(:truecolor)}"
puts

# 8-color mode demonstration
if Term::Terminfo.color?
  puts "=== 8-Color Mode ==="
  (0..7).each do |i|
    print Term::Terminfo.color("█" * 8, fg: i)
    print " "
  end
  puts
  (0..7).each do |i|
    print Term::Terminfo.color("█" * 8, bg: i)
    print " "
  end
  puts
  puts
end

# 256-color mode demonstration
if Term::Terminfo.supports?(:"256color")
  puts "=== 256-Color Mode ==="

  # Color cube
  puts "6x6x6 Color Cube:"
  (0...6).each do |g|
    (0...6).each do |r|
      (0...6).each do |b|
        color = 16 + (r * 36) + (g * 6) + b
        print Term::Terminfo.color_256("█", fg: color)
      end
      print " "
    end
    puts
  end
  puts

  # Grayscale
  puts "Grayscale ramp:"
  (232..255).each do |i|
    print Term::Terminfo.color_256("█", fg: i)
  end
  puts
  puts
end

# True color demonstration
if Term::Terminfo.supports?(:truecolor)
  puts "=== True Color (24-bit) ==="

  # RGB gradient
  puts "RGB Gradient:"
  width = Term::Terminfo.width.clamp(0, 80)
  (0...width).each do |i|
    r = (255.0 * i / width).to_i
    g = (255.0 * (width - i) / width).to_i
    b = 128
    print Term::Terminfo.color_rgb("█", fg: {r, g, b})
  end
  puts

  # HSV color wheel simulation
  puts "\nColor wheel:"
  (0...width).each do |i|
    hue = 360.0 * i / width
    # Simple HSV to RGB conversion (S=1, V=1)
    h = hue / 60.0
    c = 1.0
    x = c * (1 - ((h % 2) - 1).abs)

    rgb = case h.to_i
          when 0 then {c, x, 0.0}
          when 1 then {x, c, 0.0}
          when 2 then {0.0, c, x}
          when 3 then {0.0, x, c}
          when 4 then {x, 0.0, c}
          else        {c, 0.0, x}
          end

    r = (rgb[0] * 255).to_i
    g = (rgb[1] * 255).to_i
    b = (rgb[2] * 255).to_i

    print Term::Terminfo.color_rgb("█", fg: {r, g, b})
  end
  puts
end

puts
puts "=== Text Styles ==="
puts Term::Terminfo.style("Bold text", :bold)
puts Term::Terminfo.style("Dim text", :dim)
puts Term::Terminfo.style("Italic text", :italic)
puts Term::Terminfo.style("Underlined text", :underline)
puts Term::Terminfo.style("Blinking text", :blink) if Term::Terminfo.supports?(:blink)
puts Term::Terminfo.style("Reverse video", :reverse)
puts Term::Terminfo.style("Hidden text (you can't see this)", :hidden)
puts Term::Terminfo.style("Strikethrough text", :strikethrough) if Term::Terminfo.supports?(:strikethrough)
puts Term::Terminfo.style("Combined bold italic underline", :bold, :italic, :underline)

# Colored styles
if Term::Terminfo.color?
  puts
  puts "=== Colored Styles ==="
  text = Term::Terminfo.color("Red bold text", fg: 1)
  puts Term::Terminfo.style(text, :bold)

  text = Term::Terminfo.color_256("Orange italic", fg: 208)
  puts Term::Terminfo.style(text, :italic)

  if Term::Terminfo.supports?(:truecolor)
    text = Term::Terminfo.color_rgb("Purple underline", fg: {128, 0, 255})
    puts Term::Terminfo.style(text, :underline)
  end
end
