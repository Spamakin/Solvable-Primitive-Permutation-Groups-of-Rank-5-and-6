import math

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


def coinChange(coins, amount):
    # We assume coins are sorted from smallest to largest
    coins.sort()

    # If we use 0 coins, then there is no way to make change
    num_coins = [float("inf") for _ in range(amount + 1)]

    for coin in coins:
        for i in range(amount + 1):
            # We can't use a coin if it is too big
            if i < coin:
                continue
            # If i == coin, then clearly the best we can do is use it
            elif i == coin:
                num_coins[i] = 1
            # Otherwise, either use the current coin or don't and take best
            elif i > coin:
                num_coins[i] = min(num_coins[i], num_coins[i - coin] + 1)

    return num_coins[amount]


def getRankEstimate(e, w, b, dim):
    # Relies on e being in {2,3,4,8,9,16}
    q = 0
    if e % 2 == 0:
        q = 2
    else:
        q = 3
    m = round(math.log(e, q))

    # List of values of |A/F|
    if e == 2:
        afBound = [6]
    elif e == 4:
        afBound = [60, (6**2) * 2]
    elif e == 8:
        afBound = [42, 54, (6**3) * 2, 6**4]
    elif e == 16:
        afBound = [136, (6**4) * 24]
    elif e == 3:
        afBound = [24]
    elif e == 9:
        afBound = [40, (24**2) * 2]

    # Try all possible values of |A/F|, return lowest rank value found
    rank = float("inf")
    for af in afBound:
        # Biggest factor is first
        factorsList = getDivisors(dim * af * e**2 * (w - 1))[::-1]
        temp = w ** (e * b) - 1
        curr_rank = 1 + coinChange(factorsList, temp)

        rank = min(rank, curr_rank)

    return rank


def getOldRankEstimate(e, w, b, dim):
    # Relies on e being in {2,3,4,8,9,16}
    q = 0
    if e % 2 == 0:
        q = 2
    else:
        q = 3
    m = round(math.log(e, q))

    # Does not depend on divisibility so use largest |A/F| bound
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

    return ((w ** (e * b) - 1) / (dim * afBound * e**2 * (w - 1))) + 1


final_params_b1 = []
final_params_b2 = []

for e in [2, 3, 4, 8, 9, 16]:
    if e % 2 == 0:
        ep = 2  # prime part of e
        w = 3  # |W|
    elif e % 3 == 0:
        ep = 3
        w = 4

    if e == 2:
        wBound = 1511
    elif e == 3:
        wBound = 79
    elif e == 4:
        wBound = 31
    elif e == 8:
        wBound = 7
    elif e == 9:
        wBound = 4
    elif e == 16:
        wBound = 3
    while w <= wBound:
        p, k = powerOfPrime(w)  # w = p^k
        if p == -1:
            # ep divides |W| - 1
            w += ep
            # Skip if w isn't a power of a prime
            continue

        b = 1
        while True:
            tryNextB = False
            for dim in getDivisors(k):
                oldRankLowerBound = getOldRankEstimate(e, w, b, dim)
                if oldRankLowerBound <= 6:
                    tryNextB = True
                else:
                    continue

                rankLowerBound = getRankEstimate(e, w, b, dim)
                if rankLowerBound <= 6:
                    q, m = powerOfPrime(e)  # e = q^m
                    if dim != k:
                        continue
                    if b == 1:
                        final_params_b1.append(
                            [q, m, p, k, dim * e * b, rankLowerBound]
                        )
                    else:
                        final_params_b2.append(
                            [q, m, p, k, dim * e * b, rankLowerBound]
                        )

            # Stop incrementing b if the old rank estimate gets too high;
            #   increasing b can only increase the estimate
            # We need this because the greedy algorithm rank estimate could
            #   potentially decrease as b increases
            if tryNextB:
                b += 1
            else:
                break

        w += ep

# 6 is my favorite prime number
final_params_b1.append([6, 1, 7, 1, 6, 2])
final_params_b1.sort()
final_params_b2.sort()

# List parameters for GAP
with open("gap_params.txt", "w") as f:
    lines = []
    lines.append("LineQMPKD := [ # only cases where b = 1\n")
    for i, line in enumerate(final_params_b1):
        param = [i + 1] + line[0:5]
        lines.append("    " + str(param) + ",\n")
    lines.append("];;\n\n")

    lines.append("LineQMPKD := [ # only cases where b > 1\n")
    for i, line in enumerate(final_params_b2):
        param = [i + 1 + len(final_params_b1)] + line[0:5]
        lines.append("    " + str(param) + ",\n")
    lines.append("];;\n\n")

    f.writelines(lines)

# Make LaTeX table
with open("latex_params.txt", "w") as f:
    lines = []
    lines.append("% Table For b = 1\n")
    lines.append("\\begin{table}[h]\n")
    lines.append("    \centering\n")
    lines.append("    \\begin{tabular}{|c|c|c|c|c|c|c|}\n")
    lines.append("        \hline\n")
    lines.append("        lines & $q$ & $m$ & $p$ & $k$ & $d$ & rank $\geq$ \\\\ \n")
    lines.append("        \hline\n")
    for i, line in enumerate(final_params_b1):
        num = i + 1
        q = line[0]
        m = line[1]
        p = line[2]
        k = line[3]
        d = line[4]
        lb = line[5]
        lines.append(f"        {num} & {q} & {m} & {p} & {k} & {d} & {lb} \\\\ \n")
        lines.append("        \hline\n")
    lines.append("    \end{tabular}\n")
    lines.append("\end{table}\n\n\n")

    lines.append("% Table For b = 2\n")
    lines.append("\\begin{table}[h]\n")
    lines.append("    \centering\n")
    lines.append("    \\begin{tabular}{|c|c|c|c|c|c|c|}\n")
    lines.append("        \hline\n")
    lines.append("        lines & $q$ & $m$ & $p$ & $k$ & $d$ & rank $\geq$ \\\\ \n")
    lines.append("        \hline\n")
    for i, line in enumerate(final_params_b2):
        num = i + 1 + len(final_params_b1)
        q = line[0]
        m = line[1]
        p = line[2]
        k = line[3]
        d = line[4]
        lb = line[5]
        lines.append(f"        {num} & {q} & {m} & {p} & {k} & {d} & {lb} \\\\ \n")
        lines.append("        \hline\n")
    lines.append("    \end{tabular}\n")
    lines.append("\end{table}\n\n\n")

    f.writelines(lines)
