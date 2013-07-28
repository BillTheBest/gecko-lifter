class Habit
  def self.from_subscription_data(subscription)
    name = subscription['habit']['name']
    is_done = subscription['stats']['frequency'].first['count'] == 1
    new(name, is_done)
  end

  attr_reader :name
  def initialize(name, is_done)
    @name = name
    @is_done = is_done
  end

  def done?
    @is_done
  end
end
