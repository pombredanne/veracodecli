require_relative 'API_functions'
include VeracodeApiBase
r = veracode_api_request('getbuildinfo.do',app_id: '12379',build_id: '488114')
puts r
