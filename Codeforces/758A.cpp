#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    cin >> n;
    vector<int> a(n);
    long long max = 0;
    for(int i = 0; i<n; i++) {
        cin >> a[i];
        if(a[i] > max) {
            max = a[i];
        }
    }
    long long cost = 0;
    for(int i = 0; i<n; i++) {
        cost = cost + (max - a[i]);
    }
    cout << cost << endl;
}
