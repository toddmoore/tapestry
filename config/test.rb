require 'ostruct'

module LiveWeb
  def self.settings
    OpenStruct.new({
      :google_analytics_profile_id => 'UA-17783838-12'
    })
  end
end
