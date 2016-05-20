require_relative 'paths'
require 'yaml/sugar'
require 'minitest/autorun'

class TestYamlSugar < Minitest::Test
  def setup
    YamlSugar.load('config')
  end

  def test_fox
    assert YamlSugar.fox.color.is.brown
    assert YamlSugar.fox.color.is.grey.nil?
  end

  def test_people
    assert YamlSugar.people.average_age == 90
    assert YamlSugar.people.longest_age == 112
  end

  def test_consumer
    assert YamlSugar.consumer.language == 'english'
    assert YamlSugar.consumer.hobbies.balls == 'tennis'
  end

  def test_dynamic_attr
    YamlSugar.clear
    assert YamlSugar.attr.nil?

    YamlSugar.attr = :foo
    assert YamlSugar.attr == :foo

    YamlSugar.set(:attr, :bar)
    assert YamlSugar.attr == :bar
  end

  def test_overwriting
    YamlSugar.load('config/overwritting/animal')
    YamlSugar.load('config/overwritting/bird')

    assert YamlSugar.setting.type == 'bird'
    assert YamlSugar.setting.list == %w(seagull pigeon)
  end

  def test_merging
    YamlSugar.load('config/overwritting/animal')
    YamlSugar.load('config/overwritting/bird', deep_merge: true)

    assert YamlSugar.setting.type == 'bird'
    assert YamlSugar.setting.list == %w(seagull pigeon monkey sheep)
  end
end
