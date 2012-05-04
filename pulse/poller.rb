#
#  poller.rb
#  pulse
#
#  Created by Tony Pitale on 5/3/12.
#

class Poller
  def initialize(parent)
    @parent = parent
  end

  def request
    @request ||= Request.new("http://google.com", success, Proc.new {})
  end

  def start
    request.perform_request
  end

  def success
    Proc.new {|response|
      p response

      @parent.trigger_update_available
    }
  end
end

class Request
    def initialize(url, success, failure=nil)
      @request = NSURLRequest.requestWithURL(NSURL.URLWithString(url))
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