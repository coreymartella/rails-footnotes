require 'rails-footnotes/notes/log_note'
module Footnotes
  module Notes
    class LayoutNote < LogNote
      def initialize(controller)
        super
        @controller = controller
      end

      def row
        :edit
      end
      
      def title
        "Layout"
      end
      
      def link
        escape(Footnotes::Filter.prefix(filename, 1, 1))
      end

      def valid?
        prefix? && filename.present?
      end

      protected
        def filename
          @filename ||= begin
            yell "detecting filename from log: #{log}"
            full_filename = nil
            log.split("\n").each do |line|
              next if line !~ /Rendered \S*\s*within\s*(\S*)/
              
              file = line[/Rendered \S*\s*within\s*(\S*)/, 1]
              yell "got file: #{file}"
              @controller.view_paths.each do |view_path|
                path = File.join(view_path.to_s, "#{file}*")
                full_filename ||= Dir.glob(path).first
              end
              yell "after viewpaths: #{full_filename}"
            end
            full_filename
          end
        end
    end
  end
end
