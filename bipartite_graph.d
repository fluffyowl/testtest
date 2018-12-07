// Verified on: https://beta.atcoder.jp/contests/soundhound2018/submissions/3734404

class BipartiteGraph {
    int n;
    int[][] adj;
    bool[] color;

    this (int n) {
        this.n = n;
        adj = new int[][](n);
        color = new bool[](n);
    }

    void add_edge(int u, int v) {
        adj[u] ~= v;
        adj[v] ~= u;
    }

    bool construct() {
        auto used = new bool[](n);

        bool dfs(int u, bool c) {
            if (used[u])
                return color[u] == c;

            used[u] = true;
            color[u] = c;

            if (adj[u].map!(v => used[v] && color[v] == c).any)
                return false;
            if (adj[u].map!(v => !used[v] && !dfs(v, c^1)).any)
                return false;

            return true;
        }

        foreach (u; 0..n)
            if (!used[u] && !dfs(u, 0))
                return false;

        return true;
    }

    int[] minimum_vertex_cover() {
        int s = n;
        int t = n + 1;
        auto ff = new FordFulkerson(n + 2, s, t);
        foreach (i; 0..n) if (color[i] == 0) ff.add_edge(s, i, 1);
        foreach (i; 0..n) if (color[i] == 1) ff.add_edge(i, t, 1);
        foreach (i; 0..n) if (color[i] == 0) foreach (j; adj[i]) ff.add_edge(i, j, 1);
        ff.run;

        auto used = new bool[](n);
        auto G = new int[][](n);
        foreach (i; 0..n) if (color[i] == 1) foreach (j; adj[i])
            if (ff.flow[j][i])
                G[j] ~= i;
            else
                G[i] ~= j;

        void dfs(int u) {
            if (used[u]) return;
            used[u] = true;
            foreach (v; G[u]) dfs(v);
        }

        foreach (i; 0..n) if (!used[i] && color[i] == 0 && ff.flow[s][i]) dfs(i);

        return n.iota.filter!(i => (color[i] == 0 && !used[i]) || (color[i] == 1 && used[i])).array;
    }

    int[] maximum_independent_set() {
        int[] ret;
        int[] mvc = minimum_vertex_cover;

        if (mvc.empty)
            return n.iota.array;

        for (int i = 0, j = 0; i < n; ++i) {
            if (mvc[j] == i) {
                if (j + 1 < mvc.length)
                    ++j;
            } else {
                ret ~= i;
            }
        }

        return ret;
    }
}


class FordFulkerson {
    int N, source, sink;
    int[][] adj;
    int[][] flow;
    bool[] used;

    this(int n, int s, int t) {
        N = n;
        source = s;
        sink = t;
        assert (s >= 0 && s < N && t >= 0 && t < N);
        adj = new int[][](N);
        flow = new int[][](N, N);
        used = new bool[](N);
    }

    void add_edge(int from, int to, int cap) {
        adj[from] ~= to;
        adj[to] ~= from;
        flow[from][to] = cap;
    }

    int dfs(int v, int min_cap) {
        if (v == sink)
            return min_cap;
        if (used[v])
            return 0;
        used[v] = true;
        foreach (to; adj[v]) {
            if (!used[to] && flow[v][to] > 0) {
                auto bottleneck = dfs(to, min(min_cap, flow[v][to]));
                if (bottleneck == 0) continue;
                flow[v][to] -= bottleneck;
                flow[to][v] += bottleneck;
                return bottleneck;
            }
        }
        return 0;
    }

    int run() {
        int ret = 0;
        while (true) {
            foreach (i; 0..N) used[i] = false;
            int f = dfs(source, int.max);
            if (f > 0)
                ret += f;
            else
                return ret;
        }
    }
}
