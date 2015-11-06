require 'test/unit'
require 'shoulda/context'
require_relative '../lib/veracodecli/api'
include VeracodeApiScan
include VeracodeApiResults

class TestVeracodecli < Test::Unit::TestCase
  context 'VeracodeApi' do

    setup do
      @test_file_location = '' # a .tar or .zip archive path
    end

    should 'Return existing application profile ID' do
      assert_equal '12379', get_app_id('Test1')
    end

    should 'Return HTTP 200 for createapp.do' do
      assert_equal 200, veracode_api_request('createapp.do', app_name: 'Test1', business_criticality: 'Low', business_unit: 'TELUS Digital', teams: 'TELUS Digital').code
    end

    should 'Return HTTP 200 from beginprescan.do' do
      assert_equal 200, veracode_api_request('beginprescan.do', app_id:'12379').code
    end

    should 'Return Response Object' do
      assert_kind_of RestClient::Response, veracode_api_request('getapplist.do')
    end

    should 'Return XML response for uploadfile.do' do
      assert_boolean upload_file('12379', @test_file_location).include?('Uploaded')
    end

    should 'Return HTTP from get_prescan_results function' do
      assert_equal 200, get_prescan_results('12379').code
    end

    should 'Return XML response' do
      assert_boolean get_scan_report('12379').include?('<detailedreport')
    end

    should 'Return Application Scan Status' do
      assert_kind_of String, get_build_status('12379')
    end

    should 'Return Most recent Build ID' do
      assert_match /\d+/, get_most_recent_build_id('12379')
    end
  end
end
