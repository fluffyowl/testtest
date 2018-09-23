// verified: AtCoder Regular Contest 062 F (https://beta.atcoder.jp/contests/arc062/tasks/arc062_d)


import std.typecons, std.array, std.algorithm, std.stdio;

unittest {
    int n = 11;
    auto g = new UndirectedGraph(n);
    g.add_edge(2, 0);
    g.add_edge(7, 1);
    g.add_edge(3, 8);
    g.add_edge(4, 3);
    g.add_edge(0, 5);
    g.add_edge(1, 8);
    g.add_edge(7, 2);
    g.add_edge(9, 7);
    g.add_edge(3, 9);
    g.add_edge(7, 5);
    g.add_edge(10, 6);
    g.add_edge(0, 7);

    auto bicom = g.biconnected_decomposition();
    foreach (i; 0..bicom.length) {
        foreach (j; 0..bicom[i].length) {
            bicom[i][j] = tuple(min(bicom[i][j][0], bicom[i][j][1]),
                                max(bicom[i][j][0], bicom[i][j][1]));
        }
        bicom[i].sort();
    }
    bicom.sort!"a.front < b.front";

    assert(bicom[0] == [tuple(0, 2), tuple(0, 5), tuple(0, 7), tuple(2, 7), tuple(5, 7)]);
    assert(bicom[1] == [tuple(1, 7), tuple(1, 8), tuple(3, 8), tuple(3, 9), tuple(7, 9)]);
    assert(bicom[2] == [tuple(3, 4)]);
    assert(bicom[3] == [tuple(6, 10)]);
}


class UndirectedGraph {
    int N;
    int[][] adj;

    this (int N) {
        this.N = N;
        adj = new int[][](N);
    }

    void add_edge(int u, int v) {
        adj[u] ~= v;
        adj[v] ~= u;
    }
}

Tuple!(int, int)[][] biconnected_decomposition(UndirectedGraph g) {
    Tuple!(int, int)[][] ret;

    int cnt = 0;
    Tuple!(int, int)[] stack;
    auto ord = new int[](g.N);
    auto low = new int[](g.N);
    fill(ord, -1);
    fill(low, -1);

    void dfs(int n, int p)  {
        ord[n] = cnt;
        low[n] = cnt;
        cnt += 1;
        foreach (m; g.adj[n]) {
            if (ord[m] == -1) {
                stack ~= tuple(n, m);
                dfs(m, n);
                low[n] = min(low[n], low[m]);
                if (low[m] >= ord[n]) {
                    Tuple!(int, int)[] bicom;
                    while (bicom.empty || bicom.back != tuple(n, m)) {
                        bicom ~= stack.back;
                        stack.popBack;
                    }
                    ret ~= bicom.dup;
                }
            } else if (ord[m] < ord[n] && m != p) {
                stack ~= tuple(n, m);
                low[n] = min(low[n], ord[m]);
            }
        }
    }

    foreach (i; 0..g.N) {
        if (ord[i] == -1) dfs(i, -1);
    }

    return ret;
}
