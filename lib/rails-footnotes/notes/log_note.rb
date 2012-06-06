module Footnotes
  module Notes
    class LogNote < AbstractNote
      @@log = []

      def self.log(message)
        @@log << message
      end
      def self.clear_log
        @@log = []
      end
      def initialize(controller)
        @controller = controller
      end

      def title
        "Log (#{log.count("\n")})"
      end

      def content
        escape(log.gsub(/\e\[.+?m/, '')).gsub("\n", '<br />')
      end

      def log
        unless @log
          @log = @@log.join("")
          if rindex = @log.rindex('Processing '+@controller.class.name+'#'+@controller.action_name)
            @log = @log[rindex..-1]
          end
        end
        @log
      end

      module LoggingExtensions
        def add(*args, &block)
          super
          logged_message = args.last
          Footnotes::Notes::LogNote.log(logged_message.to_s.strip + "\n")
          logged_message
        end
      end

      Rails.logger.extend LoggingExtensions
    end
  end
end

