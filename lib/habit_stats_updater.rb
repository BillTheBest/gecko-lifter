require 'liftapp-client'
require 'geckoboard-push'
require_relative 'habit_stats'

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

