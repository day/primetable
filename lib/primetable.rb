# Require modules from the lib/primetable directory...right now it's just our VERSION constant
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

  end # def initialize()

  # One way or another, we need to get an array of consecutive prime numbers.
  def init_primes(prime_method, first, count)

    # Of course, we calculate the primes by default. But having three methods is not only
    # fancy; it's also comes in handy for testing that our calculated values are correct.
    case prime_method
      when :fast # Using precalculated values from code. 3-8ms on benchmark run.
        PrimeTable::PRIMES.slice(first-1,count)
      when :load # Using precalculated values from file. 13-23ms on benchmark run.
        load_primes(first,count)
      when :calc # Using JS generated values. 8-16ms on benchmark run.
        calc_primes(first,count)
    end # case prime_method

  end # def init_primes()

  # Calculates the primes using basic math. This can be slow for higher primes or higher counts.
  # TODO: Include note on computational complexity here: O(n*sqrt(n)), I think
  # TODO: Include note on average run time using this method.
  def calc_primes(first, count)

    # One nice thing about this is that I can easily set a timeout, so I someone asks us to run
    # some astronomical prime, we won't seize up the CPU forever. 700ms is arbitrary.
    calc_primes_js = V8::Context.new timeout: 700
    File.open("js/prime.js") do |file|
      calc_primes_js.eval(file, "js/prime.js")
    end
    primes_js = calc_primes_js.eval("generatePrimes(#{first})")
    primes = YAML::load("[#{primes_js}]")
    return primes

  end

  # Loads precalculated primes from a data file. The file is formatted with 10 primes per line.
  # Each line is enclosed in square brackets, and the primes are comma-delimited. Thus, it's
  # trivial to read each line in as an array of ten primes. Please note that this file is 995K
  # and contains 13413 lines. You don't want to just slurp this file. That would be rude. Instead
  # we read lines one at a time and only keep what we need. Also note the highest prime in this
  # file is currently 2000029, although conceivably we could use the :calc method and extend it.
  def load_primes(first, count)

    # Again, we only have the first 134130 primes in here right now
    if (first + count) > 134130
      throw "We only have the first 134130 primes in the data file right now. Please pass -c to use calculated primes."
    end

    # An array to keep our prime numbers in, right?
    primes = []

    # Because there are ten primes on each line, we can get the line number we're looking for by
    # dividing the indices we want by 10 and rounding down for the bottom of our range and up for
    # the top. It's not immediately intuitive why we might want to do this, but it's because:
    #   1) We don't want to slurp the whole file...what if the file was even larger? Not cool.
    #   2) IO.readlines gets the file one line at a time, so we need a line number, not an index.

    first_line = (first/10).floor
    last_line = ((first+count)/10).ceil

    # Here we read in the file one line at a time. Yes I looked for a faster way. Try :fast (-f).
    IO.readlines("data/prime.dat").each_with_index{|line,ln|

      # When we find the lines we want, we concatenate them into a single array. We get extra.
      if (ln >= first_line and ln <= last_line)
         primes.concat(YAML::load(line))
      end
    }

    # The extra is trimmed off in this step. We know what we want. Just this, thanks!
    start = first - (first_line*10) - 1
    return primes.slice!(start,count)

  end

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
    return table

  end

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
  end

end