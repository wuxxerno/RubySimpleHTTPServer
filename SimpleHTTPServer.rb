require 'socket'

class HTTPResponse
  def initialize code:0, data:"", mime:""
    @response =
    "HTTP/1.1 #{code}\r\n" +
    "Content-Type: #{mime}\r\n" +
    "Content-Length: #{data.size}\r\n" +
    "\r\n" +
    "#{data}\r\n"
    def response
      @response
    end
  end


class HTTPRequestParser
  def initialize request
    @method, @path, @version = request.lines[0].split
    def path
      if @path != '/'
        @path[0] = ''
      else
        @path
      end
        @path
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
      path = HTTPRequestParser.new(@request).path
      if File.exists?(path)
        begin
          @file = IO.binread(path)
        rescue
          @client.write HTTPResponse.new(code:404).response
          @client.close
          next
        end
        @client.write HTTPResponse.new(code:200, data:@file).response
      else
        @client.write HTTPResponse.new(code:404).response
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