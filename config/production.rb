require 'ostruct'

module LiveWeb
  def self.settings
    OpenStruct.new({
      :google_analytics_profile_id => 'UA-17783838-19',
      :google_analytics_domain => '.playup.com'
    })
  end
end
