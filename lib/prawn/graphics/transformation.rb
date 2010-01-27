# encoding: utf-8
#
# transformation.rb: Implements rotate, translate, skew, scale and a generic
#                     transformation_matrix 
#
# Copyright January 2010, Michael Witrant. All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
#

module Prawn
  module Graphics
    module Transformation
      
      # Rotate the user space around point (0, 0)
      #
      # Note that if a block is not passed, then you must save and restore the
      # graphics state yourself
      #
      # Example without a block:
      #   
      #   save_graphics_state
      #   rotate 30
      #   text "rotated text"
      #   restore_graphics_state
      #
      # Example with a block: drawing a rectangle with its upper-left corner at
      #                       point x, y that is rotated around its upper-left
      #                       corner
      #
      #   x = 300
      #   y = 300
      #   width = 150
      #   height = 200
      #   angle = 30
      #   pdf.translate(x, y) do
      #     pdf.rotate(angle) do
      #       pdf.stroke_rectangle([0, 0], width, height)
      #     end
      #   end
      #
      def rotate(angle, &block)
        rad = degree_to_rad(angle)
        cos = Math.cos(rad)
        sin = Math.sin(rad)
        transformation_matrix(cos, sin, -sin, cos, 0, 0, &block)
      end

      # Translate the user space (see notes for rotate regarding graphics state)
      def translate(x, y, &block)
        transformation_matrix(1, 0, 0, 1, x, y, &block)
      end
      
      # Scale the user space (see notes for rotate regarding graphics state)
      def scale(factor, &block)
        transformation_matrix(factor, 0, 0, factor, 0, 0, &block)
      end
      
      # Skew the user space (see notes for rotate regarding graphics state)
      def skew(a, b, &block)
        transformation_matrix(1, Math.tan(degree_to_rad(a)), Math.tan(degree_to_rad(b)), 1, 0, 0, &block)
      end
      
      # Transform the user space (see notes for rotate regarding graphics state)
      # Generally, one would use the rotate, scale, translate, and skew
      # convenience methods instead of calling transformation_matrix directly
      def transformation_matrix(a, b, c, d, e, f)
        values = [a, b, c, d, e, f].map { |x| "%.5f" % x }.join(" ")
        save_graphics_state if block_given?
        add_content "#{values} cm"
        if block_given?
          yield
          restore_graphics_state
        end
      end
      
    end
  end
end