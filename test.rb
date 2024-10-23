require 'rspec'
require 'csv'
require_relative 'laba5' 

describe ExchangeRate do
  let(:exchange_rate) { ExchangeRate.new }

  describe '#get_rates' do
    it 'returns a hash of conversion rates' do
      rates = exchange_rate.get_rates
      expect(rates).to be_a(Hash)
      expect(rates).to include('UAH') 
    end

    it 'returns an empty hash if an error occurs' do
      allow(Net::HTTP).to receive(:get).and_raise(StandardError.new("API error"))
      rates = exchange_rate.get_rates
      expect(rates).to eq({}) 
    end
  end

  describe '#save_to_file' do
    let(:test_file) { 'test_exchange_rate.csv' }
    
    after { File.delete(test_file) if File.exist?(test_file) } 

    it 'creates a CSV file with the correct data' do
      rates = {  'USD' => 30.5, 'EUR' => 32.0, 'GBP' => 36.0, 'CAD' => 24.0, 'AUD' => 22.0, 'CHF' => 31.0, 'CNY' => 4.5  } 
      exchange_rate.save_to_file(rates, test_file)

      csv_data = CSV.read(test_file)
      expect(csv_data.length).to eq(8) 
      expect(csv_data[0]).to eq(['Currency', 'Rate']) 
      expect(csv_data[1]).to eq(['USD', '30.50']) 
      expect(csv_data[2]).to eq(['EUR', '32.00']) 
      expect(csv_data[3]).to eq(['GBP', '36.00']) 
      expect(csv_data[4]).to eq(['CAD', '24.00'])
      expect(csv_data[5]).to eq(['AUD', '22.00']) 
      expect(csv_data[6]).to eq(['CHF', '31.00']) 
      expect(csv_data[7]).to eq(['CNY', '4.50'])
    end
  end
end









