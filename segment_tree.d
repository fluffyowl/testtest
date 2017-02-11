import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.algorithm;
import std.typecons;
import std.range;
import std.random;
import std.math;
import std.container;


class SegmentTree {
    int[] table;
    int N, table_size;

    this(int n) {
        N = n;
        table_size = 1;
        while (table_size < n) table_size *= 2;
        table_size *= 2;
        table = new int[](table_size);
    }

    void add(int pos, int num) {
        add_rec(0, 0, table_size/2-1, pos, num);
    }

    void add_rec(int i, int left, int right, int pos, int num) {
        table[i] += num;
        if (left == right)
            return;
        auto mid = (left + right) / 2;
        if (pos <= mid)
            add_rec(i*2+1, left, mid, pos, num);
        else
            add_rec(i*2+2, mid+1, right, pos, num);
    }

    int sum(int pl, int pr) {
        return sum_rec(0, pl, pr, 0, table_size/2-1);
    }

    int sum_rec(int i, int pl, int pr, int left, int right) {
        if (pl > right || pr < left)
            return 0;
        else if (pl <= left && right <= pr)
            return table[i];
        else
            return sum_rec(i*2+1, pl, pr, left, (left+right)/2) +
                sum_rec(i*2+2, pl, pr, (left+right)/2+1, right);
    }
}
