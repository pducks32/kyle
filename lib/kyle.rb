require "kyle/version"

module Kyle

  def self.interpret(args)
    interpreter.call(args)
  end

  def self.interpreter
    @interpreter ||= Interpreter.new
  end

  class Interpreter
    def call(args)
      command = args.join(" ")
      responder = resolve_multiple_responders responders_that_handle(command)
      call_responder(responder, command)
    end

    def responders_that_handle(command)
      responders.select { |r| r.can_handle?(command) }
    end

    def resolve_multiple_responders(possible_responders)
      case possible_responders.length
      when 0 then handle_no_responders
      when 1 then possible_responders[0]
      else
        handle_multiple_responders(possible_responders)
      end
    end

    def handle_no_responders
      puts "Sorry"
      exit(1)
    end

    def call_responder(responder, command)
      responder.call(command)
    end

    def responders
      @responders ||= []
    end

    def add_responder(responder)
      responders << responder
    end
  end

  module Responder
    def self.extended(responder)
      Kyle.interpreter.add_responder responder
    end
  end

  module WhichCommand
    extend Responder

    def self.can_handle?(command)
      return false unless command.match(/which (.+)/)
      @@executable = $1
    end

    def self.call(command)
      puts `which #{@@executable}`.chomp
    end
  end
end
