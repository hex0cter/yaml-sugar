# The yaml-sugar gem for Ruby

[![Gem Version](https://badge.fury.io/rb/yaml-sugar.svg)](https://badge.fury.io/rb/yaml-sugar)
[![Build Status](https://travis-ci.org/hex0cter/yaml-sugar.svg?branch=master)](https://travis-ci.org/hex0cter/yaml-sugar)
[![Coverage Status](https://coveralls.io/repos/github/hex0cter/yaml-sugar/badge.svg?branch=master)](https://coveralls.io/github/hex0cter/yaml-sugar?branch=master)

yaml-sugar is a ruby gem inspired by hashugar. It reads all the yaml files from
a given directory, and build them into an OpenStruct. If there are several yaml
files with the same name, the later will be merged into the earlier.

## How to use?

In your ruby code,

```ruby
  require 'yaml/sugar'
  YamlSugar.load(dir)
```

then you are ready to go.

For example, if you have the following files inside your config directory:

```
.
+-- config
       +-- fox.yaml
       +-- consumer
       |       +-- consumer.yaml
       +-- people.yaml
       +-- country
               +-- people.yaml
```

config/fox.yaml
```yaml
  color:
    is:
      green: true
```

config/consumer/consumer.yaml

```yaml
  language: english
  hobbies:
    balls: tennis
```

config/people.yaml

```yaml
  average_age: 90
```

config/country/people.yaml

```yaml
  average_age: 75
  longest_age: 112
```


In your project,

```ruby
  YamlSugar.load('config')

  assert YamlSugar.fox.color.is.green
  assert YamlSugar.people.average_age == 90
  assert YamlSugar.people.longest_age == 112
  assert YamlSugar.consumer.language == 'english'
  assert YamlSugar.consumer.hobbies.balls == 'tennis'
```

You can also add a dynamic attribute on the fly like this:

```ruby
  YamlSugar.set(:attr, :foo)
  assert YamlSugar.attr == :foo
```

or simply like this:

```ruby
  YamlSugar.attr = :foo
  assert YamlSugar.attr == :foo
```

The default order for loading the yaml files with same name is dependant
on the implementation of Find.find(dir). If that doesn't meet your
expectation, you can explicitly load them again. When the two yaml files
with same name are merged, you can choose either a normal merge or deep merge.

For instance, assume you have the following two files:

```
.
+-- config
       +-- aminal
       |     +-- setting.yaml
       +-- bird
             +-- setting.yaml
```

config/animal/setting.yaml

```yaml
  type: animal
  list:
    - monkey
    - sheep

```

config/bird/setting.yaml

```yaml
  type: bird
  list:
    - seagull
    - pigeon
```

Load with overwriting fields with same names:

```ruby
  YamlSugar.load('config/animal')
  YamlSugar.load('config/bird')

  assert YamlSugar.setting.type == 'bird'
  assert YamlSugar.setting.list == %w(seagull pigeon)
```

Load with merging fields with same names:

```ruby
  YamlSugar.load('config/animal')
  YamlSugar.load('config/bird', deep_merge: true)

  assert YamlSugar.setting.type == 'bird'
  assert YamlSugar.setting.list == %w(seagull pigeon monkey sheep)
```

If you wanna clear all the previous settings, just call

```ruby
  YamlSugar.clear
```

Sometimes you might want to have multiple instances of YamlSugar, which are independent
of each other. In that case you can just use the following syntax:

```ruby
  animal_config = YamlSugar.new
  bird_config = YamlSugar.new
  animal_config.load('config/animal')
  bird_config.load('config/bird')

  assert animal_config.setting.type == 'animal'
  assert bird_config.setting.type == 'bird'

  assert animal_config.setting.list == %w(monkey sheep)
  assert bird_config.setting.list == %w(seagull pigeon)

  animal_config.set(:from, :land) # or animal_config.from = :land
  bird_config.set(:from, :sky)  # or bird_config.from = :sky

  assert animal_config.from == :land
  assert bird_config.from == :sky
```

## How to install?

From a terminal run

```bash
  gem install yaml-sugar
```

or add the following code into your Gemfiles:

```ruby
  gem 'yaml-sugar'
```

## How to build/install from source?

```bash
  gem build yaml-sugar.gemspec
  gem install yaml-sugar-<VERSION>.gem
```

## How to run the test?

```bash
  rake test
```

## License

This code is free to use under the terms of the MIT license.

## Contribution

You are more than welcome to raise any issues, open a Pull Request [here](https://github.com/hex0cter/yaml-sugar).
