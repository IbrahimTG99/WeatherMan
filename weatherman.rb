require './temperature-chart'
require './year-stats'
require './avg-month-stats'

require 'date'
# ruby weatherman.rb -c 2011/03 Dubai_weather
# ruby weatherman.rb -e 2010 Dubai_weather
# ruby weatherman.rb -a 2011/03 Dubai_weather
# resolved the problem of the missing data in the weather data

input_arr = ARGV
option = input_arr[0]
date = input_arr[1]
path = input_arr[2]
MONTHS = %w[January February March April May June July August September October November December].freeze
OPTIONS = ['-e', '-a', '-c'].freeze

class Weatherman
  include YearStats
  include AverageMonthStats
  include TemperatureChart

  def initialize(option, date, path)
    @avg_max_temp = 0
    @avg_min_temp = 0
    @avg_humidity = 0
    @max_temp = 0
    @min_temp = 0
    @max_humidity = 0
    @option = option
    @date = date.length > 4 ? Date.parse(date) : Date.new(date.to_i, 1, 1)
    @path = ''
    path.nil? || @path = path
  rescue ArgumentError
    puts 'invalid date format'.red
    exit(false)
  end

  def run
    case @option
    when '-e'
      year_stats
    when '-a'
      average_month_stats
    when '-c'
      temperature_chart
    else
      puts 'Invalid option'.red
    end
  end
end

bob = Weatherman.new(option, date, path)
bob.run
puts 'Done'.green
