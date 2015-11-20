module Timer
  def Timer.timer(&block)
    start_time = Time.now
    result = block.call
    end_time = Time.now
    @time_taken = (end_time - start_time) * 1000
    result
  end

  def Timer.humanize ms
    [[1000, :ms], [60, :secs], [60, :mins], [24, :hrs], [365, :days], [10000, :yrs]].map{ |count, name|
      if ms > 0
      	ms, n = ms.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end
 
  def Timer.elapsedTime
   Timer.humanize @time_taken
  end

  def Timer.time()
    Timer.elapsedTime
  end

end