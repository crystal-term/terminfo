module Term
  module Terminfo
    # Terminfo database parsing and capability lookup
    module Database
      extend self

      # Standard terminfo database paths
      TERMINFO_PATHS = [
        ENV["TERMINFO"]?,
        "#{ENV["HOME"]}/.terminfo",
        "/etc/terminfo",
        "/lib/terminfo",
        "/usr/share/terminfo",
        "/usr/share/misc/terminfo",
        "/usr/local/share/terminfo"
      ].compact

      # Capability entry
      record Capability,
        name : String,
        type : Symbol, # :boolean, :numeric, :string
        value : Bool | Int32 | String | Nil

      # Terminal entry
      record Entry,
        name : String,
        aliases : Array(String),
        description : String,
        capabilities : Hash(String, Capability)

      # Cache for loaded entries
      @@cache = {} of String => Entry?

      # Get entry for terminal type
      def get_entry(term : String? = nil) : Entry?
        term ||= ENV["TERM"]? || "dumb"
        
        # Check cache
        return @@cache[term] if @@cache.has_key?(term)
        
        # Try to load from database
        entry = load_entry(term)
        @@cache[term] = entry
        entry
      end

      # Get capability value
      def get_capability(name : String, term : String? = nil) : Bool | Int32 | String | Nil
        entry = get_entry(term)
        return nil unless entry
        
        cap = entry.capabilities[name]?
        cap.try(&.value)
      end

      # Check if terminal has boolean capability
      def has_capability?(name : String, term : String? = nil) : Bool
        value = get_capability(name, term)
        value.is_a?(Bool) ? value : false
      end

      # Get numeric capability
      def get_numeric(name : String, term : String? = nil) : Int32?
        value = get_capability(name, term)
        value.as?(Int32)
      end

      # Get string capability
      def get_string(name : String, term : String? = nil) : String?
        value = get_capability(name, term)
        value.as?(String)
      end

      # Common capability shortcuts
      def max_colors(term : String? = nil) : Int32
        get_numeric("colors", term) || 0
      end

      def columns(term : String? = nil) : Int32
        get_numeric("cols", term) || 80
      end

      def lines(term : String? = nil) : Int32
        get_numeric("lines", term) || 24
      end

      # Load entry from terminfo database
      private def load_entry(term : String) : Entry?
        # For now, we'll use hardcoded entries for common terminals
        # In a full implementation, this would parse actual terminfo files
        case term
        when "xterm", "xterm-256color"
          Entry.new(
            name: "xterm-256color",
            aliases: ["xterm", "xterm-color"],
            description: "xterm with 256 colors",
            capabilities: build_xterm_capabilities
          )
        when "screen", "screen-256color"
          Entry.new(
            name: "screen-256color",
            aliases: ["screen"],
            description: "GNU screen with 256 colors",
            capabilities: build_screen_capabilities
          )
        when "dumb"
          Entry.new(
            name: "dumb",
            aliases: [] of String,
            description: "dumb terminal",
            capabilities: build_dumb_capabilities
          )
        else
          # Try to find a terminfo file
          find_terminfo_file(term) || build_generic_entry(term)
        end
      end

      # Try to find terminfo file
      private def find_terminfo_file(term : String) : Entry?
        return nil if term.empty?
        
        # Terminfo files are stored as /path/to/terminfo/t/term
        # where 't' is the first character of the term name
        first_char = term[0]
        
        TERMINFO_PATHS.each do |path|
          file_path = File.join(path, first_char.to_s, term)
          if File.exists?(file_path)
            # In a full implementation, we would parse the binary terminfo format
            # For now, return nil to use fallback
            return nil
          end
        end
        
        nil
      end

      # Build capabilities for xterm
      private def build_xterm_capabilities : Hash(String, Capability)
        caps = {} of String => Capability
        
        # Boolean capabilities
        caps["am"] = Capability.new("am", :boolean, true)  # auto margins
        caps["bce"] = Capability.new("bce", :boolean, true)  # back color erase
        caps["km"] = Capability.new("km", :boolean, true)  # has meta key
        caps["mir"] = Capability.new("mir", :boolean, true)  # move in insert mode
        caps["msgr"] = Capability.new("msgr", :boolean, true)  # move in standout mode
        caps["xenl"] = Capability.new("xenl", :boolean, true)  # newline glitch
        
        # Numeric capabilities
        caps["colors"] = Capability.new("colors", :numeric, 256)
        caps["cols"] = Capability.new("cols", :numeric, 80)
        caps["lines"] = Capability.new("lines", :numeric, 24)
        caps["pairs"] = Capability.new("pairs", :numeric, 65536)
        
        # String capabilities (just the names, actual sequences would be parsed)
        caps["clear"] = Capability.new("clear", :string, "\e[H\e[2J")
        caps["cup"] = Capability.new("cup", :string, "\e[%i%p1%d;%p2%dH")
        caps["cuu1"] = Capability.new("cuu1", :string, "\e[A")
        caps["cud1"] = Capability.new("cud1", :string, "\n")
        caps["cuf1"] = Capability.new("cuf1", :string, "\e[C")
        caps["cub1"] = Capability.new("cub1", :string, "\b")
        caps["home"] = Capability.new("home", :string, "\e[H")
        caps["el"] = Capability.new("el", :string, "\e[K")
        caps["ed"] = Capability.new("ed", :string, "\e[J")
        caps["smcup"] = Capability.new("smcup", :string, "\e[?1049h")
        caps["rmcup"] = Capability.new("rmcup", :string, "\e[?1049l")
        caps["bold"] = Capability.new("bold", :string, "\e[1m")
        caps["sgr0"] = Capability.new("sgr0", :string, "\e[0m")
        caps["smul"] = Capability.new("smul", :string, "\e[4m")
        caps["rmul"] = Capability.new("rmul", :string, "\e[24m")
        caps["rev"] = Capability.new("rev", :string, "\e[7m")
        caps["blink"] = Capability.new("blink", :string, "\e[5m")
        caps["setaf"] = Capability.new("setaf", :string, "\e[3%p1%dm")
        caps["setab"] = Capability.new("setab", :string, "\e[4%p1%dm")
        
        caps
      end

      # Build capabilities for screen
      private def build_screen_capabilities : Hash(String, Capability)
        # Similar to xterm but with some differences
        build_xterm_capabilities
      end

      # Build capabilities for dumb terminal
      private def build_dumb_capabilities : Hash(String, Capability)
        caps = {} of String => Capability
        
        caps["am"] = Capability.new("am", :boolean, true)
        caps["cols"] = Capability.new("cols", :numeric, 80)
        caps["lines"] = Capability.new("lines", :numeric, 24)
        caps["ind"] = Capability.new("ind", :string, "\n")
        
        caps
      end

      # Build generic entry based on TERM environment
      private def build_generic_entry(term : String) : Entry
        # Detect capabilities based on terminal name
        caps = {} of String => Capability
        
        # Basic capabilities
        caps["cols"] = Capability.new("cols", :numeric, 80)
        caps["lines"] = Capability.new("lines", :numeric, 24)
        
        # Color support
        if term.includes?("256color")
          caps["colors"] = Capability.new("colors", :numeric, 256)
        elsif term.includes?("color")
          caps["colors"] = Capability.new("colors", :numeric, 16)
        end
        
        # Common capabilities for non-dumb terminals
        unless term == "dumb"
          caps["am"] = Capability.new("am", :boolean, true)
          caps["clear"] = Capability.new("clear", :string, "\e[H\e[2J")
          caps["cup"] = Capability.new("cup", :string, "\e[%i%p1%d;%p2%dH")
          caps["el"] = Capability.new("el", :string, "\e[K")
          caps["ed"] = Capability.new("ed", :string, "\e[J")
          caps["bold"] = Capability.new("bold", :string, "\e[1m")
          caps["sgr0"] = Capability.new("sgr0", :string, "\e[0m")
        end
        
        Entry.new(
          name: term,
          aliases: [] of String,
          description: "Generic terminal entry",
          capabilities: caps
        )
      end
    end
  end
end