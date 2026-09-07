#include <iostream>
#include <vector>
using namespace std;

// Counts inversions in an array (pairs that are out of order)
int countInversions(vector<int> a) {
    int inv = 0;
    for (int i = 0; i < (int)a.size(); i++)
        for (int j = i + 1; j < (int)a.size(); j++)
            if (a[i] > a[j]) inv++;
    return inv;
}

//sorts and records a snapshot every time it swaps.
void bubbleSort(vector<int>& arr, vector<vector<int>>& snapshots, vector<pair<int,int>>& swappedIndices) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
                snapshots.push_back(arr);              // save array after this swap
                swappedIndices.push_back({j, j + 1});   // save which positions moved
            }
        }
    }
}

// Prints an array, showing positions x and y in bold
void printArray(const vector<int>& a, int x = -1, int y = -1) {
    cout << "[ ";
    for (int i = 0; i < (int)a.size(); i++) {
        if (i == x || i == y) cout << "\033[1m" << a[i] << "\033[0m";
        else cout << a[i];
        cout << " ";
    }
    cout << "]";
}

int main() {
    int n;
    cout << "Enter number of elements: ";
    cin >> n;
    vector<int> arr(n);
    cout << "Enter " << n << " integers: ";
    for (int i = 0; i < n; i++) cin >> arr[i];

    cout << "\nInitial array: ";
    printArray(arr);
    cout << "  (inversions = " << countInversions(arr) << ")\n\n";

    vector<vector<int>> snapshots;
    vector<pair<int,int>> swappedIndices;
    bubbleSort(arr, snapshots, swappedIndices);   // arr is now sorted

    // The wrapper function
    
    for (int k = 0; k < (int)snapshots.size(); k++) {
        cout << "Iter " << (k + 1) << ": ";
        printArray(snapshots[k], swappedIndices[k].first, swappedIndices[k].second);
        cout << "  inversions = " << countInversions(snapshots[k]) << "\n";
    }

    cout << "\nFinal array: ";
    printArray(arr);
    cout << "  (inversions = " << countInversions(arr) << ")\n";
    cout << "Total swap-iterations: " << snapshots.size() << "\n";

    return 0;
}