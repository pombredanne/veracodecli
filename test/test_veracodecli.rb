require 'test/unit'
require 'shoulda/context'
require_relative '../lib/veracodecli/api'
include VeracodeApiScan

class TestVeracodecli < Test::Unit::TestCase
  context 'VeracodeApi' do

    setup do
      ENV['VERACODE_USERNAME'] = 'foo'
      ENV['VERACODE_PASSWORD'] = 'bar'
      ENV['VERACODE_TEAM'] = 'foobar'
    end

    should 'Return HTTP 401' do
      assert_equal response.code, veracode_api_request('getapplist.do', '')
    end

  end
end
