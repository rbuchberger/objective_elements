require 'objective_elements'
RSpec.describe SingleTag do
  context 'simple tag' do
    before(:each) do
      @t = described_class.new('hr')
    end

    it 'creates a basic element' do
      expect(@t.to_s).to eql("<hr>\n")
    end

    it 'adds string attributes' do
      @t.add_attributes 'class="stumpy"'

      expect(@t.attributes).to eql(class: ['stumpy'])
    end

    it 'adds hash with string attributes' do
      @t.add_attributes class: 'stumpy'

      expect(@t.attributes).to eql(class: ['stumpy'])
    end

    it 'adds hash with array attributes' do
      @t.add_attributes class: ['stumpy']

      expect(@t.attributes).to eql(class: ['stumpy'])
    end

    it "doesn't break when nil attributes are added" do
      @t.add_attributes nil

      expect(@t.attributes).to eql({})
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

      expect(t.attributes).to eql(class: ['stumpy'])
    end

    it 'appends values to existing attributes' do
      @t.add_attributes class: 'wiley'

      expect(@t.attributes[:class]).to eql(%w[stumpy wiley])
    end

    it 'resets all attributes' do
      @t.reset_attributes

      expect(@t.attributes).to eql({})
    end

    it 'adds new attributes after reset' do
      @t.reset_attributes(class: 'mopey')

      expect(@t.attributes).to eql(class: ['mopey'])
    end

    it 'replaces single attributes' do
      @t.rewrite_attribute class: 'new hotness'

      expect(@t.attributes).to eql(
        class: %w[new hotness], src: ['angry-baby.jpg']
      )
    end

    it 'deletes a single string attribute' do
      @t.delete_attribute 'class'

      expect(@t.attributes).to eql(src: ['angry-baby.jpg'])
    end

    it 'deletes array attributes' do
      @t.delete_attributes %i[class src]

      expect(@t.attributes).to eql({})
    end

    it 'adds a parent' do
      d = @t.add_parent DoubleTag.new 'div'

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
