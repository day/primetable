require 'spec_helper'

describe PrimeTable do
  it 'has a version number' do
    expect(PrimeTable::VERSION).not_to be nil
  end
  it 'executes when called on the command line' do
    expect(`primetable`).to eq("PrimeTable is running...\n\n")
  end  
end
