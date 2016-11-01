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

All API requests will return a `Button::Response` instance, which supports accessing data properties from the API response as methods.  To access the raw response hash, use `#to_hash`.  For instance:

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

puts response.button_order_id
# => btnorder-XXX

puts response.to_hash()
# => {:button_order_id=>'btnorder-29de0b1436075ea6', :total=>60, ... }
```

n.b. the keys of the response hash will always be symbols. 

## Resources

We currently expose only one resource to manage, `Orders`. 

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
  btn_ref: 'srctok-XXX'
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

## Contributing

* Building the gem: `gem build button.gemspec`
* Installing locally: `gem install ./button-X.Y.Z.gem`
* Installing development dependencies: `bundle install`
* Running tests: `bundle exec rake`
