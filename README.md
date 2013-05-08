# DBResolver

DBResolver is a basic yet versatile resolver for Rails which allows you to render from a model.

## Installation

Add this line to your application's Gemfile:

    gem 'dbresolver', :git => 'TODO ADD THIS'

And then execute:

    $ bundle

## Usage

To use this, simply add one of the following to a controller you wish to use it in (if you want to add it to a view, add it to the view's controller):

    prepend_view_path DBResolver::Resolver.using() #Prioritize DBResolver
    append_View_path DBResolver::Resolver.using()  #Prioritize filesystem

Then, you can simply render from the database with
    render 'model/name'

## Options
For customization and handling non-standard setups, there are a series of options you may set. Global options may be included in a hash as an argument to DBResolver::Resolver.using() in your controller. Local options may be added as arguments to render. All option names are represented as symbols.

Global options:

* prefix (array): A list of prefixes to limit lookups to.
* use_prefix (boolean): Use prefix in lookup (searches table for "prefix/name" instead of "name")
* model (Class - Model or string): Model to use in lookups. Overrides prefix lookups.
* body_name (string or symbol): Name of column/variable in model to use. Defaults to content and body.

Local options:

* use_prefix (boolean): Use prefix in lookup (searches table for "prefix/name" instead of "name")
* model (Class - Model or string): Model to use in lookups. Overrides prefix lookups.
* name (string or symbol) : Name of column/variable in model to use for search by name. Defaults to "name"
* body_name (string or symbol): Name of column/variable in model to use for body. Defaults to content and body.
* conditions (hash): Conditions to use beyond name in searching.
* format (string): MIME type. Defaults to "text/html"

## Table columns
Some of the fields in your table or model may change things in the result. These are for your convenience, but they may conflict with tables you use currently.

* handler : String representation of handler to use for your content.
* path : Virtual path for internal Rails usage. Defaults to prefix/name
* format : MIME type to render as.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
