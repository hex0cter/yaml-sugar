require_relative 'paths'
require 'yaml/sugar'
require 'minitest/autorun'

class TestYamlSugarInstance < Minitest::Test
  def test_fox
    yaml_sugar = YamlSugar.new
    yaml_sugar.load('config')
    assert yaml_sugar.fox.color.is.brown
    assert yaml_sugar.fox.color.is.grey.nil?
  end

  def test_people
    yaml_sugar = YamlSugar.new
    yaml_sugar.load('config')
    assert yaml_sugar.people.average_age == 90
    assert yaml_sugar.people.longest_age == 112
  end

  def test_consumer
    yaml_sugar = YamlSugar.new
    yaml_sugar.load('config')
    assert yaml_sugar.consumer.language == 'english'
    assert yaml_sugar.consumer.hobbies.balls == 'tennis'
  end

  def test_dynamic_attr
    yaml_sugar = YamlSugar.new
    assert yaml_sugar.attr.nil?

    yaml_sugar.attr = :foo
    assert yaml_sugar.attr == :foo

    yaml_sugar.set(:attr, :bar)
    assert yaml_sugar.attr == :bar

    yaml_sugar.clear
    assert yaml_sugar.attr.nil?
  end

  def test_overwriting
    yaml_sugar = YamlSugar.new
    yaml_sugar.load('config')
    yaml_sugar.load('config/overwritting/animal')
    yaml_sugar.load('config/overwritting/bird')

    assert yaml_sugar.setting.type == 'bird'
    assert yaml_sugar.setting.list == %w(seagull pigeon)
  end

  def test_merging
    yaml_sugar = YamlSugar.new
    yaml_sugar.load('config')
    yaml_sugar.load('config/overwritting/animal')
    yaml_sugar.load('config/overwritting/bird', deep_merge: true)

    assert yaml_sugar.setting.type == 'bird'
    assert yaml_sugar.setting.list == %w(seagull pigeon monkey sheep)
  end

  def test_multiple_instances
    animal_config = YamlSugar.new
    bird_config = YamlSugar.new
    animal_config.load('config/overwritting/animal')
    bird_config.load('config/overwritting/bird')
    animal_config.from = :land
    bird_config.from = :sky

    assert animal_config.setting.type == 'animal'
    assert bird_config.setting.type == 'bird'

    assert animal_config.setting.list == %w(monkey sheep)
    assert bird_config.setting.list == %w(seagull pigeon)

    assert animal_config.from == :land
    assert bird_config.from == :sky
  end
end
