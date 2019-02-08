require 'objective_elements'
RSpec.describe ShelfTag do
  before(:each) do
    content = [
      DoubleTag.new('p'),
      SingleTag.new('hr')
    ]

    @t = ShelfTag.new content: content
  end

  # it renders
  it 'renders' do
    expect(@t.to_s).to eql(
      "<p>\n</p>\n<hr>\n"
    )
  end

  # it adds a parent
  it 'adds parent' do
    parent = DoubleTag.new 'div'
    expect(@t.add_parent(parent).to_s).to eql(
      "<div>\n  <p>\n  </p>\n  <hr>\n</div>\n"
    )
  end
end
