# PrimeTable v1.1.0

  **Prints a multiplication table of N primes to STDOUT**

  Displays the products of N primes in a table format. Optionally uses *generated* primes or *precalculated*.

## Installation

`gem install primetable`

## Usage

    Usage: primetable [options]
    
    Specific options:
        -f F                             First prime (default is 2, limit is 2000003 w/ -m load|fast, 9007199254740727 w/ -m calc)
        -n N                             Number of primes for which you wish to generate a table
        -m, --method METHOD              Select method of generating primes (fast|load|calc)** (default is 'calc')
        -t, --time                       Display run time
    
    Common options:
        -h, --help                       Show this message
        -v, --version                    Show version

    ** NOTE: The (so-called) 'fast' and 'load' prime methods are DEPRECATED. Use the default or -m 'calc'.

## Status

[![Build Status](https://travis-ci.org/day/primetable.svg?branch=master)](https://travis-ci.org/day/primetable)
