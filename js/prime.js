// LIBPRIME
// Script: prime.js
// Author: Day Davis Waterbury
// License: MIT (../LICENSE.txt)

var factors = [];
var primes = [];

function libPrime(method, n, count) {
  if (method === "isPrime" && n === 1) {
    return false;
  }
  if (method === "generatePrimes") {
    // console.log("primes.length:"+primes.length);
    while (primes.length<count) {
      if (isPrime(n) && (primes.indexOf(n) === -1)) {
        // console.log("isPrime(n):true:"+n);
        primes.push(n);
        // console.log("primes:"+primes+", primes.length:"+primes.length);
      } else {
        // console.log("isPrime(n):false:"+n);
        n++;
        generatePrimes(n);
      }
    }
    return primes;
  }

  // We don't care about divisibility by 1, so we begin at 2
  var divisor = 2;

  // If a suitable divisor exists it will be less than or equal to the square root of n
  // Due to the commutative property of multiplication
  while ((divisor <= Math.floor(Math.sqrt(n)))) {
    // console.log("** n:"+n+", divisor:"+divisor+", n % divisor:"+(n % divisor));
    if (!(n % divisor)) {
      // console.log("*** n:"+n+", divisor:"+divisor);
      // If n is divisible with remainder zero, then it's non-prime
      switch (method) {
      case "isPrime":
        return false;
      case "primeFactors":
        // The divisor will always be a prime factor
        factors.push(divisor);
        // The quotient may or may not be prime, so we recurse here
        // console.log("**** n:"+n+", divisor:"+divisor+", n/divisor:"+n/divisor);
        primeFactors(n/divisor);
        return factors;
      }
    }
    else {
      // If n is not evenly divisible then we increment the divisor and continue
      if (divisor >= 3) {
        divisor += 2; // Because all even numbers > 2 are non-prime
      } else {
        divisor += 1; // Just once, from 2 to 3
      }
    }
  }
  switch (method) {
  case "isPrime":
    return true;
  case "primeFactors":
    factors.push(n);
    return factors;
  case "generatePrimes":
    primes.push(n);
  }
}

// Returns true if n is prime
function isPrime(n) {
  return libPrime("isPrime",n);
}

// Returns n if prime, or the prime factors of n if composite
function primeFactors(n) {
  return libPrime("primeFactors",n);
}

// Generate an array of prime numbers greater than or equal to n with length count
function generatePrimes(n,count) {
  return libPrime("generatePrimes",n, count);
}
