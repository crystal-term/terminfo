{% if flag?(:windows) %}
lib LibC
  INVALID_HANDLE_VALUE = -1_i64
  STD_OUTPUT_HANDLE = -11_i32
  STD_ERROR_HANDLE = -12_i32

  struct COORD
    x : Int16
    y : Int16
  end

  struct SMALL_RECT
    left : Int16
    top : Int16
    right : Int16
    bottom : Int16
  end

  struct CONSOLE_SCREEN_BUFFER_INFO
    dwSize : COORD
    dwCursorPosition : COORD
    wAttributes : UInt16
    srWindow : SMALL_RECT
    dwMaximumWindowSize : COORD
  end

  fun GetStdHandle(nStdHandle : Int32) : Void*
  fun GetConsoleScreenBufferInfo(hConsoleOutput : Void*, lpConsoleScreenBufferInfo : CONSOLE_SCREEN_BUFFER_INFO*) : Int32
end

module Term
  module Terminfo
    module Windows
      module Console
        extend self

        def get_size(handle = :stdout)
          handle_const = case handle
                        when :stdout then LibC::STD_OUTPUT_HANDLE
                        when :stderr then LibC::STD_ERROR_HANDLE
                        else LibC::STD_OUTPUT_HANDLE
                        end

          h = LibC.GetStdHandle(handle_const)
          return nil if h == Pointer(Void).new(LibC::INVALID_HANDLE_VALUE)

          csbi = LibC::CONSOLE_SCREEN_BUFFER_INFO.new
          result = LibC.GetConsoleScreenBufferInfo(h, pointerof(csbi))
          return nil if result == 0

          width = csbi.srWindow.right - csbi.srWindow.left + 1
          height = csbi.srWindow.bottom - csbi.srWindow.top + 1

          {width: width.to_i32, height: height.to_i32}
        end
      end
    end
  end
end
{% end %}