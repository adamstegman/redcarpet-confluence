require 'spec_helper'
require 'redcarpet/confluence'

describe Redcarpet::Confluence do
  let(:renderer) { described_class.new }

  describe '#block_code(code, language)' do
    it 'wraps the code in a code macro for the given language' do
      expect(renderer.block_code("some normal freakin' code", 'java')).to(
        eq("\n\n{code:lang=java}some normal freakin' code{code}")
      )
    end

    it 'uses the "none" language when given an unsupported language' do
      expect(renderer.block_code('code', 'unsupported')).to eq("\n\n{code:lang=none}code{code}")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.block_code('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', 'java')).to(
        eq("\n\n{code:lang=java}bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??{code}")
      )
    end
  end

  describe '#block_quote(text)' do
    it 'wraps the text in a quote macro' do
      expect(renderer.block_quote("some normal freakin' text")).to(
        eq("\n\n{quote}some normal freakin' text{quote}")
      )
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.block_quote('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq("\n\n{quote}bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??{quote}")
      )
    end
  end

  describe '#codespan(code)' do
    it 'wraps the given code in double curly braces' do
      expect(renderer.codespan("some normal freakin' code")).to eq("{{some normal freakin' code}}")
    end

    it 'escapes Confluence text effects that should be added in other methods' do
      expect(renderer.codespan('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('{{\bq. \*some\* \_emphasized\_ \-text\- \+words\+\^like\^\~this\~ \{\{and this\}\} \??Stegman\??}}')
      )
    end
  end

  describe '#double_emphasis(text)' do
    it 'wraps the given text in asterisks' do
      expect(renderer.double_emphasis("some normal freakin' text")).to eq("*some normal freakin' text*")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.double_emphasis('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('*bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??*')
      )
    end
  end

  describe '#emphasis(text)' do
    it 'wraps the given text in underscores' do
      expect(renderer.emphasis("some normal freakin' text")).to eq("_some normal freakin' text_")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.emphasis('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('_bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??_')
      )
    end
  end

  describe '#header(title, level)' do
    it 'prepends the header level to the given text' do
      expect(renderer.header("some normal freakin' text", 5)).to eq("\n\nh5. some normal freakin' text")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.header('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', 5)).to(
        eq("\n\nh5. bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??")
      )
    end
  end

  describe '#hrule' do
    it 'returns four hyphens' do
      expect(renderer.hrule).to eq("\n\n----")
    end
  end

  describe '#image(link, title, alt)' do
    it 'wraps the link in exclamation points' do
      expect(renderer.image('http://google.com/', nil, nil)).to eq('!http://google.com/!')
    end

    it 'passes the title and alt text to the image macro' do
      expect(renderer.image('http://google.com/', 'title', 'alt text')).to(
        eq('!http://google.com/|alt=alt text|title=title!')
      )
    end

    it 'escapes Confluence text effects that should be added in other methods' do
      expect(renderer.image(
        'http://google.com/',
        'bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??',
        'bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??'
      )).to(
        eq('!http://google.com/|alt=\bq. \*some\* \_emphasized\_ \-text\- \+words\+\^like\^\~this\~ \{\{and this\}\} \??Stegman\??|title=\bq. \*some\* \_emphasized\_ \-text\- \+words\+\^like\^\~this\~ \{\{and this\}\} \??Stegman\??!')
      )
    end
  end

  describe '#linebreak' do
    it 'returns a newline' do
      expect(renderer.linebreak).to eq("\n")
    end
  end

  describe '#link(link, title, content)' do
    it 'wraps the link and content in brackets' do
      expect(renderer.link('http://google.com/', nil, 'my link')).to eq('[my link|http://google.com/]')
    end

    it 'does not include the title when empty' do
      expect(renderer.link('http://google.com/', '', 'my link')).to eq('[my link|http://google.com/]')
    end

    it 'includes the title when given' do
      expect(renderer.link('http://google.com/', 'some title', 'my link')).to(
        eq('[my link|http://google.com/|some title]')
      )
    end

    it 'escapes Confluence text effects in the title' do
      expect(renderer.link('http://google.com/', 'bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', 'bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('[bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|http://google.com/|\bq. \*some\* \_emphasized\_ \-text\- \+words\+\^like\^\~this\~ \{\{and this\}\} \??Stegman\??]')
      )
    end
  end

  describe '#list(content, list_type)' do
    it 'returns the given content' do
      expect(renderer.list('* content', :whatever)).to eq("\n\n* content")
    end

    it 'returns a nested list' do
      expect(renderer.list("* content\n\n\n*# nested content\n* more content\n\n\n*# more nested", :whatever)).to eq("\n\n* content\n*# nested content\n* more content\n*# more nested")
    end
  end

  describe '#list_item(content, list_type)' do
    context 'given an ordered list_type' do
      it 'prepends an octothorpe to the content' do
        expect(renderer.list_item('content', :ordered)).to eq("# content")
      end

      it 'prepends an octothorpe to each existing list item in the content' do
        expect(renderer.list_item("content\n* nested content\n* more nested", :ordered)).to eq("# content\n#* nested content\n#* more nested")
      end

      it 'does not escape Confluence text effects' do
        expect(renderer.list_item('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', :ordered)).to(
          eq('# bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')
        )
      end
    end

    context 'given an unordered list type' do
      it 'prepends an asterisk to the content' do
        expect(renderer.list_item('content', :unordered)).to eq("* content")
      end

      it 'prepends an asterisk to each existing list item in the content' do
        expect(renderer.list_item("content\n# nested content", :unordered)).to eq("* content\n*# nested content")
      end

      it 'does not escape Confluence text effects' do
        expect(renderer.list_item('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', :unordered)).to(
          eq('* bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')
        )
      end
    end
  end

  describe '#normal_text(text)' do
    it 'does not modify normal text' do
      expect(renderer.normal_text("some normal freakin' text")).to eq("some normal freakin' text")
    end

    it 'escapes Confluence text effects that should be added in other methods' do
      expect(renderer.normal_text('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('\bq. \*some\* \_emphasized\_ \-text\- \+words\+\^like\^\~this\~ \{\{and this\}\} \??Stegman\??')
      )
    end
  end

  describe '#paragraph(text)' do
    it 'appends two newlines to normal text' do
      expect(renderer.paragraph("some normal freakin' text")).to eq("\n\nsome normal freakin' text")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.paragraph('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq("\n\nbq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??")
      )
    end
  end

  describe '#strikethrough(text)' do
    it 'wraps the given text in hyphens' do
      expect(renderer.strikethrough("some normal freakin' text")).to eq("-some normal freakin' text-")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.strikethrough('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('-bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??-')
      )
    end
  end

  describe '#superscript(text)' do
    it 'wraps the given text in hyphens' do
      expect(renderer.superscript("some normal freakin' text")).to eq(" ^some normal freakin' text^ ")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.superscript('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq(' ^bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??^ ')
      )
    end
  end

  describe '#table(header, body)' do
    it 'appends the body to the formatted header' do
      expect(renderer.table("\n|header|", "\n|body|")).to eq("\n\n||header||\n|body|")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.table(
        "\n|bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|",
        "\n|bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|"
      )).to(
        eq("\n\n||bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??||\n|bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|")
      )
    end
  end

  describe '#table_row(text)' do
    it 'prepends a pipe to the text' do
      expect(renderer.table_row('text|')).to eq("\n|text|")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.table_row('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|')).to(
        eq("\n|bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|")
      )
    end
  end

  describe '#table_cell(text, align)' do
    it 'appends a pipe to the text' do
      expect(renderer.table_cell('text', :ignored)).to eq('text|')
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.table_cell('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??', :ignored)).to(
        eq('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??|')
      )
    end
  end

  describe '#triple_emphasis(text)' do
    it 'wraps the given text in asterisks and underscores' do
      expect(renderer.triple_emphasis("some normal freakin' text")).to eq("_*some normal freakin' text*_")
    end

    it 'does not escape Confluence text effects' do
      expect(renderer.triple_emphasis('bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??')).to(
        eq('_*bq. *some* _emphasized_ -text- +words+^like^~this~ {{and this}} ??Stegman??*_')
      )
    end
  end
end
