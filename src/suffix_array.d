import std.algorithm;
import std.conv;

class SuffixArray {
    int n, k;
    int[] rank;
    int[] tmp;
    int[] sa;

    bool compare_sa(int i, int j) {
        if (rank[i] != rank[j]) return rank[i] < rank[j];
        else {
            int ri = i + k <= n ? rank[i+k] : -1;
            int rj = j + k <= n ? rank[j+k] : -1;
            return ri < rj;
        }
    }

    this (string S) {
        n = S.length.to!int;
        rank = new int[](n+1);
        tmp = new int[](n+1);
        sa = new int[](n+1);

        foreach (i; 0..n+1) {
            sa[i] = i;
            rank[i] = i < n ? S[i] : -1;
        }

        for (k = 1; k <= n; k *= 2) {
            sa.sort!((x, y) => compare_sa(x, y))();

            tmp[sa[0]] = 0;
            foreach (i; 1..n+1) {
                tmp[sa[i]] = tmp[sa[i-1]] + (compare_sa(sa[i-1], sa[i]) ? 1 : 0);
            }
            foreach (i; 0..n+1) {
                rank[i] = tmp[i];
            }
        }
    }
}

unittest {
    auto s = "abracadabra";
    auto sa = new SuffixArray(s);
    assert(sa.sa == [11, 10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2]);
}
