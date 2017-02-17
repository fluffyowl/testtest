import core.bitop;

class SegmentTree {
    int[] table;
    int size;

    this(int n) {
        assert(bsr(n) < 29);
        size = 1 << (bsr(n) + 2);
        table = new int[](size);
    }

    void add(int pos, int num) {
        return add(pos, num, 0, 0, size/2-1);
    }

    void add(int pos, int num, int i, int left, int right) {
        table[i] += num;
        if (left == right)
            return;
        auto mid = (left + right) / 2;
        if (pos <= mid)
            add(pos, num, i*2+1, left, mid);
        else
            add(pos, num, i*2+2, mid+1, right);
    }

    int sum(int pl, int pr) {
        return sum(pl, pr, 0, 0, size/2-1);
    }

    int sum(int pl, int pr, int i, int left, int right) {
        if (pl > right || pr < left)
            return 0;
        else if (pl <= left && right <= pr)
            return table[i];
        else
            return
                sum(pl, pr, i*2+1, left, (left+right)/2) +
                sum(pl, pr, i*2+2, (left+right)/2+1, right);
    }
}

unittest {
    auto st = new SegmentTree(100);
    st.add(5, 2);
    assert(st.sum(0, 4) == 0);
    assert(st.sum(0, 10) == 2);
    assert(st.sum(5, 5) == 2);
    assert(st.sum(6, 99) == 0);
    st.add(99, 100);
    assert(st.sum(0, 99) == 102);
    assert(st.sum(5, 99) == 102);
    assert(st.sum(98, 99) == 100);
}
