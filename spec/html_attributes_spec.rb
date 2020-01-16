require 'objective_elements'
RSpec.describe HTMLAttributes do
  context 'single attribute' do
    before(:each) do
      @t = described_class.new 'class="stumpy"'
    end

    it 'adds string attributes' do
      @t << 'class="killer"'

      expect(@t.to_s).to eql('class="stumpy killer"')
    end

    it 'adds hash with string attributes' do
      @t << { id: 'killer' }

      expect(@t.to_s).to eql('class="stumpy" id="killer"')
    end

    it 'adds hash with array attributes' do
      @t << { class: ['killer'] }
      expect(@t.to_s).to eql('class="stumpy killer"')
    end

    it "doesn't break when nil attributes are added" do
      @t << nil

      expect(@t.to_s).to eql('class="stumpy"')
    end

    it 'responds to method_missing getter' do
      @t << 'id="killer"'
      expect(@t.id).to eql('killer')
    end

    it 'responds to method_missing setter' do
      @t.id = 'killer'

      expect(@t.id).to eql('killer')
    end
  end

  context 'multiple attributes' do
    before(:each) do
      @t = described_class.new(
        src: 'angry-baby.jpg', class: 'stumpy'
      )
    end

    it 'replaces single attributes as a hash' do
      @t.replace class: 'new hotness'

      expect(@t.to_s).to eql(
        'src="angry-baby.jpg" class="new hotness"'
      )
    end

    it 'handles duplicate attribute keys' do
      @t << 'class="new" class="hotness"'

      expect(@t.to_s).to eql(
        'src="angry-baby.jpg" class="stumpy new hotness"'
      )
    end

    it 'replaces single attributes as a string' do
      @t.replace 'class="new hotness"'

      expect(@t.to_s).to eql(
        'src="angry-baby.jpg" class="new hotness"'
      )
    end

    it 'deletes a single string attribute' do
      @t.delete 'class'

      expect(@t.to_s).to eql('src="angry-baby.jpg"')
    end

    it 'deletes array attributes' do
      @t.delete %i[class src]

      expect(@t.to_s).to eql('')
    end

    it 'handles empty attributes' do
      @t << 'alt=""'

      expect(@t.to_s).to eql('src="angry-baby.jpg" class="stumpy" alt=""')
    end

    it 'handles additions to empty attributes' do
      @t << 'alt=""'
      @t << 'alt="alt text"'

      expect(@t.to_s).to eql(
        'src="angry-baby.jpg" class="stumpy" alt="alt text"'
      )
    end
  end
end
