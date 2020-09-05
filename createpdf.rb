#!/usr/bin/env ruby

require 'prawn'
require 'rqrcode'

def generate infile, outfile
  codes = File.open(infile) { |f| f.each_line.map(&:chomp) }

  pngs = codes.map { |code|
    qr = RQRCode::QRCode.new(code, level: :h)
    qr.as_png(
      bit_depth: 1,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white'
    ).to_s
  }

  Prawn::Document.generate(outfile, margin: [21, 6]) do
    # Maximum 80 QR codes on the page.
    # 8 QR codes per row. 10 rows.
    pngs.first(80).each_slice(8).each_with_index { |pngrow, row|
      pngrow.each_with_index { |png, col|
        # Each QR code is 75x75 PDF points, leaving 12 points for horizontal
        # margins and 42 points for vertical margins on a 8.5x11 inch page.
        image(
          StringIO.new(png),
          at: [col * 75, bounds.height - row * 75],
          fit: [75, 75]
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
  warn "Usage: #{$0} codes.txt outfile.pdf"
  exit 1
end

infile = ARGV.shift
outfile = ARGV.shift

generate(infile, outfile)

__END__
