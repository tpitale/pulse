#
#  user.rb
#  pulse
#
#  Created by Tony Pitale on 5/4/12.
#

class User
  def initialize
    @defaults = NSUserDefaults.standardUserDefaults
  end

  def api_key
    @defaults.stringForKey("api_key")
  end

  def latest_version
    @defaults.stringForKey("latest_version")
  end

  def latest_version=(version)
    @defaults.setObject(version, forKey:"latest_version")
  end

  def save
    @defaults.synchronize
  end
end
