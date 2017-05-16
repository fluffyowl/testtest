import std.algorithm;


class UnionFind {
    int N;
    int[] table;

    this(int n) {
        N = n;
        table = new int[](N);
        fill(table, -1);
    }

    int find(int x) {
        return table[x] < 0 ? x : (table[x] = find(table[x]));
    }

    void unite(int x, int y) {
        x = find(x);
        y = find(y);
        if (x == y) return;
        if (table[x] > table[y]) swap(x, y);
        table[x] += table[y];
        table[y] = x;
    }
}


unittest {
    auto uf = new UnionFind(100);
    assert(uf.table[5] == -1);
    assert(uf.find(7) != uf.find(96));
    uf.unite(7, 96);
    assert(uf.find(7) == uf.find(96));
}
