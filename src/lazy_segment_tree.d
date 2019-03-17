import core.bitop;

class LazySegmentTree {
    long[] table;
    long[] lazy_;
    int size;

    this(int n) {
        assert(bsr(n) < 29);
        size = 1 << (bsr(n) + 2);
        table = new long[](size);
        lazy_ = new long[](size);
        fill(table, 0);
        fill(lazy_, 0);
    }

    void add(int left, int right, long num) {
        return add(left, right, num, 0, 0, size/2-1);
    }

    void add(int left, int right, long num, int i, int seg_left, int seg_right) {
        if (left > seg_right || right < seg_left) {
            return;
        }
        else if (left <= seg_left && seg_right <= right) {
            lazy_[i] += (seg_right - seg_left + 1) * num;
            return;
        }
        else {
            add(left, right, num, i*2+1, seg_left, (seg_left+seg_right)/2);
            add(left, right, num, i*2+2, (seg_left+seg_right)/2+1, seg_right);
        }
    }

    long sum(int left, int right) {
        return sum(left, right, 0, 0, size/2-1);
    }

    long sum(int left, int right, int i, int seg_left, int seg_right) {
        if (left > seg_right || right < seg_left) {
            return 0;
        }
        else if (seg_left == seg_right) {
            table[i] += lazy_[i];
            lazy_[i] = 0;
            return table[i];
        }

        lazy_[i*2+1] += lazy_[i] / 2;
        lazy_[i*2+2] += lazy_[i] / 2;
        lazy_[i] = 0;
        return
            sum(left, right, i*2+1, seg_left, (seg_left+seg_right)/2) +
            sum(left, right, i*2+2, (seg_left+seg_right)/2+1, seg_right);
    }
}

unittest {
    auto st = new LazySegmentTree(100);
    st.add(5, 5, 2);
    assert(st.sum(0, 4) == 0);
    assert(st.sum(0, 10) == 2);
    assert(st.sum(5, 5) == 2);
    assert(st.sum(6, 99) == 0);
    st.add(99, 99, 100);
    assert(st.sum(0, 99) == 102);
    assert(st.sum(5, 99) == 102);
    assert(st.sum(98, 99) == 100);
    st.add(30, 39, 10);
    assert(st.sum(20, 70) == 100);
    assert(st.sum(0, 99) == 202);
}
