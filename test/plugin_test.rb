# encoding: utf-8

require(File.expand_path('test_helper', File.dirname(__FILE__)))

# Dud base class. We mocha this for functionality later.
class Plugin
  class Config
    class StringValue
      def initialize(_, _ = {})
      end
    end
    def self.register(_)
    end
  end

  def map(*args)
  end

  def bot
  end
end

require 'phabricator'

class PluginTest < Test::Unit::TestCase

  # NB: mocha is stupid with the quotes and can't tell single from double!

  def setup
    config = mock('config')
    # Do not give an api_token as we need the environment to take over.
    config.stubs(:[]).with('phabricator.api_token').returns(nil)
    bot = mock('bot')
    bot.stubs(:config).returns(config)
    Plugin.any_instance.stubs(:bot).returns(bot)
  end

  def message_double
    channel = mock('message-channel')
    channel.stubs(:name).returns('#message-double-channel')
    mock('message').tap { |m| m.stubs(:channel).returns(channel) }
  end

  def test_get_task_unreplied
    message = message_double
    message.stubs(:message).returns('yolo T123 T456 meow T789')
    message.stubs(:replied?).returns(false)

    plugin = PhabricatorPlugin.new
    plugin.expects(:task).with(message, { :number => '123' })
    plugin.expects(:task).with(message, { :number => '456' })
    plugin.expects(:task).with(message, { :number => '789' })
    plugin.unreplied(message)
  end

  def test_get_diff_unreplied
    message = message_double
    message.stubs(:message).returns('yolo D123 D456 meow D789')
    message.stubs(:replied?).returns(false)

    plugin = PhabricatorPlugin.new
    plugin.expects(:diff).with(message, { :number => '123' })
    plugin.expects(:diff).with(message, { :number => '456' })
    plugin.expects(:diff).with(message, { :number => '789' })
    plugin.unreplied(message)
  end

  def test_task
    message = message_double
    message.expects(:reply).with('Task 2970 "aptly sftp publishing to files.kde" [Open,Normal] {Neon} https://phabricator.kde.org/T2970')

    VCR.use_cassette("#{self.class}/#{__method__}") do
      plugin = PhabricatorPlugin.new
      plugin.task(message, :number => 2970)
    end
  end

  def test_task_fail
    message = message_double
    message.expects(:notify).with('Task not found ¯\_(ツ)_/¯ ConduitError ERR_BAD_TASK: No such Maniphest task exists.')

    VCR.use_cassette(__method__) do
      plugin = PhabricatorPlugin.new
      plugin.task(message, :number => -1)
    end
  end

  def test_diff
    message = message_double
    message.expects(:reply).with('Diff 2300 "always load about-distro in ctor" [Closed] https://phabricator.kde.org/D2300')

    VCR.use_cassette("#{self.class}/#{__method__}") do
      plugin = PhabricatorPlugin.new
      plugin.diff(message, :number => 2300)
    end
  end

  def test_diff_fail
    message = message_double
    message.expects(:notify).with('Diff not found ¯\_(ツ)_/¯ can\'t dup NilClass')

    VCR.use_cassette(__method__) do
      plugin = PhabricatorPlugin.new
      plugin.diff(message, :number => -1)
    end
  end

  def test_skip
    message = message_double
    message.channel.stubs(:name).returns('#kde-bugs-activity')
    plugin = PhabricatorPlugin.new
    plugin.unreplied(message)
  end
end
