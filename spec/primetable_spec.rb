require 'spec_helper'

describe PrimeTable do
	before(:all) do
		@expected_execution_output = "PrimeTable is running...\n"
		@expected_time_output = "ms"
		@expected_version_output = PrimeTable::VERSION
		@expected_help_output = "Common options:
    -t, --time                       Display run time
    -h, --help                       Show this message
    -v, --version                    Show version"
  end
  it 'has a version number' do
    expect(PrimeTable::VERSION).not_to be nil
  end
  it 'executes when called on the command line' do
    expect(`primetable`).to eq("PrimeTable is running...\n")
  end
  it 'executes *and* prints out a run time when passed -t or --time' do
    execution_output = `primetable -t`
    expect(execution_output).to include(@expected_execution_output)
    expect(execution_output).to include(@expected_time_output)
    execution_output = `primetable --time`
    expect(execution_output).to include(@expected_execution_output)
    expect(execution_output).to include(@expected_time_output)
  end  
  it 'prints out the version number when passed -v or --version' do
    expect(`primetable -v`).to include(@expected_version_output)
  end
  it 'executes *and* prints out a run time *and* prints out the version number when passed both -t and -v arguments' do
    execution_output = `primetable -tv`
    expect(execution_output).to include(@expected_execution_output)
    expect(execution_output).to include(@expected_time_output)
    expect(execution_output).to include(@expected_version_output)
  end
  it 'prints out usage details when passed -h or --help' do
    execution_output = `primetable -h`
    expect(`primetable -h`).to include(@expected_help_output)
    execution_output = `primetable --help`
    expect(`primetable -h`).to include(@expected_help_output)
  end
end
