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
  it 'prints out the version number when passed a -v argument' do
  	expect(`primetable -v`).to include(PrimeTable::VERSION)
  end
end
