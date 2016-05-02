module Rbtube
  class JSInterpreter
    def initialize(code)
      @code = code
      @_functions = {}
      @_objects = {}
    end

    def interpret_statement
      # TODO: inplement this
    end

    def interpret_expression
      # TODO: inplement this
    end

    def extract_object
      # TODO: inplement this
    end

    def extract_function(funcname)
      # TODO: inplement this
      lambda do |*args|
        # TODO: inplement this
      end
    end

    def call_function
      # TODO: inplement this
    end

    def build_function
      # TODO: inplement this
    end
  end
end
