require 'spec_helper'

describe PrimeTable do
  it 'has a version number' do
    expect(PrimeTable::VERSION).not_to be nil
  end
  it 'executes when called on the command line' do
    expect(`primetable`).to eq("PrimeTable is running...\n")
  end
  it 'prints out a run time when passed a -t argument' do
    expect(`primetable -t`).to include("ms")
  end  
end
