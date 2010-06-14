require File.dirname(__FILE__) + '/stalk'

module Polywin
  def self.listen tube, &blk
    loop = Loop.new(tube)
    loop.instance_eval &blk
    loop.do
  end

  private

  class Loop
    def initialize(tube)
      @stalk = Stalk.new(tube)
      @handlers = []
    end

    def do
      loop do
        @stalk.next_job do |job|
          name, handler = @handlers.find { |name, handler| name == job['message'] }
          if handler
            handler.call(job['id'], job['data'])
            true
          else
            false
          end
        end
      end
    end

    private

    def worker name, &blk
      @handlers << [name, Worker.new(@stalk, &blk)]
    end

    def consumer name, &blk
      @handlers << [name, lambda { |id, data| blk.call(data) } ]
    end

    class Worker
      def initialize stalk, &blk
        @stalk = stalk
        @blk = blk
      end

      def call(id, data)
        response = @blk.call(data)
        @stalk.respond(id, response)
      end
    end
  end
end
