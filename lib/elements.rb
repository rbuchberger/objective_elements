# require 'elements/version'

module Elements
  # Collection of HTML element tags
  class Element
    # Root Class, any basic HTML tag

    # attributes are a hash, with symbols as keys. The keys and values will be
    # rendered to key="value"

    # children are an array of either strings or Elements. They will be inserted
    # sequentially in between the opening and closing tags.

    # self_closing? determines whether or not to include a closing tag. If true,
    # there cannot be any children.

    # newline? determines whether or not to insert a line break after the
    # element.

    attr_reader :type, :children, :attributes, :self_closing, :newline
    alias self_closing? self_closing
    alias newline? newline

    def initialize(
      type,
      attributes: {},
      children: [],
      self_closing: false,
      newline: true
    )

      @type = type
      @attributes = attributes
      @children = children
      @self_closing = self_closing
      @newline = newline
      validate
    end

    def validate
      # attributes must be a hash of symbols
      raise 'attributes must be a hash' unless @attributes.is_a? Hash

      @attributes.transform_keys!(&:to_sym)

      # children must be an array
      raise 'children must be an array' unless @children.is_a? Array

      # If self closing, cannot have any children.
      if @self_closing && @children.any?
        raise 'Cannot be self closing and have children'
      end

      self
    end

    def children=(children)
      @children = children
      validate
    end

    def add_child(addition)
      @children << addition
      validate
    end

    def attributes=(attributes)
      @attributes = attributes
      validate
    end

    def self_closing=(boolean)
      @self_closing = boolean
      validate
      @self_closing
    end

    def self_close!
      @children = []
      @self_closing = true
    end

    def stringify_attributes
      # Turns attributes into a string we can inject
      attribute_string = ''
      @attributes.each_pair do |k, v|
        attribute_string += "#{k.to_s}=\"#{v}\" "
      end
      attribute_string.strip!
    end

    def stringify_children
      output = ''
      @children.each do |c|
        output << if c.is_a? Element
                    c.render
                  else
                    c.to_s
                  end
      end
      output
    end

    def render
      output =  '<' + @type
      output << ' ' + stringify_attributes unless @attributes.empty?
      output << '>'
      output << stringify_children if @children
      output << "</#{@type}>" unless self_closing?
      output << "\n" if newline?
    end

    def add_parent(parent)
      parent.add_child(self)
    end
  end
end
