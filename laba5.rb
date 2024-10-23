require 'net/http'
require 'json'
require 'csv'

class ExchangeRate
  API = 'https://v6.exchangerate-api.com/v6/18fd6010c8849f68751314b3/latest/UAH'

  def get_rates
    begin
      result = Net::HTTP.get(URI(API))
      JSON.parse(result)['conversion_rates'] || {} 
    rescue StandardError => e
      puts "Error fetching rates: #{e.message}"
      {} 
    end
  end

  def save_to_file(rates, file_name)
    CSV.open(file_name, 'w') do |csv|
      csv << ['Currency', 'Rate']
      rates.each do |currency, rate|
        csv << [currency, sprintf('%.2f', rate)]
      end
    end
  end
end

rate_collector = ExchangeRate.new
currencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'CHF', 'CNY']
filtered_rates = rate_collector.get_rates.select { |cur| currencies.include?(cur) }

rate_collector.save_to_file(filtered_rates, 'ExchangeRate.csv')





