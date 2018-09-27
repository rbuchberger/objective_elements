# Non-Self-Closing tag. Can have children, but doesn't have to.
class ParentTag < Tag
  attr_reader :children
  # children are an array of anything which answers to_s. They will be
  # inserted sequentially in between the opening and closing tags.

  def initialize(type, attributes: {}, newline: true, children: [])
    reset_children
    add_children(children)
    super(type, attributes: attributes, newline: newline)
  end

  def reset_children
    @children = []
  end

  def add_children(addition)
    @children << addition
    @children.flatten!
    raise 'At least one invalid child' unless @children.all?.respond_to? :to_s

    self
  end

  def stringify_children
    if children.any?
      content = children.inject { |output, child| output << child.to_s }
      if (content.length > 80) || (content.include? "\n")
        self.newline = true
        "\n\ \ " + content + "\n"
      end
      content
    else
      ''
    end
  end

  def to_s
    super do
      output = stringify_children
      output << "</#{type}>"
    end
  end
end
