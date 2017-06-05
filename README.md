# Gestpay iFrame example in Ruby

This s an example of the Gestpay iFrame solution implemented in Ruby.

This example has been built with:

- [Sinatra](http://www.sinatrarb.com/), an easy framework to create web applications in ruby.
- [Savon](http://savonrb.com/), a Ruby soap client.

This software has been developed with **Ruby 2.4**, but older versions should work too (as long Sinatra supports them).

## What to know about this project

The endpoints of the application are defined in `app.js`.

In `gestpay_ws_crypt_decrypt/ws_crypt_decrypt.rb` there is the class that performs SOAP requests to Gestpay.

In the directory `views/` there are the pages that will be rendered to html, via `erb`, a super-easy template engine.

In the directory `public/` you'll find images and other assets used to render the website. Have a look to
`public/js/app.js` that contains the code for the iframe functionality.

in `constants/constants.rb` you can define your own test shop code and the environment (`:test` or `:prod`).

## How to Install

This software is not a gem but just a standalone example.

To install, clone this repository and launch

```
$ bundle install
```

in the Merchant Back-Office, setup these attributes:

- IP Address - the public IP your server is using
- success & failure response redirect url: http://localhost:4567/response

## How to start

To start the server, simply launch

```
$ ruby app.rb
```

Then, navigate to http://localhost:4567 to see some magic.

### Start in *development mode*

first install

```console
$ gem install rerun
```

Then you'll have a new shell command that will start & stop the ruby app everytime you change a file.

To start this project with `rerun`, do

```console
$ rerun 'ruby app.rb'
```

## Contributing, Typos, Fixes, just-say-Hi

Bug reports and pull requests are welcome here on GitHub!

## License

The example is available as open source under the terms of the MIT License.