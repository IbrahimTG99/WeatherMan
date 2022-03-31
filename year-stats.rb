require 'csv'

module YearStats
  # For a given year display the highest temperature and day, lowest temperature and day, most humid day and humidity.
  def year_stats
    MONTHS.each do |month|
      file_path = "#{@path}/#{@path.split('/')[-1]}_#{@date.year}_#{month[0, 3]}.txt"
      unless File.exist?(file_path)
        puts "File #{file_path} does not exist".red
        exit(false)
      end
      file_content = CSV.parse(File.read(file_path), headers: true)
      compute_year_stats(file_content)
    end
    print_year_stats
  end

  def compute_year_stats(file_content)
    file_content.each do |row|
      next if row['Max TemperatureC'] == 'NA'

      update_max_temp(row) if row['Max TemperatureC'].to_i > @max_temp
      update_min_temp(row) if row['Min TemperatureC'].to_i < @min_temp
      update_max_humidity(row) if row['Max Humidity'].to_i > @max_humidity
    end
  end

  def update_max_temp(row)
    @max_temp = row['Max TemperatureC'].to_i
    @max_temp_day = row['GST']
  end

  def update_min_temp(row)
    @min_temp = row['Min TemperatureC'].to_i
    @min_temp_day = row['GST']
  end

  def update_max_humidity(row)
    @max_humidity = row['Max Humidity'].to_i
    @max_humidity_day = row['GST']
  end

  def parse_dates
    @max_temp_day = Date.parse(@max_temp_day)
    @min_temp_day = Date.parse(@min_temp_day)
    @max_humidity_day = Date.parse(@max_humidity_day)
  end

  def print_year_stats
    parse_dates
    print_max_temp
    print_min_temp
    print_max_humidity
  end

  def print_max_temp
    puts "Highest: #{@max_temp.to_s.rjust(2, '0')}C on #{MONTHS[@max_temp_day.mon - 1]} #{@max_temp_day.mday.to_s.rjust(2, '0')}"
  end

  def print_min_temp
    puts "Lowest: #{@min_temp.to_s.rjust(2, '0')}C on #{MONTHS[@min_temp_day.mon - 1]} " +
         @min_temp_day.mday.to_s.rjust(2, '0').to_s
  end

  def print_max_humidity
    puts "Humid: #{@max_humidity.to_s.rjust(2, '0')}% on #{MONTHS[@max_humidity_day.mon - 1]} " +
         @max_humidity_day.mday.to_s.rjust(2, '0').to_s
  end
end
