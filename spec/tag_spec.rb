require 'elements'
RSpec.describe Tag do
  context 'simple tag' do
    before(:each) do
      @t = described_class.new('hr')
    end

    it 'creates a basic element' do
      expect(@t.to_s).to eql("<hr>\n")
    end

    it 'adds string attributes' do
      @t.add_attributes class: 'stumpy'

      expect(@t.attributes).to eql(class: ['stumpy'])
    end

    it 'adds array attributes' do
      @t.add_attributes class: ['stumpy']

      expect(@t.attributes).to eql(class: ['stumpy'])
    end
  end

  context 'tag with attributes' do
    before(:each) do
      @t = described_class.new(
        'img', attributes: { src: 'angry-baby.jpg', class: 'stumpy' }
      )
    end

    it 'inits a tag with attributes' do
      t = described_class.new 'hr', attributes: { class: 'stumpy' }

      expect(t.attributes).to eql(class: ['stumpy'])
    end

    it 'appends values to existing attributes' do
      @t.add_attributes class: 'wiley'

      expect(@t.attributes[:class]).to eql(%w[stumpy wiley])
    end

    it 'resets attributes' do
      @t.reset_attributes

      expect(@t.attributes).to eql({})
    end

    it 'rewrites attributes' do
      @t.reset_attributes(class: 'mopey')

      expect(@t.attributes).to eql(class: ['mopey'])
    end

    it 'adds a parent' do
      d = @t.add_parent TagPair.new 'div'

      expect(d.content).to eql([@t])
    end

    it 'returns array' do
      expect(@t.to_a).to eql(['<img src="angry-baby.jpg" class="stumpy">'])
    end

    it 'renders complex tag' do
      @t.add_attributes class: 'wiley mopey', id: 'frumpy'

      expect(@t.to_s).to eql(
        "<img src=\"angry-baby.jpg\" class=\"stumpy wiley mopey\" id=\"frumpy\">\n"
      )
    end

    # Ensure things aren't persisting that shouldn't.
    it 'renders consistently' do
      t = described_class.new 'img', attributes: { src: 'angry-baby.jpg' }
      t.add_attributes class: 'stumpy mopey', id: 'frumpy'
      initial = t.to_s
      10.times { t.to_s }

      expect(t.to_s).to eql(initial)
    end
  end
end
