# cursor\_pagination [![CircleCI](https://circleci.com/gh/otoyo/cursor_pagination.svg?style=svg)](https://circleci.com/gh/otoyo/cursor_pagination)
Cursor based pagination library for Rails.

## Usage

```ruby
# Get the oldest 100 posts where id <= cursor
# If cursor is nil, get the oldest 100 posts.
@posts = Post.before(id: params[:cursor]).limit(100)

# Get the newest 100 posts where id >= cursor
# If cursor is nil, get the newest 100 posts.
@posts = Post.after(id: params[:cursor]).limit(100)

# Also you can use other colum as cursor instead of id
@posts = Post.before(created_at: params[:cursor]).limit(100)

@posts.has_next?   # => true/false
@posts.next_cursor # => value of cursor column/nil
```

Note that if multiple data have the same cursor value (like `created_at` at the same time), they appear in duplicate.

### In the template

If you use [Bootstrap 4.x](https://getbootstrap.com/docs/4.3/components/pagination/), pagers are expressed as below:

```html
<nav aria-label="pagination">
  <ul class="pagination">
    <% if @posts.has_next? %>
      <li class="page-item">
        <%= link_to "Next &gt;", { controller: :posts, action: :index, cursor: @posts.next_cursor }, class: "page-link" %>
      </li>
    <% else %>
      <li class="page-item disabled"><a href="#" class="page-link">Next &gt;</a></li>
    <% end %>
  </ul>
</nav>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'cursor_pagination'
```

## Contributing
Feel free to send PR.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
