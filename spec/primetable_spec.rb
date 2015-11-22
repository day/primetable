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
    @expected_first_ten_primes = [2,3,5,7,11,13,17,19,23,29]
    @expected_table_with_first_ten_primes = [[nil,2,3,5,7,11,13,17,19,23,29],
                                             [2,4,6,10,14,22,26,34,38,46,58],
                                             [3,6,9,15,21,33,39,51,57,69,87],
                                             [5,10,15,25,35,55,65,85,95,115,145],
                                             [7,14,21,35,49,77,91,119,133,161,203],
                                             [11,22,33,55,77,121,143,187,209,253,319],
                                             [13,26,39,65,91,143,169,221,247,299,377],
                                             [17,34,51,85,119,187,221,289,323,391,493],
                                             [19,38,57,95,133,209,247,323,361,437,551],
                                             [23,46,69,115,161,253,299,391,437,529,667],
                                             [29,58,87,145,203,319,377,493,551,667,841]]
  end

  it 'has a version number' do
    expect(PrimeTable::VERSION).not_to be nil
  end

  it 'executes when called on the command line' do
    expect(`primetable`).to include("PrimeTable is running...\n")
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
  it 'executes *and* prints out a run time *and* prints out the version number when passed both --time and --version arguments' do
    execution_output = `primetable --time --version`
    expect(execution_output).to include(@expected_execution_output)
    expect(execution_output).to include(@expected_time_output)
    expect(execution_output).to include(@expected_version_output)
  end
  it 'prints out usage details when passed -h or --help' do
    execution_output = `primetable -h`
    expect(execution_output).to include(@expected_help_output)
    execution_output = `primetable --help`
    expect(execution_output).to include(@expected_help_output)
  end

  it "has the right data when we run it with :load" do
    test_instance = PrimeTable.new(1,10,:load,true)
    expect(test_instance.primes).to eq(@expected_first_ten_primes)
    expect(test_instance.table).to eq(@expected_table_with_first_ten_primes)
  end
  it "has the right data when we run it with :fast" do
    test_instance = PrimeTable.new(1,10,:fast,true)
    expect(test_instance.primes).to eq(@expected_first_ten_primes)
    expect(test_instance.table).to eq(@expected_table_with_first_ten_primes)
  end
  it "has the right data when we run it with :calc" do
    test_instance = PrimeTable.new(1,10,:calc,true)
    expect(test_instance.primes).to eq(@expected_first_ten_primes)
    expect(test_instance.table).to eq(@expected_table_with_first_ten_primes)
  end
end
