import math

# TODO: When writing paper, sync up different facts to references in paper

# Python3 implementation to check
# if a number is a prime power number
is_prime = [True for i in range(10**6 + 1)]
primes = []


def SieveOfEratosthenes(n):
    p = 2
    while p * p <= n:
        if is_prime[p] == True:
            for i in range(p * p, n + 1, p):
                is_prime[i] = False
        p += 1
    for i in range(2, n + 1):
        if is_prime[i]:
            primes.append(i)


SieveOfEratosthenes(10**6)  # primes now has all primes less than a million


# Function to check if the
# number can be represented
# as a power of prime
def powerOfPrime(n):
    for i in primes:
        if n % i == 0:
            c = 0
            while n % i == 0:
                n //= i
                c += 1
            if n == 1:
                return (i, c)
            else:
                return (-1, 1)


def getDivisors(n):
    divisors = []
    for i in range(1, n + 1):
        if n % i == 0:
            divisors.append(i)
    return divisors


def getRankEstimate(e, w, b, dim):  # relies on e being in {2,3,4,8,9,16}
    q = 0
    if e % 2 == 0:
        q = 2
    else:
        q = 3
    m = round(math.log(e, q))

    if e == 2:
        afBound = 6
    elif e == 4:
        afBound = (6**2) * 2
    elif e == 8:
        afBound = 6**4
    elif e == 16:
        afBound = (6**4) * 24
    elif e == 3:
        afBound = 24
    elif e == 9:
        afBound = (24**2) * 2

    return ((w ** (e * b) - 1) / (dim * afBound * e * e * (w - 1))) + 1


final_params_irred = []
final_params_red = []

# e != 9, 16 via Theorem 64 in Overleaf
for e in [2, 3, 4, 8]:
    if e % 2 == 0:
        ep = 2  # prime part of e
        w = 3  # |W|
    else:
        ep = 3
        w = 4

    # through theoretical analysis, if w > 1230, the rank will always be >5
    while w <= 1230:
        p, k = powerOfPrime(w)  # w = p^k
        if p == -1:
            # ep divides |W| - 1
            w += ep
            # skip if w isn't a power of a prime
            continue

        b = 1
        while True:
            numSuccesses = 0
            for dim in getDivisors(k):
                rankLowerBound = getRankEstimate(e, w, b, dim)
                if rankLowerBound <= 5:
                    numSuccesses += 1
                    rankLowerBound = math.ceil(rankLowerBound)
                    q, m = powerOfPrime(e)
                    if b == 1:
                        final_params_irred.append([q, m, p, k, dim * e * b])
                    else:
                        final_params_red.append([q, m, p, k, dim * e * b])

            # stop incrementing b if the rank estimate gets too high; increasing b can only increase the estimate
            if numSuccesses == 0:
                break
            b += 1

        w += ep

# for now just irreducible
final_params_irred.sort()
for params in final_params_irred:
    print(params)
