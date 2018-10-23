require 'objective_elements'
RSpec.describe SingleTag do
  context 'simple tag' do
    before(:each) do
      @t = described_class.new('hr')
    end

    it 'creates a basic element' do
      expect(@t.to_s).to eql("<hr>\n")
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

      expect(t.to_s).to eql("<hr class=\"stumpy\">\n")
    end

    it 'resets all attributes' do
      @t.reset_attributes

      expect(@t.to_s).to eql("<img>\n")
    end

    it 'sets attributes with =' do
      @t.attributes = { class: 'mopey' }

      expect(@t.attributes.to_s).to eql('class="mopey"')
    end

    it 'adds a parent' do
      d = @t.add_parent DoubleTag.new 'div'

      expect(d.content).to eql([@t])
    end

    it 'returns array' do
      expect(@t.to_a).to eql(['<img src="angry-baby.jpg" class="stumpy">'])
    end

    it 'renders complex tag' do
      @t.attributes << { class: 'wiley mopey', id: 'frumpy' }

      expect(@t.to_s).to eql(
        '<img src="angry-baby.jpg" '\
        "class=\"stumpy wiley mopey\" id=\"frumpy\">\n"
      )
    end
  end
  # Ensure things aren't persisting that shouldn't.
  it 'renders consistently' do
    t = described_class.new 'img', attributes: { src: 'angry-baby.jpg' }
    t.attributes << { class: 'stumpy mopey', id: 'frumpy' }
    initial = t.to_s
    10.times { t.to_s }

    expect(t.to_s).to eql(initial)
  end
end
