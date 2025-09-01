# lib/weather_station.rb
class WeatherStation
  def temperature(location)
    # Simulate reading a temperature sensor
    72.0
  end

  def humidity(location)
    50
  end

  def report(condition, value)
    "#{condition.capitalize}: #{value}"
  end

  def forecast(day)
    case day
    when :today then 'Sunny'
    when :tomorrow then 'Rainy'
    else 'Unknown'
    end
  end

  def calibrate(sensor)
    "Calibrated #{sensor}"
  end

  def log_event(event, data = {})
    "Logged #{event}: #{data.inspect}"
  end
end
