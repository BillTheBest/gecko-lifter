require_relative 'habit'

class HabitStats
  def initialize(client)
    @client = client 
  end

  def total
    habits.size
  end

  def done
    habits.select(&:done?).size
  end

  private
  def habits
    @habits ||= dashboard['subscriptions'].map do |subscription|
      Habit.from_subscription_data(subscription)
    end
  end

  def dashboard
    @client.dashboard
  end
end
