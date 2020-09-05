# Munzee PDF

## Introduction

This is a Ruby script that takes a text file containing up to 80 QR code
values and generates a letter-sized PDF page with up to 10 rows and 8 columns
of QR code images. The main purpose of this script is to lay out up to 80
munzees on a page for printing.

## Installation

Run the following:

```sh
git clone git@github.com:mortonfox/munzee-pdf.git
cd munzee-pdf
bundle install
```

## Usage

To get the QR code values, it may be helpful to install the
[MunzeePrint](https://greasyfork.org/en/scripts/4751-munzeeprint) userscript.

Once you've done so, navigate to the [Munzee batch
print](https://www.munzee.com/print/) page. Filter and select the Munzees you
wish to print and click on "Get barcode values". Copy the QR code values and
save them to a text file.

Let's say you've saved the QR code values to codes.txt.

Then run the following to generate the PDF file:

```sh
bundle exec createpdf.rb codes.txt munzee.pdf
```

Then you can view and print munzee.pdf.
