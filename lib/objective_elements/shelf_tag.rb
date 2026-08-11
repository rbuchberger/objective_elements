# frozen_string_literal: true

# This is a nonexistent HTML tag, which holds content like a double tag but has
# no opening or closing tag. This allows us to group siblings without adding an
# extra parent to the markup.
class ShelfTag < DoubleTag
  # A shelf has no element of its own, so it never renders an opening tag.
  def initialize(content: nil, oneline: false)
    super(nil, content: content, oneline: oneline)
  end

  def to_a
    content.map { |c| build_content_line c }.flatten
  end

  def add_parent(parent)
    parent.add_content content
  end
end
