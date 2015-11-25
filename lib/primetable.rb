# Require modules from the lib/primetable directory...a PRIMES constant, and a VERSION constant
Dir["#{File.dirname(__FILE__)}/primetable/**/*.rb"].each { |f| require(f) }

# This is needed for load_primes method, which loads data from a file.
require "yaml"

# This is used in the display_table method to...um, display the table ;-)
require "formatador"

# So, just for fun, I'm going to write my Ruby prime generation method and a few others as
# wrappers for some JS functionality I've already written. We'll test as usual. Perhaps, if
# I ever get around to writing Ruby native versions, we can have them race eachother.
require "v8"

# It's a pretty simple program. I considered making multiple classes, but it's not necessary.
class PrimeTable

  # We're going to want to get and set things from inside multiple methods, so...
  attr_accessor :primes, :table

  def initialize(first=1, count=10, prime_method=:calc, suppress_output=false)

    # This is only for testing, I'm unlikely to implement a command-line flag for this
    unless suppress_output
      puts "PrimeTable is running..."
    end

    # Ye olde instance variables
    @primes = init_primes(prime_method,first,count)
    @table = build_data(@primes)

    # I added this suppress_output so I could run certain tests without a huge, admittly
    # ugly, table clobbering my nice green passing specs
    unless suppress_output
      display_table(@table)
    end

  end # initialize()

  # This was a utility I used when I discovered a prime which was missing from the data file
  # I left it here in case I encounter another such
  # def repair_data()
  #   @prime_array = []
  #   @add_to_next_line = []
  #   open('data/prime.dat.2', 'a') { |f|
  #     IO.readlines("data/prime.dat").each_with_index{|line,ln|
  #       @prime_array = @add_to_next_line
  #       @prime_array.concat(YAML::load(line))
  #       if @prime_array.length > 10
  #         @add_to_next_line = @prime_array.slice(10,@prime_array.length-10)
  #         f.puts @prime_array.slice(0,10).to_s.gsub(/ /,"")
  #       else
  #         f.puts @prime_array.to_s.gsub(/ /,"")
  #       end
  #     }
  #   }
  # end

  # One way or another, we need to get an array of consecutive prime numbers.
  def init_primes(prime_method, first, count)

    # Of course, we calculate the primes by default. But having three methods is not only
    # fancy; it's also comes in handy for testing that our calculated values are correct.
    case prime_method
      when :fast # Using precalculated values from code. 8-17ms, mode 13ms on benchmark (2,10) run, 14-24ms/20ms on (200000,12)
        fast_primes(first,count)
      when :load # Using precalculated values from file. 45-256ms, mode 50ms on benchmark (2,10) run, 669-913ms/681ms on (200000,12)
        load_primes(first,count)
      when :calc # Using JS generated values. 14-84ms, Mode 18ms on benchmark (2,10) run, 17-25ms/21ms on (200000,12)
        calc_primes(first,count)
    end # case prime_method

  end # init_primes()

  def fast_primes(first,count)

    # Since we allow people to pass their best guess for first and use the next highest prime
    while PrimeTable::PRIMES.index(first) === nil
      first = first + 1 
    end
    PrimeTable::PRIMES.slice(PrimeTable::PRIMES.index(first),count)

  end # fast_primes()

  # Loads precalculated primes from a data file. The file is formatted with 10 primes per line.
  # Each line is enclosed in square brackets, and the primes are comma-delimited. Thus, it's
  # trivial to read each line in as an array of ten primes. Please note that this file is 995K
  # and contains 13413 lines. You don't want to just slurp this file. That would be rude. Instead
  # we read lines one at a time and only keep what we need. Also note the highest prime in this
  # file is currently 2000003, although conceivably we could use the :calc method and extend it.
  def load_primes(first, count)

    # An array to keep our prime numbers in, right?
    primes = []

    # Previously, the 'first' argument was an index, now it's a best guess for the first prime,
    # so we have to find the index in order to find the line number
    if first == 1
      first = 2
    end

    if first == 2
      wb_before = ""
    else
      wb_before = ","
    end

    if first >= 2000003
      wb_after = ""
    else
      wb_after = ","
    end

    grep_result = []
    while grep_result == []
      grep_result = `grep -n -e "#{wb_before}#{first}#{wb_after}" data/prime.dat`.split(":")
      if grep_result == []
        first = first + 1
      end
    end
    first_line = grep_result[0].to_i-1
    first_index = YAML::load(grep_result[1]).index(first)
    last_line = (((first_line)*10+first_index+count)/10).ceil

    # Again, we only have the first 134130 primes in here right now (on 13413 lines)
    if last_line > 13413
      throw "We only have the first 134130 primes in the data file right now. Please pass -c to use calculated primes."
    end

    # Here we read in the file one line at a time. Yes I looked for a faster way. Try :fast (-f).
    #  1) We don't want to slurp the whole file...what if the file was even larger? Not cool.
    #  2) IO.readlines gets the file one line at a time, so we need a line number, not an index.
    IO.readlines("data/prime.dat").each_with_index{|line,ln|
      
      # When we find the lines we want, we concatenate them into a single array. We get extra.
      if (ln >= first_line and ln <= last_line)
         primes.concat(YAML::load(line))
      end
    }

    # The extra is trimmed off in this step. We know what we want. Just this, thanks!
    primes.slice!(first_index,count)

  end # load_primes()

  # Calculates the primes using basic math. This can be slow for higher primes or higher counts.
  # TODO: Include note on computational complexity here: O(n*sqrt(n)), I think
  # TODO: Include note on average run time using this method.
  def calc_primes(first, count)

    # One nice thing about this is that I can easily set a timeout, so if someone asks us to run
    # some astronomical prime, we won't seize up the CPU forever. 7000ms is arbitrary.
    calc_primes_js = V8::Context.new timeout: 7000
    File.open("js/prime.js") do |file|
      calc_primes_js.eval(file, "js/prime.js")
    end
    primes_js = calc_primes_js.eval("generatePrimes(#{first},#{count})")
    YAML::load("[#{primes_js}]")

  end # calc_primes()

  def build_data(primes)

    # To make this code simpler we act as if our first prime is 1 so that the matrix includes
    # our header row and column of primes (multiplied by 1)...we remove the corner 1 later
    primes.unshift(1)

    # An empty two-dimensional array to act as the data model for our table
    table = Array.new(primes.length) { Array.new(primes.length) }

    # We populate the array-of-arrays with the products-of-primes ;-)
    primes.each_with_index{|outerprime,i|
      primes.each_with_index{|innerprime,y|
        table[i][y] = outerprime*innerprime
      }
    }

    # Here we remove the corner 1 which was added as a side-effect of the matrix generation
    primes.shift(1)
    table[0][0] = nil

    # And send the table data to display (or, in theory, whoever called us)
    table

  end # build_data()

  # Use Formatador to make this display nicely.
  def display_table(table)

    columns = table.shift
    table_data = table.map do |products|
      row_hash = Hash.new
      columns.each_with_index do |label, index|
        key = (columns[index] || '')
        row_hash[key] = products[index]
      end
      row_hash
    end
    # Note that we override the default string sort by passing a block with an integer sort
    Formatador.display_table(table_data){ |x, y| x.to_i <=> y.to_i }

  end # display_table()

end # class PrimeTable
