require 'argus/float_encoding'

module Argus

  module CFields
    include FloatEncoding

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def initialize(*args)
      super
      @data = unpack_data(args.first)
    end

    def unpack_data(data)
      @data = data.unpack(self.class.format_string)
    end

    module ClassMethods
      def data_index
        @data_index ||= 0
      end

      def format_string
        @format_string ||= "x4"
      end

      def allot(n=1)
        result = data_index
        @data_index += n
        result
      end

      def define_field(name, size, format, width=1, &transform)
        if size
          index = allot(width*size)
          format_string << "#{format}#{width*size}"
          if transform
            define_method(name) { @data[index, size].map(&transform) }
          else
            define_method(name) { @data[index, size] }
          end
        else
          index = allot(width)
          format_string << (width==1 ? format : "#{format}#{width}")
          if transform
            define_method(name) { transform.call(@data[index]) }
          else
            define_method(name) { @data[index] }
          end
        end
      end

      def uint32_t(name, size=nil)
        define_field(name, size, "V")
      end

      def uint16_t(name, size=nil)
        define_field(name, size, "v")
      end

      def float32_t(name, size=nil)
        define_field(name, size, "V") { |v| FloatEncoding.decode_float(v) }
      end

      def int32_t(name, size=nil)
        define_field(name, size, "l<")
      end

      def matrix33_t(name, size=nil)
        define_field(name, size, "V", 9) { |v| nil }
      end

      def vector31_t(name, size=nil)
        define_field(name, size, "V", 3) { |v| nil }
      end
    end
  end

end
