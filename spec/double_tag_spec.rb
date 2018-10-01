require 'elements'
RSpec.describe TagPair do
  context 'no content' do
    before(:each) do
      @t = TagPair.new('p', attributes: { class: 'awesome' })
    end

    it 'renders multiline' do
      expect(@t.to_s).to eql(
        "<p class=\"awesome\">\n</p>\n"
      )
    end

    it 'renders oneline' do
      @t.oneline = true
      expect(@t.to_s).to eql(
        "<p class=\"awesome\"></p>\n"
      )
    end

    it 'returns array' do
      expect(@t.to_a).to eql(['<p class="awesome">', '</p>'])
    end

    it 'adds content' do
      @t.add_content 'hello'

      expect(@t.content).to eql(['hello'])
    end
  end

  context 'with content' do
    before(:each) do
      @content = [
        TagPair.new('p'),
        Tag.new('hr'),
        'example text'
      ]

      @t = TagPair.new 'div', content: @content

      # Indentation, for convenience:
      @i = "\ \ "
    end
    it 'returns string' do
      expect(@t.to_s).to eql(
        "<div>\n#{@i}<p>\n#{@i}</p>\n#{@i}<hr>\n#{@i}example text\n</div>\n"
      )
    end

    it 'returns array' do
      expect(@t.to_a).to eql(
        ['<div>', "#{@i}<p>", "#{@i}</p>", "#{@i}<hr>", "#{@i}example text", '</div>']
      )
    end

    it 'adds content as a string' do
      @t.add_content 'number two'

      expect(@t.content).to eql(@content + ['number two'])
    end

    it 'adds content as an array' do
      @t.add_content ['number two']

      expect(@t.content).to eql(@content + ['number two'])
    end

    it 'resets content' do
      @t.reset_content

      expect(@t.content).to eql([])
    end

    it 'overwrites content' do
      @t.reset_content('new text')

      expect(@t.content).to eql(['new text'])
    end

    it 'indents multiple levels correctly' do
      q = @t.add_parent TagPair.new 'main'

      expect(q.to_s).to eql(
        "<main>\n#{@i}<div>\n#{@i * 2}<p>\n#{@i * 2}"\
        "</p>\n#{@i * 2}<hr>\n#{@i * 2}example text\n"\
        "#{@i}</div>\n</main>\n"
      )
    end

    it 'renders consistently' do
      initial = @t.to_s
      10.times { @t.to_s }
      expect(@t.to_s).to eql(initial)
    end
  end
end
