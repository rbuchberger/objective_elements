# Non-Self-Closing tag. Can have content, but doesn't have to.
class DoubleTag < SingleTag
  attr_accessor :oneline
  attr_reader :content

  # Content represents everything between the opening and closing tags.

  def initialize(element, attributes: nil, content: nil, oneline: false)
    @oneline = oneline
    self.content = content
    super(element, attributes: attributes)
  end

  def content=(new)
    reset_content
    add_content(new)
  end

  def reset_content
    @content = []
  end

  def add_content(addition)
    @content << addition if addition
    @content.flatten!
    self
  end
  alias << add_content

  def to_a
    lines = content.map { |c| build_content_line c }
    lines = lines.flatten.map { |l| l.prepend oneline ? '' : indent }
    lines.unshift(opening_tag).push(closing_tag)
  end

  def to_s
    to_a.join(oneline ? '' : "\n") + "\n"
  end

  private

  def build_content_line(element)
    # Since DoubleTag inherits from SingleTag, it will slurp up those too.
    element.is_a?(SingleTag) ? element.to_a : element.to_s.dup
  end

  def indent
    "\ \ "
  end

  def closing_tag
    "</#{element}>"
  end
end
