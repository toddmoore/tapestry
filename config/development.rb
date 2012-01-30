require 'ostruct'

module LiveWeb
  def self.settings
    OpenStruct.new({
      :service_description_url => 'http://s3.amazonaws.com/playup-live/uat/json/$1',
      :google_analytics_profile_id => 'UA-17783838-12'
    })
  end
end
