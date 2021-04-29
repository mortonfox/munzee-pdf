#!/usr/bin/env ruby

# frozen_string_literal: true

require 'prawn'
require 'prawn-svg'
require 'rqrcode'

def generate(infile, outfile)
  codes = File.open(infile) { |f| f.each_line.map(&:chomp) }

  qrimages = codes.first(80).map { |code|
    RQRCode::QRCode.new(code, level: :m).as_svg
  }

  Prawn::Document.generate(outfile, margin: [21, 6]) do
    # Maximum 80 QR codes on the page.
    # 8 QR codes per row. 10 rows.
    qrimages.each_slice(8).each_with_index { |imgrow, row|
      imgrow.each_with_index { |img, col|
        # In a PDF, one inch on the page is 72 points. Coordinates start from
        # (0,0) at the bottom left of the page. The first coordinate increases
        # as we go from left to right and the second increases as we go from
        # bottom to top.
        # Each QR code is within a box of size 75x75 points, leaving 12 points
        # for horizontal margins and 42 points for vertical margins on a
        # 8.5x11 inch page. Within the box, we shrink the QR code so there is
        # a 5-point border around the QR code.
        svg(
          img,
          at: [col * 75 + 5, bounds.height - row * 75 - 5],
          width: 65, height: 65
        )
      }
    }

    # Draw cutting lines.
    stroke_color('9f9f9f')
    stroke do
      (0..8).each { |col|
        vertical_line(0, 10 * 75, at: col * 75)
      }
      (0..10).each { |row|
        horizontal_line(0, 8 * 75, at: row * 75)
      }
    end
  end
end

if ARGV.size < 2
  warn "Usage: #{$PROGRAM_NAME} codes.txt outfile.pdf"
  exit 1
end

infile = ARGV.shift
outfile = ARGV.shift

generate(infile, outfile)

__END__
