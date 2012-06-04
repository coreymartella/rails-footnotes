module Footnotes
  module Notes
    class EnvNote < AbstractNote
      def initialize(controller)
        @env = controller.request.env.dup
      end

      def content
        env_data = @env.to_a.sort_by{|k,v| k.to_s}.unshift([:key, :value]).map do |k,v|
          case k
          when 'HTTP_COOKIE'
            # Replace HTTP_COOKIE for a link
            [k, '<a href="#" style="color:#009" onclick="Footnotes.hideAllAndToggle(\'cookies_debug_info\');return false;">See cookies on its tab</a>']
          else
            [k, escape(v.to_s)]
          end
        end

        # Create the env table
        mount_table(env_data)
      end
    end
  end
end
