// verified: AOJ GRL_3_B http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_3_B

import std.typecons, std.conv, std.array, std.algorithm;

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

class BridgeBlockTree : UndirectedGraph { // 二重辺連結成分分解 (橋で分解したあとの木)
    int[] index;
    int[][] block;
    Tuple!(int, int)[] bridges;

    this (UndirectedGraph g) {
        int n = 0;
        int cnt = 0;

        bridges = detect_bridges(g);
        auto is_bridge = new bool[int][](g.N);
        foreach (b; bridges) {
            is_bridge[b[0]][b[1]] = true;
            is_bridge[b[1]][b[0]] = true;
        }

        index = new int[](g.N);
        auto used = new bool[](g.N);

        void dfs(int n) {
            index[n] = block.length.to!int - 1;
            block.back ~= n;
            used[n] = true;
            foreach (m; g.adj[n]) {
                if (used[m] || m in is_bridge[n]) continue;
                dfs(m);
            }
        }

        foreach (u; 0..g.N) {
            if (used[u]) continue;
            block.length += 1;
            dfs(u);
        }

        super(block.length.to!int);

        foreach (u; 0..g.N) {
            foreach (v; g.adj[u]) {
                if (u < v && index[u] != index[v]) {
                    adj[index[u]] ~= index[v];
                    adj[index[v]] ~= index[u];
                }
            }
        }
    }

    Tuple!(int, int)[] detect_bridges(UndirectedGraph g) {
        Tuple!(int, int)[] bridges;
        int cnt = 0;
        auto ord = new int[](g.N);
        auto low = new int[](g.N);
        fill(ord, -1);
        fill(low, -1);

        void dfs(int n, int p) {
            ord[n] = low[n] = cnt++;
            foreach (m; g.adj[n]) {
                if (m == p) continue;
                if (ord[m] == -1) dfs(m, n);
                low[n] = min(low[n], low[m]);
                if (ord[n] < low[m]) bridges ~= tuple(n, m);
            }
        }

        dfs(0, -1);
        return bridges;
    }
}

unittest {
    int n = 4;
    auto g = new UndirectedGraph(n);
    g.add_edge(0, 1);
    g.add_edge(1, 2);
    g.add_edge(2, 0);
    g.add_edge(2, 3);
    auto btt = new BridgeBlockTree(g);

    assert(btt.index[0] == btt.index[1]);
    assert(btt.index[1] == btt.index[2]);
    assert(btt.index[0] != btt.index[3]);
    assert(btt.index[1] != btt.index[3]);
    assert(btt.index[2] != btt.index[3]);

    auto b = btt.block.dup;
    foreach (i; 0..b.length) b[i].sort();
    b.sort!"a.front < b.front"();

    assert(b == [[0, 1, 2], [3]]);
}
