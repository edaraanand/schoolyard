require "date"

class DateTime
  ##
  # Convert to Time object (for DateTime/Time conversion protocol).
  #
  #   DateTime.now.to_time    #=> Wed Nov 19 20:04:51 -0800 2008
  #
  # @return [Time] Time object representing the same moment as receiver
  #
  # @api public
  remove_method :to_time if method_defined?(:to_time) || private_method_defined?(:to_time)
  def to_time
    Time.parse self.to_s
  end

  ##
  # Return receiver (for DateTime/Time conversion protocol).
  #
  #   DateTime.now.to_datetime    #=> #<DateTime: 212093913977/86400,-1/3,2299161>
  #
  # @return [DateTime] Receiver
  #
  # @api public
  remove_method :to_datetime if method_defined?(:to_datetime) || private_method_defined?(:to_datetime)
  def to_datetime
    self
  end
end
