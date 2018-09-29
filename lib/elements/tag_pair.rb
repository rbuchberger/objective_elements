# Non-Self-Closing tag. Can have content, but doesn't have to.
class TagPair < Tag
  attr_accessor :content, :oneline
  # content is an array of anything. Entries will be inserted sequentially in
  # between the opening and closing tags.

  def initialize(element, attributes: nil, content: [], oneline: false)
    @oneline = oneline
    reset_content(content)
    super(element, attributes: attributes)
  end

  def closing_tag
    "</#{element}>"
  end

  # Deletes all content, replaces with parameter (if supplied)
  def reset_content(new)
    @content = []
    add_content(new)
  end

  def add_content(addition)
    @content << addition
    @content.flatten!
    self
  end

  def to_a
    lines = content.map do |c|
      if c.is_a? Tag
        c.to_a
      else
        c.to_s.dup
      end
    end
    lines = lines.flatten.map { |l| l.prepend oneline ? '' : "\ \ " }
    lines.unshift(opening_tag).push(closing_tag)
  end

  def to_s
    to_a.join(oneline ? '' : "\n") + "\n"
  end
end
