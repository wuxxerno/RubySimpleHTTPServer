require 'socket'

class HTTPResponse
  def initialize code:0, data:"", mime:""
    @response =
    "HTTP/1.1 #{code}\r\n" +
    "Content-Type: #{mime}\r\n" +
    "Content-Length: #{data.size}\r\n" +
    "\r\n" +
    "#{data}\r\n"
    def get
      return @response
    end
  end


class HTTPRequestParser
  def initialize request
    @method, @path, @version = request.lines[0].split
    def get
      if @path != '/'
        @path[0] = ''
      else
        return @path
      end
      return @path
    end
  end
end


class SimpleHTTPServer
  def initialize adress:, port:, share:''
    @server = TCPServer.new adress, port
  end
  def serve
    loop do
      @client = @server.accept
      @request = @client.readpartial 2048
      path = HTTPRequestParser.new(@request).get()
      if File.exists?(path)
        begin
          @file = IO.binread(path)
        rescue
          next
        end
        @client.write HTTPResponse.new(code:200, data:@file).get()
      else
        @client.write HTTPResponse.new(code:404).get()
      end
      @client.close
    end
  end
end
   

if __FILE__ == $0
  server = SimpleHTTPServer.new adress:'localhost', port:8084, share:''
  server.serve
end
end