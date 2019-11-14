# Objective Elements

This is a tiny gem that builds nicely formatted HTML using sane, readable Ruby. I use it for Jekyll
plugins, but you can use it anywhere. It's ~100 lines, tested with RSpec, and has no dependencies.

It doesn't actually know any HTML, just how to format it.

This is meant to be less involved and more flexible than nokogiri's XML/HTML generator. There's no
DSL to learn and no cleverness to wrap your mind around. Its specialty is taking fragmented,
disjointed information and condensing it into a string of properly formatted HTML. It's as agnostic
as possible on the input, while being extremely consistent with its output.

## Motivation:

Have you ever tried to build HTML with string concatenation and interpolation? It starts out simply
enough, but once you account for all the what-ifs, the indentation, the closing tags, and the spaces
you only need sometimes, it turns into a horrible mess.

The problem, of course, is that building long, complex, varying blocks of text with string
concatenation and interpolation is fragile, unreadable, and painful. You know this, but you're not
going to write an entirely new class or pull in some big new dependency just for 10 lines of HTML,
so instead you hammer through it and end up with code like this:

```ruby
picture_tag = "<picture>\n"\
              "#{source_tags}"\
              "#{markdown_escape * 4}"\
              "<img src=\"#{url}#{instance['source_default'][:generated_src]}\" "\
              "#{html_attr_string}>\n"\"#{markdown_escape * 2}</picture>\n"
```

or this:

```ruby
    def build_li(this_item_data, icon_location, label)
      li = "  <li#{@attributes['li']}>"
      if this_item_data && this_item_data['url']
        li << "<a href=\"#{this_item_data['url']}\"#{@attributes['a']}>"
      end
      li << build_image_tag(icon_location)
      li << label
      li << '</a>' if this_item_data['url']
      li << "</li>\n"
    end
```

## Demo

```ruby
p = DoubleTag.new 'p'
p.to_s
# <p>
# </p>

p.attributes << { class: 'stumpy grumpy', 'id' => 'the-ugly-one' }

p.id
# the-ugly-one

p.attributes << 'class="slimy" data-awesomeness="11"'


# Ruby method names can't have dashes.
p.attributes['data-awesomeness']
# '11'

p.id = 'killer'

p << "Icky"

p.to_s
# <p class="stumpy grumpy slimy" id="killer" data-awesomeness="11">
#   Icky
# </p>

p.oneline = true
p.to_s
# <p class="stumpy grumpy slimy" id="killer" data-awesomeness="11">Icky</p>
p.oneline = false

p.add_content DoubleTag.new(
  'a',
  content: 'Link!',
  attributes: { href: 'awesome-possum.com' },
  oneline: true
)

div = p.add_parent DoubleTag.new 'div'

"#{div}"
# <div>
#   <p class="stumpy grumpy slimy" id="killer" data-awesomeness="11">
#     Icky
#     <a href="awesome-possum.com">Link!</a>
#   </p>
# </div>

```

## Changes

### 1.1.1

Fix bug where duplicate attribute keys would overwrite each other's values, when passed at the same time.

### 1.1.0

Add `ShelfTag`, which is useful when you want to create siblings without a parent element.

### 1.0.0

Attributes syntax has changed pretty significantly. Find `.add_attributes` & replace `.attributes <<`
will get you most of the way there, but you should read over the usage section again.

## Installation

```ruby
# Gemfile

gem 'objective_elements', '~> 1.0.0'
```

```ruby
# Anywhere else:

require 'objective_elements'
```

## Terminology

```
<p class="stumpy">Hello</p>
|a|       b      |  c  | d |
```

- a - element
- b - attributes
- a+b - opening tag
- c - content
- d - closing tag

## Usage

For Attribute & SingleTag examples, we'll use this image tag:

```ruby

img = SingleTag.new 'img', attributes: 'src="angry-baby.jpg"'

```

There are 2 classes you care about: `SingleTag` is the base class, and `DoubleTag` inherits from it.
A `SingleTag` is a self-closing tag, meaning it has no content and no closing tag. A `DoubleTag` is
the other kind.

### Attributes

Attributes are their own class, and can be accessed by the `.attributes` method on both single and
double tags. Important methods:

`<< (attribute)`

- Example: `p.attributes << 'alt="he does not look happy"'`
- Example: `p.attributes << { alt: "he does not look happy" }`
- Add new attributes, can accept a hash or a string. Hash keys will be converted
  to symbols if they are not already, and values will be split on spaces into an array if they are not
  already. Attributes can also be given as a string in the standard HTML syntax (`class="myclass" id="my-id"`). **Every other method which adds attributes in some way, calls this method**. This
  means that any time you are adding attributes, you can use any format which this method understands.

`.delete(attribute)`

- Example: `img.attributes.delete 'src'`
- Example: `img.attributes.delete :src`
- Example: `img.attributes.delete [:src, 'alt']`
- Delete one or more attributes. Accepts a string, symbol, or an array of
  strings and/or symbols.

`.replace(attribute)`

- Example: `img.attributes.replace 'src="happy-baby.jpg"'`
- Replaces one or more attributes and values individually.

`.content[:attribute_name] =`

- Example: `img.attributes.content[:src] = 'dirty-baby.jpg'` < This just broke everything.
- Don't do it. Use `.replace`, `.(attribute name) =`, or `<<`

`.content[:attribute_name]`

- Example: `img.attributes[:src] # returns 'angry-baby.jpg`
- Retrieve the content for a given attribute, as an array of strings. Must be a symbol. You'll
- mostly need this when you don't know which attribute you need ahead of
  time, or to access class and method attributes because you can't use the methods below:

**There is a shorthand for the next two methods. Keep reading.**

`.(attribute_name)`

- Example: `img.attributes.src # 'angry-baby.jpg'`
- Convenience method/syntactic sugar: Returns the value of a given attribute name, as a
- space-separated string. This relies on method_missing, which means that any overlap with
  already existing methods won't work.
- **You can't access `class` or `method` html attributes this way, because
  basic objects in ruby already have those methods.**
- **Ruby methods can't have dashes in them.** This means `p.data-awesomeness` won't work.

`.(attribute_name) = value`

- Example: `img.attributes.src = 'happy-baby.jpg'`
- Same as above. Similar to `.replace(attribute)`. Interestingly, `method =` and `class =` both
  work (`.class` is defined on the basic object class, but `.class=` is not.). Still, you
  probably shouldn't use them.

**Missing methods are forwarded from elements to their attributes, so you can do this:**

- Example: `img.src # returns 'angry-baby.jpg'`
- Example: `img.src = 'grumpy-baby.jpg'`

### SingleTag Properties:

#### element

- String
- Mandatory
- Which type of tag, such as 'hr' or 'img'

#### attributes

- Instance of the class described above.

### SingleTag Methods (that you care about)

`SingleTag.new(element, attributes: nil)`

`.to_s`

- Example: `img.to_s`
- The big one. Returns your HTML as a string, nondestructively.

`.add_parent(DoubleTag)`

- Example: `img.add_parent DoubleTag.new 'picture'`
- returns supplied DoubleTag, with self added as a child.

`.attributes`

- Example: `img.attributes`
- attr_reader for HTML attributes. This is how you can access any attribute method
  described above.

`.reset_attributes`

- Example: `img.reset_attributes`
- Removes all attributes.

`.attributes=(new)`

- Example: `img.attributes = 'src="grumpy-baby.jpg" id="muddy"'`
- Equivalent to `reset_attributes` and `.attributes << new`

`attr_reader :attributes`
`attr_accessor :element`

### DoubleTag Properties:

#### `DoubleTag` Inherits all of `SingleTag`'s properties and methods, and adds content and a

closing tag.

#### content

- Array
- Optional
- Contains anything (but probably just strings and tags. Anything else will be turned into a
  string with `.to_s`, which is an alias for `.inspect` most of the time).
- Each element in the array corresponds to at least one line of HTML
- Multiline child tags will get as many lines as they need (like you'd expect).
- Child elements are not rendered until the parent is rendered, meaning you can access and
  modify them after defining a parent.
- add with `.add_content`, or modify the content array directly.

#### oneline

- Boolean
- optional, defaults to false.
- When true, the entire element and its content will be rendered as a single line. Useful for
  anchor tags and list items.

### DoubleTag Methods (that you care about)

For DoubleTag Examples, we're working with a div tag:

```
div = DoubleTag.new 'div'
```

`DoubleTag.new(element, attributes: {}, oneline: false, content: [])`

- You can initialize it with content.

`add_content(anything)`

- Example: `div.add_content 'example text!'`
- Example: `div.add_content ['splits', 'across', 'lines']`
- Example: `div.add_content img # image tag from earlier`
- Smart enough to handle both arrays and not-arrays without getting dorked up. When given an array,
  its elements will be appended to the content array. When given a single item, that item will be
  inserted at the end of the array. (Remember each element in the content array gets at least one
  line!)

`attr_accessor: content` - You can modify the content array directly if you like. If you're just
adding items, you should use `.add_content`

`oneline` - Example: `div.oneline = true`

`.to_a` - Mostly used internally, but if you want an array of strings, each element a line with
appropriate indentation applied, this is how you can get it.

### ShelfTags:

Shelf tags are like invisible double tags. Think of them like a bookshelf.
They're useful when you want to build siblings without a corresponding parent
tag.

Convert it into an actual tag with `.add_parent(DoubleTag)`

## Configuration

Indentation is defined by the `indent` method on the DoubleTag class, which is two escaped
spaces by default ("\ \ "). If you'd like to change it:

1.  Make a new class, inherit from DoubleTag.
2.  Override `indent` with whatever you want.
3.  Use your new class instead of DoubleTag.

Example:

```ruby

require 'objective_elements'

class MyDoubleTag < DoubleTag
 def indent
   # 4 escaped spaces:
   "\ \ \ \ "
 end
end

MyDoubleTag.new('p', content: 'hello').to_s
# <p>
#     hello
# </p>

```

## Limitations

- It doesn't know a single HTML element on its own, so it does nothing to ensure your HTML is valid.

- A parent tag can't put siblings on the same line. You can either do this (with `oneline: true` on
  the strong tag):

  ```html
  <p>
    Here is some
    <strong>strong</strong>
    text.
  </p>
  ```

  or this (default behavior):

  ```html
  <p>
    Here is some
    <strong>
      strong
    </strong>
    text.
  </p>
  ```

  But you can't do this without string interpolation or something:

  ```html
  <p>
    Here is some
    <strong>strong</strong>
    text.
  </p>
  ```

  This doesn't affect how the browser will render it, but it might bug you if you're particular about
  source code layout.

- If you set 'oneline: true' on a parent DoubleTag, but not all its children DoubleTags, the output
  will not be pretty. I advise against it. Handling this situation is on the TODO list.

- It doesn't wrap long lines of text, and it doesn't indent text with newlines embedded. It's on the
  TODO list.

## Contributing

For code style, I've been using rubocop with the default settings and would appreciate if you did the
same.

If you add new functionality, or change existing functionality, please update the rspec tests to
reflect it.

https://github.com/rbuchberger/objective_elements

contact:
robert@robert-buchberger.com

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
