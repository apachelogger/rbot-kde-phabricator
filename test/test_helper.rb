begin
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter
    ]
  )
  SimpleCov.start
rescue LoadError
  warn 'SimpleCov not loaded'
end

def __dir__
  File.dirname(File.realpath(__FILE__))
end

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_casettes"
  config.hook_into :webmock
  config.filter_sensitive_data('API_TOKEN') do |interaction|
    # Prevent recording the actual token!
    uri = URI.parse(interaction.request.uri)
    query = CGI.parse(uri.query)
    query.fetch('api.token').join('')
  end
  # Make sure to ignore api.token from matching. Otherwise we'd have to
  # meddle with filtering and restoration, where latter is tricky to do
  # since we don't know what the relevant token would be.
  config.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param('api.token')
    ]
  }

end

$LOAD_PATH.unshift(File.absolute_path('../', __dir__)) # ../
$LOAD_PATH.unshift(File.absolute_path(__dir__)) # test/
ENV['DONT_TEST_INIT'] = 'true' # Do not allow plugin to init.

require 'test/unit'
require 'mocha/test_unit' # Patch mocha in
require 'mocha/setup' # Make sure it is set up (ruby 1.9)
