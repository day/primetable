require 'spec_helper'

describe PrimeTable do
  it 'has a version number' do
    expect(PrimeTable::VERSION).not_to be nil
  end
  it 'executes when called on the command line' do
    expect(`primetable`).to eq("PrimeTable is running...\n")
  end
  it 'executes *and* prints out a run time when passed a -t argument' do
    execution_output = `primetable -t`
    expect(execution_output).to include("PrimeTable is running...\n")
    expect(execution_output).to include("ms")
  end  
  it 'prints out the version number when passed a -v argument' do
  	expect(`primetable -v`).to include(PrimeTable::VERSION)
  end
  it 'executes *and* prints out a run time *and* prints out the version number when passed both -t and -v arguments' do
    execution_output = `primetable -tv`
    expect(execution_output).to include("PrimeTable is running...\n")
    expect(execution_output).to include("ms")
    expect(execution_output).to include(PrimeTable::VERSION)
  end
end
