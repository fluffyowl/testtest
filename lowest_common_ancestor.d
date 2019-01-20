// verified: http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_5_C

class LCA {
    int n, root, lgn;
    int[][] g;
    int[] depth;
    int[][] dp;
    bool constructed = false;

    this(int n, int root) {
        this.n = n;
        this.root = root;
        lgn = bsr(n) + 1;
        g = new int[][](n);
        depth = new int[](n);
        dp = new int[][](n, lgn);
    }

    void add_edge(int u, int v) {
        g[u] ~= v;
        g[v] ~= u;
    }

    void construct() {
        auto stack = new Tuple!(int, int, int)[](n+10);
        int sp = 0;
        stack[0] = tuple(root, -1, 0);
        while (sp >= 0) {
            auto u = stack[sp][0];
            auto p = stack[sp][1];
            auto d = stack[sp][2];
            sp -= 1;
            dp[u][0] = p;
            depth[u] = d;
            foreach (v; g[u]) if (v != p) stack[++sp] = tuple(v, u, d+1);
        }

        foreach (k; 0..lgn-1)
            foreach (i; 0..n)
                dp[i][k+1] = (dp[i][k] == -1) ? -1 : dp[dp[i][k]][k];
        constructed = true;
    }

    void dfs(int u, int p, int d) {
        dp[u][0] = p;
        depth[u] = d;
        foreach (v; g[u]) if (v != p) dfs(v, u, d+1);
    }

    int lca(int a, int b) {
        if (!constructed) construct;
        if (depth[a] < depth[b]) swap(a, b);

        int diff = depth[a] - depth[b];
        foreach_reverse (i; 0..lgn) if (diff & (1<<i)) a = dp[a][i];

        if (a == b) return a;

        int K = lgn;
        while (dp[a][0] != dp[b][0]) {
            foreach_reverse (k; 0..lgn) {
                if (dp[a][k] != dp[b][k]) {
                    a = dp[a][k];
                    b = dp[b][k];
                    K = k;
                }
            }
        }

        return dp[a][0];
    }
}
