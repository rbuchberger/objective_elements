# Objective Elements

This is a tiny gem that builds nicely formatted HTML using sane, readable Ruby. I use it for jekyll 
plugins, but you can use it anywhere. It's ~100 lines, tested with rspec, and has no dependencies.

This gem doesn't actually know any HTML. It just knows how to format it.

## How it works:

* Instantiate a `SingleTag` or `DoubleTag`

* Add attributes & content in one of a few ways. Nest tags infinitely.

* Render it with `.to_s`

## Motivation:

Have you ever tried to build HTML with string concatenation and interpolation? It starts out simply
enough, but once you account for all the what-ifs, the indentation, the closing tags, and the 
spaces you only need sometimes, it turns into a horrible mess.

The problem, of course, is that building long, complex, varying blocks of text with string
concatenation and interpolation is fragile, unreadable, and painful. You know this, but you're not
going to write an entirely new class or pull in some big new dependency just for 10 lines of HTML.
Instead, you hammer through it and end up with code like this:

```ruby
picture_tag = "<picture>\n"\
                      "#{source_tags}"\
                      "#{markdown_escape * 4}<img src=\"#{url}#{instance['source_default'][:generated_src]}\" #{html_attr_string}>\n"\
"#{markdown_escape * 2}</picture>\n"
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

Which is why I sat down and wrote this gem. It's super simple, you probably could have written it
too, but hey! Now you don't have to. Here's a demo:

## Demo

```ruby
p = DoubleTag.new 'p'
p.to_s
# <p>
# </p>

# Add attributes as a hash, values can be strings or symbols:
p.add_attributes class: 'stumpy grumpy', 'id' => 'the-ugly-one'
# Add them as a string!
p.add_attributes 'class="slimy" data-awesomeness="11"'
p.add_content "Icky"
p.to_s
# <p class="stumpy grumpy slimy" id="the-ugly-one" data-awesomeness="11">
#   Icky
# </p>

# Want a oneliner?
p.oneline = true
p.to_s
# <p class="stumpy mopey grumpy slimy" id="the-ugly-one" data-awesomeness="11">Icky</p>
p.oneline = false

# Build it up step by step, or all at once:
p.add_content DoubleTag.new(
  'a',
  content: 'Link!',
  attributes: {href: 'awesome-possum.com'},
  oneline: true
)
# Add a parent tag!
div = p.add_parent DoubleTag.new 'div'

# Ruby implicitly calls .to_s on things when you try to perform string functions with them, so
# things like this work:
"#{div}"
# <div>
#   <p class="stumpy mopey grumpy slimy" id="the-ugly-one" data-awesomeness="11">
#     Icky
#     <a href="awesome-possum.com">Link!</a>
#   </p>
# </div>

```
## Installation

 ```ruby
 # Gemfile
 
 gem 'objective_elements', '~> 0.1.2'
 ```
 
 ```ruby
 # Wherever you need to use it:
 
 require 'objective_elements'
 ```
## Terminology

So we're on the same page, here's the terminology I'm using:
```
<p class="stumpy">Hello</p>
|a|       b      |  c  | d |
```
- a    -  element
- b    -  attributes
- a+b  -  opening tag
- c    -  content
- d    -  closing tag

There are 2 classes: `SingleTag` is the base class, and `DoubleTag` inherits from it. A `SingleTag` is a
self-closing tag, meaning it has no content and no closing tag. A `DoubleTag` is the other kind.

## Usage

### SingleTag Properties:

 #### element
 - String
 - Mandatory
 - Which type of tag it is, such as 'hr' or 'img'
 - Defined on initialization, cannot be changed afterwards. (Should it be? I'm on the fence about it.)
     
 #### attributes
  - Hash 
  - Optional
  - Keys are symbols, values are arrays of strings. `{class: ['stumpy', 'slimy']}`
  - add them with `.add_attributes`, which can accept a few different formats.

### SingleTag Methods (that you care about)

`SingleTag.new(element, attributes: {})`

`.to_s` - The big one. Returns your HTML as a string, nondestructively.

`.reset_attributes(new)` - Deletes all attributes, calls add_attributes on supplied argument if given.

`.add_attributes(new)` - The only way we add new attributes. Can accept a hash (keys can be either symbols or strings), or a string in the standard HTML syntax (`attribute="value" attribute2="value2 value3"`). Returns self. 

`.add_parent(DoubleTag)` - returns supplied DoubleTag, with self added as a child.

`attr_reader :attributes, :element`

### DoubleTag Properties:

#### `DoubleTag` Inherits all of `SingleTag`'s properties and methods, but adds content and a closing tag.
 #### content
   - Array
   - Optional
   - Contains anything (but probably just strings and tags. Anything else will be turned into a string with `.to_s`, which is an alias for `.inspect` most of the time).
   - Each element in the array corresponds to at least one line of HTML
   - Multiline child tags will get as many lines as they need (like you'd expect).
   - Child elements are not rendered until the parent is rendered, meaning you can access and
   modify them after defining a parent.
   - add with `.add_content`, or modify the content array directly.

 #### oneline
  - Boolean
  - optional, defaults to false.
  - When true, the entire element and its content will be rendered as a single line. Useful for anchor tags and list items.

### DoubleTag Methods (that you care about)

`DoubleTag.new(element, attributes: {}, oneline: false, content: [])` - You can initialize it with content.

`add_content(anything)` - Smart enough to handle both arrays and not-arrays without getting dorked up.

`attr_accessor: content` - You can modify the content array directly if you like. If you're just adding items, you should use
    `.add_content`

`.to_a` - Mostly used internally, but if you want an array of strings, each element a line with appropriate
    indentation applied, this is how you can get it.

## Configuration
 
 Indentation is defined by the `indent` method on the DoubleTag class. If you'd like to change
 it:

 1. Make a new class, inherit from DoubleTag.
 2. Override `indent` with whatever you want.
 3. Use your new class instead of DoubleTag.

 Example:

 ```ruby
 
 require 'ojbective_elements'

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

* It doesn't know a single HTML element on its own, so it does nothing to ensure your 
    HTML is valid. Garbage in, garbage out.

* A parent tag can't put siblings on the same line. You can either
    do this (with `oneline: true` on the strong tag):

    ```html

      Here is some
      <strong>strong</strong>
      text.

    ```
    or this (default behavior):

    ```html

      Here is some
      <strong>
        strong
      </strong>
      text.

    ```
    But you can't do this without string interpolation:

    ```html

    Here is some <strong>strong</strong> text. 

    ```
    This doesn't affect how the browser will render it, but it might bug you if you're particular about
    source code layout.

* If you set 'oneline: true' on a parent DoubleTag, but not all its children DoubleTags, the output
    will not be pretty. I advise against it.

* It doesn't wrap long lines of text, and it doesn't indent text with newlines embedded. It's on the
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
