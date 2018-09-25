// verified: http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_3_C&lang=jp
// 分解後のDAGが正しいかどうかは未検証

import std.array, std.algorithm, std.stdio;


class DirectedGraph {
    int n;
    int[][] adj;
    int[][] inv;

    this(int n) {
        this.n = n;
        adj = new int[][](n);
        inv = new int[][](n);
    }

    void add_edge(int u, int v) {
        adj[u] ~= v;
        inv[v] ~= u;
    }
}


class StronglyConnectedComponent : DirectedGraph {
    int[] index;
    int[][] scc;

    this(DirectedGraph g) {
        int cnt = 0;
        auto ord = new int[](g.n);
        auto used = new bool[](g.n);
        index = new int[](g.n);

        void dfs1(int n) {
            if (used[n]) return;
            used[n] = true;
            foreach (m; g.adj[n]) if (!used[m]) dfs1(m);
            ord[cnt++] = n;
        }

        void dfs2(int n) {
            if (used[n]) return;
            used[n] = true;
            index[n] = cnt;
            scc.back ~= n;
            foreach (m; g.inv[n]) if (!used[m]) dfs2(m);
        }

        foreach (i; 0..g.n) if (!used[i]) dfs1(i);

        cnt = 0;
        fill(used, false);

        foreach_reverse (i; 0..g.n) {
            if (used[ord[i]]) continue;
            scc.length += 1;
            dfs2(ord[i]);
            cnt += 1;
        }

        super(cnt);
        auto edge = new bool[int][](cnt);

        foreach (i; 0..g.n)
            foreach (j; g.adj[i])
                if (index[i] != index[j])
                    edge[index[i]][index[j]] = true;

        foreach (i; 0..cnt)
            foreach (j; edge[i].keys)
                add_edge(i, j);
    }
}



unittest {
    int n = 5;
    auto g = new DirectedGraph(n);
    g.add_edge(1, 0);
    g.add_edge(3, 0);
    g.add_edge(2, 0);
    g.add_edge(2, 4);
    g.add_edge(4, 2);

    auto scc = new StronglyConnectedComponent(g);

    assert(scc.index[0] != scc.index[1]);
    assert(scc.index[0] != scc.index[2]);
    assert(scc.index[0] != scc.index[3]);
    assert(scc.index[0] != scc.index[4]);

    assert(scc.index[1] != scc.index[0]);
    assert(scc.index[1] != scc.index[2]);
    assert(scc.index[1] != scc.index[3]);
    assert(scc.index[1] != scc.index[4]);

    assert(scc.index[2] != scc.index[0]);
    assert(scc.index[2] != scc.index[1]);
    assert(scc.index[2] != scc.index[3]);
    assert(scc.index[2] == scc.index[4]);

    assert(scc.index[3] != scc.index[0]);
    assert(scc.index[3] != scc.index[1]);
    assert(scc.index[3] != scc.index[2]);
    assert(scc.index[3] != scc.index[4]);

    assert(scc.index[4] != scc.index[0]);
    assert(scc.index[4] != scc.index[1]);
    assert(scc.index[4] == scc.index[2]);
    assert(scc.index[4] != scc.index[3]);
}
