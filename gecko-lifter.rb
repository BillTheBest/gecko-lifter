require 'yaml'
require_relative './lib/habit_stats_updater'

configuration = YAML.load_file(ENV['HOME']+ '/.gecko_lifter')
HabitStatsUpdater.new(configuration).update!
