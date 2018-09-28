# Non-Self-Closing tag. Can have content, but doesn't have to.
class TagPair < Tag
  attr_accessor :content
  # content is an array of anything. Entries will be inserted sequentially in
  # between the opening and closing tags.

  def initialize(element, attributes: nil, newline: true, content: [])
    reset_content(content)
    super(element, attributes: attributes, newline: newline)
  end

  # Replaces existing content with supplied argument.
  def reset_content(new)
    @content = []
    add_content(new)
  end

  def add_content(addition)
    @content << addition
    @content.flatten!
    self
  end

  def multiline
    content.any? { |c| c.to_s.include? "\n" } || content.join('').length > 60
  end

  def newline
    super || multiline
  end

  def stringify_content
    if multiline
      # TODO: Fix this. Currently doesn't handle inline elements well.
      ("\n  " + content.join("\n  ") + "\n")
    else
      content.join
    end
  end

  def to_s
    super { stringify_content + "</#{element}>" }
  end
end
