require 'csv'

module AverageMonthStats
  # For a given month display the average highest temperature, average lowest temperature, average humidity.
  def average_month_stats
    file_path = "#{@path}/#{@path.split('/')[-1]}_#{@date.year}_#{MONTHS[@date.mon - 1][0, 3]}.txt"
    unless File.exist?(file_path)
      puts "File #{file_path} does not exist".red
      exit(false)
    end

    file_content = CSV.parse(File.read(file_path), headers: true)
    compute_average_month_stats(file_content)
    print_average_month_stats
  end

  def compute_average_month_stats(file_content)
    count = 0
    file_content.each do |row|
      next if row['Max TemperatureC'] == 'NA'

      count += 1
      @avg_max_temp += row['Max TemperatureC'].to_i
      @avg_min_temp += row['Min TemperatureC'].to_i
      @avg_humidity += row[' Mean Humidity'].to_i
    end

    @avg_max_temp /= count
    @avg_min_temp /= count
    @avg_humidity /= count
  end

  def print_average_month_stats
    puts "Highest Average:  #{@avg_max_temp.to_s.rjust(2, '0')}C"
    puts "Lowest Average:   #{@avg_min_temp.to_s.rjust(2, '0')}C"
    puts "Average Humidity: #{@avg_humidity.to_s.rjust(2, '0')}%"
  end
end
