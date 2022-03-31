require 'colorize'
require 'csv'

module TemperatureChart
  # For a given month draw one horizontal bar chart on the console for the highest and lowest temperature on each day.
  # Highest in red and lowest in blue.
  def temperature_chart
    file_path = "#{@path}/#{@path.split('/')[-1]}_#{@date.year}_#{MONTHS[@date.mon - 1][0, 3]}.txt"
    unless File.exist?(file_path)
      puts "File #{file_path} does not exist".red
      exit(false)
    end
    file_content = CSV.parse(File.read(file_path), headers: true)
    compute_temprature_chart(file_content)
  end

  def compute_temprature_chart(file_content)
    count = 0
    file_content.each do |row|
      count += 1
      @max_temp = row['Max TemperatureC'] != 'NA' ? row['Max TemperatureC'].to_i : 0
      @min_temp = row['Min TemperatureC'] != 'NA' ? row['Min TemperatureC'].to_i : 0
      print_temperature_chart(count)
    end
  end

  def print_temperature_chart(count)
    puts "#{count.to_s.rjust(2, '0')} " + '+'.colorize(:blue) * @min_temp + '+'.colorize(:red) * @max_temp +
         " #{@min_temp.to_s.rjust(2, '0')}C - #{@max_temp.to_s.rjust(2, '0')}C"
  end
end
