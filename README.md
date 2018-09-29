**This gem is young and untested. Use with caution.**

# Elements

This is a tiny gem that builds nicely formatted HTML from sane, readable Ruby. I use it for jekyll 
plugins, but you can use it anywhere. It's ~100 lines, with no dependencies.

Have you ever tried to build HTML with string concatenation and interpolation? At first it seems
simple, but once you account for all the what-ifs, the indentation, the closing tags, and the 
spaces you only need sometimes, it turns into a horrible mess.

The problem, of course, is that building long, complex, varying blocks of text with string
concatenation and interpolation is fragile, unreadable, and painful. You know this, but you're not
going to write an entirely new class just to spit out 10 lines of HTML, so you hammer through it and
end up with code like this:

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

Whicch is why I wrote this gem. Here's a demo:

```ruby
p = TagPair.new 'p'
p.to_s
# <p>
# </p>

p.add_attributes {class: 'stumpy grumpy', id: 'the-ugly-one'}
p.to_s
# <p class="stumpy grumpy", id="the-ugly-one">
# </p>

p.add_attributes {class: 'slimy'}
p.to_s
# <p class="stumpy grumpy slimy", id="the-ugly-one">
# </p>

p.add_content 'Bippity Boppity Boo!'
p.to_s
# <p class="stumpy grumpy slimy", id="the-ugly-one">
#   Bippity Boppity Boo!
# </p>

p.oneline = true
p.to_s
# <p class="stumpy mopey grumpy slimy", id="the-ugly-one">Bippity Boppity Boo!</p>

p.oneline = false
p.add_content TagPair.new 'a', content: 'Link!', attributes: {href: 'awesome-possum.com'}
p.content[1].oneline = true
p.to_s
# <p class="stumpy mopey grumpy slimy", id="the-ugly-one">
#   Bippity Boppity Boo!
#   <a href="awesome-possum.com">Link!</a>
# </p>

div = p.add_parent TagPair.new 'div'
div.to_s
# <div>
#   <p class="stumpy mopey grumpy slimy", id="the-ugly-one">
#     Bippity Boppity Boo!
#     <a href="awesome-possum.com">Link!</a>
#   </p>
# </div>

div.add_content Tag.new 'img', attributes: {src: 'happy-puppy.jpg'}
div.to_s
# <div>
#   <p class="stumpy mopey grumpy slimy", id="the-ugly-one">
#     Bippity Boppity Boo!
#     <a href="awesome-possum.com">Link!</a>
#   </p>
#   <img src="happy-puppy.jpg">
# </div>

```

It does nothing it all to ensure that your HTML is valid. Garbage in, garbage out. If you 
set 'oneline: true' on a parent TagPair, but not all its children TagPairs, the output will not be pretty. 
I advise against it.

## Installation

 - coming eventually. It'll be a gem and a require. For now, you can load it from this repo in your gemfile.
 
 ## Configuration
 
 none
 
## Usage

So we're on the same page, here's the terminology I'm using:
```
<p class="stumpy">Hello</p>
|a|       b      |  c  | d |
```
- a: element
- b: attributes
- c: content
- d: closing tag

There are 2 classes: `Tag` is the base class, and `TagPair` inherits from it. A `Tag` is a
self-closing tag, meaning it has no content and no closing tag. A `TagPair` is the other kind.

### Tag Properties:

 - element:
     **String**, mandatory. What kind of tag it is; such as 'img' or 'hr'
 - attributes:
     **Hash** `{symbol: array || string}`, optional. Example: `{class: 'myclass plaid'}` 

### Tag Methods (that you care about)

`Tag.new(element, attributes: {}, newline: true)`

`.to_s` - The big one. Returns your HTML as a string, nondestructively.

`.reset_attributes(hash)` - Deletes and overwrites the attributes. Destructive.

`.add_attributes(hash)` - Appends them instead of overwriting. Destructive.

`.element` - returns the element type

`.add_parent(TagPair)` - returns supplied TagPair, with self added as a child. Nondestructive.

`attr_reader :attributes, :element`

### TagPair Properties:

 `TagPair` Inherits all of `Tag`'s properties and methods, but adds content and a closing tag.
 - content:
     **Array**, optional, containing anything (but probably just strings and Tags. Anything else
     will be turned into a string with .to_s, which is an alias for .inspect most of the time).
     Child elements are not rendered until the parent is rendered, meaning you can access and
     modify them after defining a parent.

- oneline:
    **Boolean**, optional, defaults to false. When true, the entire element and its content will be
    rendered as a single line. Otherwise, the opening tag, closing tag, and every element in the
    content array (including rendered child elements) will get its own line.

### TagPair Methods (that you care about)

`TagPair.new(element, attributes: {}, oneline: false, content: anything)`
 - You can initialize it with content.

`add_content(anything)`
- content is an array. Each element corresponds to a line, except for TagPairs with oneline: false, whose
    content and tags will each get their own line (as you'd expect).

`attr_accessor: content`
- You can modify the content array directly if you like.

`.to_s`
- The main rendering method. Indentation is hard-coded at 2 spaces.

`.to_a`
- Mostly used internally, but if you want an array of strings, each element a line with appropriate
    indentation applied, this is how you can get it.

## Contributing

I would really love some help on this one. The basic functionality is there, but there are surely
loads of bugs, and I haven't written any tests. I'm considering introducing 'preset' functionality,
where you can do something like `ElementFactory.p` to get a paragraph tag, but it's a bit of work
and I'm not convinced it's any easier than `TagPair.new 'p'`

For pull requests, I've been using rubocop with the default settings and would appreciate if you did
the same.

https://github.com/rbuchberger/elements

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
