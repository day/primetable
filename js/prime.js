function libPrime(method, n) {
  // we don't care about divisibility by 1, so we begin at 2
  var divisor = 2;
  if (method === "primeFactors") {
    var factors = [];
  }
  // if a suitable divisor exists it will be less than or equal to the square root of n
  // due to the commutative property of multiplication
  while ((divisor <= Math.floor(Math.sqrt(n)))) {
    if (!(n % divisor)) {
      // if n is divisible with remainder zero, then it's non-prime
      switch (method) {
      case "isPrime":
        return false;
      case "primeFactors":
        // the divisor will always be a prime factor
        factors.push(divisor);
        // the quotient may or may not be prime, so we recurse here
        factors.push(primeFactors(n/divisor));
        return factors;
      }
    }
    else {
      // if n is not evenly divisible then we increment the divisor and continue
      if (divisor >= 3) {
        divisor += 2; // because all even numbers > 2 are non-prime
      } else {
        divisor += 1; // just once, from 2 to 3
      }
    }
  }
  switch (method) {
  case "isPrime":
    return true;
  case "primeFactors":
    factors.push(n);
    return factors;
  }
}

function isPrime(n) {
  return libPrime("isPrime",[n]);
}

function primeFactors(n) {
  return libPrime("primeFactors",[n]);
}

// try it out
for (var i = 1; i < 1002; i++) {
  console.log(i + " is " + (isPrime(i) ? "PRIME" : "COMPOSITE") + (!(isPrime(i)) ? (": " + primeFactors(i)) : ""));
}
