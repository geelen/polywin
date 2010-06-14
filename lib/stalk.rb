module Polywin
  class Stalk
    def initialize tube
      @tube = tube
      @listener = Beanstalk::Pool.new(['localhost:11300'], @tube)
    end

    def next_job &blk
      job = @listener.reserve
      body = JSON.parse(job.body)
      handled = blk.call(body)
      #probably should release instead of delete for handled, eventually
      if !handled
        puts "Job not handled!: #{job.inspect}\n#{body.inspect}"
      end
      job.delete
    end

    def respond id, response
      Beanstalk::Pool.new(['localhost:11300'], "#{@tube}_response_#{id}").put(response.to_json)
    rescue Beanstalk::UnexpectedResponse => e
      p e
    end
  end
end
