# button-client-ruby [![Build Status](https://travis-ci.org/button/button-client-ruby.svg?branch=master)](https://travis-ci.org/button/button-client-ruby)

This module is a thin client for interacting with Button's API.

Please see the full [API Docs](https://www.usebutton.com/developers/api-reference) for more information.  

#### Supported runtimes

* Ruby (MRI) `>=1.9.3`

#### Dependencies

*  None

## Usage

```bash
gem install button
```

To create a client capable of making network requests, instantiate a  `Button::Client` with your [API key](https://app.usebutton.com/settings/organization).

```ruby
require 'button'

client = Button::Client.new('sk-XXX')
```

The client will always attempt to raise a `Button::ButtonClientError` in an error condition.

All API requests will return a `Button::Response` instance.  To access the response data, invoke `#data`.

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

begin
  response = client.orders.get('btnorder-XXX')
rescue Button::ButtonClientError => error
  puts error
end

puts response
# => Button::Response(button_order_id: btnorder-XXX, total: 60, ... )

puts response.data
# => {:button_order_id=>'btnorder-29de0b1436075ea6', :total=>60, ... }

puts response.data[:button_order_id]
# => btnorder-XXX
```

_n.b. the keys of the response hash will always be symbols._

## Configuration

You may optionally supply a config argument with your API key:

```ruby
require 'button'

client = Button::Client.new('sk-XXX', {
  hostname: 'api.testsite.com',
  port: 3000,
  secure: false,
  timeout: 5 # seconds
})
```

The supported options are as follows:

* `hostname`: Defaults to `api.usebutton.com`.
* `port`: Defaults to `443` if `config.secure`, else defaults to `80`.
* `secure`: Whether or not to use HTTPS. Defaults to True.  **N.B: Button's API is only exposed through HTTPS. This option is provided purely as a convenience for testing and development.**
* `timeout`: The time in seconds that may elapse before network requests abort. Defaults to `nil`.

## Resources

We currently expose the following resources to manage:

* [`Accounts`](#accounts)
* [`Customers`](#customers)
* [`Merchants`](#merchants)
* [`Orders`](#orders)
* [`Links`](#links)
* [`Offers`](#offers)

### Accounts

##### all

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.accounts.all

puts response
# => Button::Response(2 elements)
```

##### transactions

_n.b. transactions is a paged endpoint.  Take care to inspect `response.next_cursor` in case there's more data to be read._

Along with the required account id, you may also pass the following optional arguments as a Hash as the second argument:

* `:cursor` (String): An API cursor to fetch a specific set of results.
* `:start` (ISO-8601 datetime String): Fetch transactions after this time.
* `:end` (ISO-8601 datetime String): Fetch transactions before this time.

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.accounts.transactions('acc-XXX')
cursor = response.next_cursor

puts response
# => Button::Response(75 elements)

# Unpage all results
#
while !cursor.nil? do
  response = client.accounts.transactions('acc-XXX', cursor: cursor)
  cursor = response.next_cursor
end
```

### Customers

##### Create

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.customers.create({
  id: 'internal-customer-id',
  email_sha256: Digest::SHA256.hexdigest('user@example.com'.downcase.strip)
})

puts response
# => Button::Response(id: internal-customer-id, email_sha256: a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3)
```
##### Get

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.customers.get('btncustomer-XXX')

puts response
# => Button::Response(id: btncustomer-XXX, segments:[], ... )
```

### Merchants

##### all

You may also pass the following optional arguments as a Hash as the first argument:

* `:status` (String): Partnership status to filter by. One of ('approved', 'pending', or 'available')
* `:currency` (ISO-4217 String): Currency code to filter returned rates by

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.merchants.all(status: 'pending', currency: 'GBP')

puts response
# => Button::Response(23 elements)
```

### Orders

**n.b: all currency values should be reported in the smallest possible unit of that denomination, i.e. $1.00 should be reported as `100` (i.e. 100 pennies)**

##### Create

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.orders.create({
  total: 50,
  currency: 'USD',
  order_id: '1994',
  finalization_date: '2017-08-02T19:26:08Z',
  btn_ref: 'srctok-XXX',
  customer: {
    id: 'mycustomer-1234',
    email_sha256: Digest::SHA256.hexdigest('user@example.com'.downcase.strip)
  }
})

puts response
# => Button::Response(button_order_id: btnorder-XXX, total: 50, ... )
```

##### Get

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.orders.get('btnorder-XXX')

puts response
# => Button::Response(button_order_id: btnorder-XXX, total: 50, ... )
```

##### Update

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.orders.update('btnorder-XXX', total: 60)

puts response
# => Button::Response(button_order_id: btnorder-XXX, total: 60, ... )
```

##### Delete

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.orders.delete('btnorder-XXX')

puts response
# => Button::Response()
```

### Links

##### Create

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.links.create({
    url: "https://www.jet.com",
    experience: {
        btn_pub_ref: "my-pub-ref",
        btn_pub_user: "user-id"
    }
})

puts response
# => Button::Response()
```

##### Get Info

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.links.get_info({
    url: "https://www.jet.com"
})

puts response
# => Button::Response()
```

### Offers

##### Get Offers

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.offers.get({
    user_id: "some-user-id",
    device_ids: ["123"]
})

puts response
# => Button::Response()
```

## Response

An instance of the `Button::Response` class will be returned by all API methods.  It is used to read the response data as well as collect any meta data about the response, like potential next and previous cursors to more data in a paged endpoint.

### Methods

#### data

returns the underlying response data

```ruby
require 'button'

client = Button::Client.new('sk-XXX')

response = client.accounts.all

puts response
# => Button::Response(2 elements)

puts response.data
# => [ { ... }, { ... } ]
```

#### next_cursor

For any paged resource, `#next_cursor` will return a cursor to supply for the next page of results.  If `#next_cursor` returns `nil`, then there are no more results.

#### prev_cursor

For any paged resource, `#prev_cursor` will return a cursor to supply for the previous page of results.  If `#prev_cursor` returns `nil`, then there are no more results, err.. backwards.

## Utils

Utils houses generic helpers useful in a Button Integration.

### #webhook_authentic?

Used to verify that requests sent to a webhook endpoint are from Button and that their payload can be trusted. Returns `true` if a webhook request body matches the sent signature and `false` otherwise. See [Webhook Security](https://www.usebutton.com/developers/webhooks/#security) for more details.

```ruby
require 'button'

Button::Utils::webhook_authentic?(
  ENV['WEBHOOK_SECRET'],
  request_body,
  request_headers.fetch('X-Button-Signature')
)
```

## Contributing

* Building the gem: `gem build button.gemspec`
* Installing locally: `gem install ./button-X.Y.Z.gem`
* Installing development dependencies: `bundle install`
* Running linter: `rake lint`
* Running tests: `bundle exec rake`
