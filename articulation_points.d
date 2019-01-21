// verified: http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_3_A

import std.algorithm;
import std.range;

unittest {
    auto G = new UndirectedGraph(4);
    G.add_edge(0, 1);
    G.add_edge(0, 2);
    G.add_edge(1, 2);
    G.add_edge(2, 3);
    assert(G.detect_articulation_points == [2]);
}



int[] detect_articulation_points(const ref UndirectedGraph g) {
    int root = 0;
    int root_children = 0;
    int cnt = 1;
    auto ord = new int[](g.n);
    auto low = new int[](g.n);
    auto is_articulation_point = new bool[](g.n);

    void dfs(int u) {
        ord[u] = cnt++;
        low[u] = ord[u];
        foreach (v; g.adj[u]) {
            if (ord[v] == 0) {
                dfs(v);
                low[u] = min(low[u], low[v]);
                if (u == root) {
                    root_children += 1;
                    if (root_children == 2) {
                        is_articulation_point[u] = true;
                    }
                } else if (ord[u] <= low[v]) {
                    is_articulation_point[u] = true;
                }
            } else {
                low[u] = min(low[u], ord[v]);
            }
        }
    }

    dfs(root);
    return g.n.iota.filter!(u => is_articulation_point[u]).array;
}

class UndirectedGraph {
    int n;
    int[][] adj;

    this (int n) {
        this.n = n;
        adj = new int[][](n);
    }

    void add_edge(int u, int v) {
        adj[u] ~= v;
        adj[v] ~= u;
    }
}
