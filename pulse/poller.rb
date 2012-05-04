#
#  poller.rb
#  pulse
#
#  Created by Tony Pitale on 5/3/12.
#

class Poller
  def initialize(parent)
    @parent = parent
    @user = User.new
    p @user.api_key
  end

  def request
    Request.new("http://ls-dna-lab.herokuapp.com/version", success, failure, {
      'API_KEY' => @user.api_key
    })
  end

  def perform_request(timer)
    request.perform_request
  end

  def start
    NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector:"perform_request:", userInfo: nil, repeats: true)
  end

  def success
    Proc.new {|response|
      if response && @user.update_version!(response)
        @parent.trigger_update_available
      end
    }
  end

  def failure
    Proc.new {}
  end
end

class Request
  def initialize(url, success, failure=nil, headers={})
    @request = NSMutableURLRequest.alloc.init
    @request.setURL NSURL.URLWithString(url)

    headers.each do |k,v|
      @request.setValue(v.to_s, forHTTPHeaderField: k.to_s)
    end

    @success = success
    @failure = failure
    # @parser = Yajl::Parser.new(:symbolize_keys => true)
  end

  def connection
    @connection ||= NSURLConnection.alloc.initWithRequest(@request, delegate:self)
  end

  def perform_request
    self.connection.start
  end

  def connection(connection, didFailWithError:error)
    # puts error.code.inspect
    # puts error.domain.inspect
    # puts error.userInfo.inspect
  end

  def success?
    @status_code == 200
  end

  def connection(connection, didReceiveResponse:response)
    @status_code = response.statusCode
    @response_body = "" if success?
  end

  def connection(connection, didReceiveData:data)
    if success?
      (0...data.length).each {|i| @response_body << data.bytes[i].chr}
    end
  end

  def connectionDidFinishLoading(connection)
    if success?
      @success.call(@response_body)
    else
      @failure.call(@status_code) if @failure
    end
  end
end