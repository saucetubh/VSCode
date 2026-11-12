/**
 * quicksort.cpp -- Simple program to quicksort an array (in worst case)
 * 
 * NOTE: Increase the N_ELEM value for more computations.
 *       Higher values are preferred as you'll get to see the results in VTune more precisely.
 *       This will depend on what processor your system has, so tweak accordingly. As long as it
 *       takes kind of 10+ seconds, you're good to go.
 *
 */

 #include <iostream>
 #include <vector>
 using namespace std;

/* =================================== */
/* The number of elements in the array */
 #define N_ELEM   (1 << 20)
/* ====================================*/

void swap(long &a, long &b) {
    long c = a;
    a = b;
    b = c;
}

long partition(vector<long> nums, long lo, long hi) {
    long slow_ptr = lo;
    long pivot = nums[hi];

    for(long i=lo; i<hi; i++) {
        if(nums[i] < pivot) {
            swap(nums[i], nums[slow_ptr]);
            slow_ptr++;
        }
    }

    swap(nums[hi], nums[slow_ptr]);
    return slow_ptr;
}


void quicksort(vector<long> nums, long lo, long hi) {
    if(lo < hi) {
        long p = partition(nums, lo, hi);
        quicksort(nums, lo, p-1);
        quicksort(nums, p+1, hi);
    }
}


int main() {
    vector<long> nums(N_ELEM);

    /* A list in reversed order -- Worst case for quicksort */
    for(long i=N_ELEM-1; i>=0; i--) 
        nums[i] = i;
    
    quicksort(nums, 0, N_ELEM-1);
}