module Term
  module Terminfo
    module Size
      extend self

      DEFAULT_WIDTH = 80
      DEFAULT_HEIGHT = 24

      # Get terminal size using multiple detection methods
      def get(io = STDOUT) : NamedTuple(width: Int32, height: Int32)
        # Try native method first
        size = native_size(io)
        return size if size

        # Try environment variables
        size = env_size
        return size if size

        # Try tput command
        size = tput_size
        return size if size

        # Try stty command
        size = stty_size
        return size if size

        # Default fallback
        {width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT}
      end

      # Platform-specific native size detection
      private def native_size(io)
        {% if flag?(:windows) %}
          windows_size(io)
        {% else %}
          unix_size(io)
        {% end %}
      end

      # Unix/Linux native size detection
      private def unix_size(io)
        # Try to get size from the terminal even if not a TTY
        # This handles cases where output is piped but we still want terminal size
        
        # Since Crystal doesn't have a built-in terminal_size method,
        # we rely on the fallback methods (tput, stty, env)
        
        nil
      end

      # Windows native size detection
      private def windows_size(io)
        {% if flag?(:windows) %}
          require "./windows/console"
          
          handle = case io
                   when STDOUT then :stdout
                   when STDERR then :stderr
                   else :stdout
                   end
          
          Windows::Console.get_size(handle)
        {% else %}
          nil
        {% end %}
      end

      # Try to get size from environment variables
      private def env_size
        width = ENV["COLUMNS"]?.try(&.to_i?)
        height = ENV["LINES"]?.try(&.to_i?)
        
        if width && height && width > 0 && height > 0
          {width: width, height: height}
        else
          nil
        end
      end

      # Try to get size using tput command
      private def tput_size
        return nil unless system("which tput > /dev/null 2>&1")
        
        begin
          # Try to get size from the controlling terminal
          width = `tput cols 2>/dev/tty`.strip.to_i?
          height = `tput lines 2>/dev/tty`.strip.to_i?
          
          if width && height && width > 0 && height > 0
            {width: width, height: height}
          else
            # Fallback to regular tput if /dev/tty fails
            width = `tput cols 2>/dev/null`.strip.to_i?
            height = `tput lines 2>/dev/null`.strip.to_i?
            
            if width && height && width > 0 && height > 0
              {width: width, height: height}
            else
              nil
            end
          end
        rescue
          nil
        end
      end

      # Try to get size using stty command
      private def stty_size
        return nil unless system("which stty > /dev/null 2>&1")
        
        begin
          # Try to get size from the controlling terminal first
          output = `stty size < /dev/tty 2>/dev/null`.strip
          parts = output.split
          
          if parts.size == 2
            height = parts[0].to_i?
            width = parts[1].to_i?
            
            if width && height && width > 0 && height > 0
              return {width: width, height: height}
            end
          end
          
          # Fallback to regular stty
          output = `stty size 2>/dev/null`.strip
          parts = output.split
          
          if parts.size == 2
            height = parts[0].to_i?
            width = parts[1].to_i?
            
            if width && height && width > 0 && height > 0
              {width: width, height: height}
            else
              nil
            end
          else
            nil
          end
        rescue
          nil
        end
      end
    end
  end
end