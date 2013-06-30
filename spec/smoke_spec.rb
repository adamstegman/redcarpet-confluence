require 'spec_helper'
require 'redcarpet/confluence'

describe 'Smoke Tests' do
  let(:markdown_options) { {
    autolink: true,
    fenced_code_blocks: true,
    no_intra_emphasis: true,
    strikethrough: true,
    superscript: true,
    tables: true
  } }
  let(:renderer) { Redcarpet::Markdown.new(Redcarpet::Confluence, markdown_options) }
  let(:markdown_text) { File.read(File.expand_path('../sample.md', __FILE__)).force_encoding('UTF-8') }
  let(:confluence_text) { File.read(File.expand_path('../sample.confluence', __FILE__)).force_encoding('UTF-8') }

  it 'renders the markdown into confluence correctly' do
    expect(renderer.render(markdown_text)).to eq(confluence_text)
  end
end
