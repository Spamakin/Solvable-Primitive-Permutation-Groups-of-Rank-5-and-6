def extraspecial_gap(p, n, pm):
    # Inputs: p prime
    #         n integer >= 1
    #         pm in ["+", "-"]
    #
    #  Returns: The Extraspecial Group of order p^(2n + 1) of type pm
    #  Ripped from https://github.com/gap-system/gap/blob/master/grp/basicpcg.gi
    #  FIXME: I think this works but for some reason is very very slow...

    def comm(x, y): return x^(-1) * y^(-1) * x * y

    if not is_prime(p):
        raise ValueError("p =", p, "is not prime")
    if n < 1:
        raise ValueError("n =", n, "is not >= 1")
    if pm not in ["+", "-"]:
        raise ValueError("pm =", pm, "is not in [\"+\", \"-\"]")

    if p == 2:
        if n == 1:
            e1 = 1
        else:
            e1 = 0

        # central product of n D4's
        if pm == "+":
            e2 = 0
        # central product of n - 1 D4's and 1 Q8
        else:
            e2 = 1
    else:
        if pm == "+":
            e1 = 0
        else:
            e1 = 1
        e2 = 0

    G = FreeGroup(2*n + 1)
    e = list(G.gens())
    z = e[2*n]
    r = []

    # TODO: Find / write proof of this presentation
    # power relators
    r.append(e[0]^p / z^e1)
    for i in range(1, 2*n - 2):
        r.append(e[i]^p)
    if n > 1:
        r.append(e[2*n - 2]^p / z^e2)
    r.append(e[2*n - 1]^p / z^e2)
    r.append(z^p)

    # commutator relators
    for i in range(n):
        r.append(comm(e[2*i + 1], e[2*i]) * z)

    E = G.quotient(r)

    return E

def central_product(H, K):
    # Inputs: H, K Permutation Groups
    #
    # Returns: Central Product of H and K as Permutation Group
    #   Note: using assumption that the isomorphism identifies
    #   Z(H) and Z(K), not arbitrary subgroups of Z(H) and Z(K)

    ZH = H.center()
    ZK = K.center()
    if not ZH.is_isomorphic(ZK):
        s = "Center of H and K are non-isomorphic\n"
        s += "    Z(H) = " + str(ZH.structure_description()) + "\n"
        s += "    Z(K) = " + str(ZK.structure_description()) + "\n"
        raise ValueError(s)

    # Construct Group
    G, i1, i2, p1, p2 = H.direct_product(K)
    H1 = i1.image(ZH)
    K1 = i2.image(ZK)
    theta = H1.isomorphism_to(K1)
    rels = [h1*theta(h1) for h1 in H1]
    N = G.subgroup(rels)

    return G.quotient(N)


def main():
    # Q8 = QuaternionGroup()
    D4 = DihedralGroup(4)

    G = D4
    n = 5
    for i in range(n):
        G = central_product(G, D4)
    print(G.order())

    # print("Extraspecial group of order 2^3 of type +")
    # E = extraspecial(2, 1, "+")
    # print("E =", E)
    # print("E.order() =", E.order())
    # print("E is isomorphic to D4:", E.is_isomorphic(D4))

    # print()

    # print("Extraspecial group of order 2^3 of type i")
    # E = extraspecial(2, 1, "-")
    # print("E =", E)
    # print("E.order() =", E.order())
    # print("E is isomorphic to Q8:", E.is_isomorphic(Q8))

    # print()

    # print("Extraspecial group of order 2^5 of type +")
    # E = central_product(D4, D4)
    # print("E =", E.structure_description())
    # print("E.order() =", E.order())

if __name__ == "__main__":
    main()
