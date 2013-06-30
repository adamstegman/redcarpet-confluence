# RedcarpetConfluence

A Redcarpet renderer to convert Markdown to Confluence syntax.

Assumes text is UTF-8. 

## Usage

Call `md2conf` with the Markdown text to convert. Alternatively, pipe the text to `md2conf`.

    md2conf README.md
    cat README.md | md2conf

If you're on a Mac, pipe the output to `pbcopy` so you can paste it directly into Confluence.

    md2conf README.md | pbcopy

### From code

Create a Markdown parser with the Confluence renderer.

    markdown = Redcarpet::Markdown.new(Redcarpet::Confluence)
    puts markdown.render(markdown_text)

## Installation

Add this line to your application's Gemfile:

    gem 'redcarpet-confluence'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redcarpet-confluence

and require it as:

    require 'redcarpet/confluence'
