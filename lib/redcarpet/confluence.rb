# coding: UTF-8

require 'redcarpet'

module Redcarpet
  # Public: A Redcarpet renderer to convert Markdown to Confluence syntax.
  class Confluence < Redcarpet::Render::Base
  
    # Internal: Languages supported by the code macro.
    CODE_MACRO_LANGUAGES = %w(
      actionscript actionscript3 bash csharp coldfusion cpp css delphi diff erlang groovy html java javafx javascript
      perl php powershell python ruby scala sql vb xhtml xml
    )
    # Internal: List item delimiters used by Confluence.
    LIST_ITEM_DELIMITER = %w( # * )
    # Internal: Reserved character sequences in Confluence that need to be escaped when not intended to be used.
    RESERVED_SEQUENCES = %w( { } [ ] - + * _ ^ ~ ?? bq. )
  
    def block_code(code, language)
      supported_language = CODE_MACRO_LANGUAGES.find { |lang| lang == language }
      macro(:code, code, lang: supported_language || :none)
    end
  
    def block_quote(text)
      macro(:quote, text)
    end
  
    def codespan(code)
      "{{#{escape_reserved_sequences(code)}}}"
    end
  
    def double_emphasis(text)
      "*#{text}*"
    end
  
    def emphasis(text)
      "_#{text}_"
    end
  
    def header(title, level)
      "\n\nh#{level}. #{title}"
    end
  
    def hrule
      "\n\n----"
    end
  
    def image(link, title, alt)
      "!#{link}#{args_string(alt: escape_reserved_sequences(alt), title: escape_reserved_sequences(title))}!"
    end
  
    def linebreak
      "\n"
    end
  
    def link(link, title, content)
      link = "[#{content}|#{link}]"
      link.insert(-2, "|#{escape_reserved_sequences(title)}") if title && !title.empty?
      link
    end
  
    def list(content, list_type)
      nested_list_prefix_regexp = /\n\n(?<matched_list_item_delimiter>#{LIST_ITEM_DELIMITER.map { |c| Regexp.escape(c) }.join('|')})/
      nested_list_content = content.gsub(nested_list_prefix_regexp, '\k<matched_list_item_delimiter>')
      "\n\n#{nested_list_content}"
    end
  
    def list_item(content, list_type)
      list_item_delimiter_regexp = /\n(?<matched_list_item_delimiter>#{LIST_ITEM_DELIMITER.map { |c| Regexp.escape(c) }.join('|')})/
      list_item_delimiter = nil
      case list_type
      when :ordered
        list_item_delimiter = '#'
      when :unordered
        list_item_delimiter = '*'
      end
      "#{list_item_delimiter} #{content.gsub(list_item_delimiter_regexp, "\n#{list_item_delimiter}\\k<matched_list_item_delimiter>")}"
    end
  
    def normal_text(text)
      escape_reserved_sequences(text)
    end
  
    def paragraph(text)
      "\n\n#{text}"
    end
  
    def strikethrough(text)
      "-#{text}-"
    end
  
    def superscript(text)
      " ^#{text}^ "
    end
  
    def table(header, body)
      "\n#{header.gsub('|', '||')}#{body}"
    end
  
    def table_row(text)
      "\n|#{text}"
    end
  
    def table_cell(text, align)
      "#{text}|"
    end
  
    def triple_emphasis(text)
      "_*#{text}*_"
    end
  
    private
  
    # Internal: Backslash-escapes all Confluence-reserved character sequences.
    #
    # Returns a copy of the text with all Confluence-reserved character sequences escaped with a backslash.
    def escape_reserved_sequences(text)
      reserved_sequences_regexp = /(?<reserved_sequence>#{RESERVED_SEQUENCES.map { |c| Regexp.escape(c) }.join('|')})/
      text ? text.gsub(reserved_sequences_regexp, '\\\\\k<reserved_sequence>') : text
    end
  
    # Internal: Wraps content in the named macro.
    #
    # name - The name of the macro to use.
    # content - The content to go between the macro tags. Nil will act the same as the empty string.
    # args - Optional Hash of arguments to pass to the macro.
    #
    # Returns a string with the given content wrapped in the named macro.
    def macro(name, content, args = {})
      # separate the macro name from the argument list with a colon
      arguments = args_string(args).sub('|', ':')
      "\n\n{#{name}#{arguments}}#{content}{#{name}}"
    end
  
    # Internal: Creates an argument String meant for a macro.
    #
    # Arguments are key-value pairs preceded by and separated by a pipe ('|').
    #
    # Returns the argument String
    def args_string(args)
      # format macro arguments string
      args_string = ''
      args.each do |arg, value|
        args_string << "|#{arg}=#{value}" if value && !value.empty?
      end
      args_string
    end
  end
end
