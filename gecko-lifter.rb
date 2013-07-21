require 'liftapp-client'
require 'geckoboard-push'
require 'yaml'

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

class HabitStatsUpdater
  def initialize(configuration)
    @lift_password = configuration.fetch('lift').fetch('password')
    @lift_email = configuration.fetch('lift').fetch('email')

    @gecko_widget = configuration.fetch('geckoboard').fetch('widget')
    @gecko_api_key = configuration.fetch('geckoboard').fetch('api_key')
  end

  def update!
    Geckoboard::Push.api_key = @gecko_api_key
    Geckoboard::Push.new(@gecko_widget).geckometer(habit_stats.done, 0, habit_stats.total)
  end

  def habit_stats
    HabitStats.new(lift_client)
  end

  def lift_client
    Liftapp::Client.new(@lift_email, @lift_password) 
  end
end

configuration = YAML.load_file(ENV['HOME']+ '/.gecko_lifter')
HabitStatsUpdater.new(configuration).update!
