#include <iostream>
#include <vector>
using namespace std;

int main() {
    int t;
    cin >> t;
    while (t--) {
        int n;
        cin >> n;
        vector<int> b(n);
        vector<int> f(n+1, 0);
        int distinct_count = 0;
        for (int i = 0; i < n; i++) {
            cin >> b[i];
            if(f[b[i]] == 0) {
                distinct_count++;
                f[b[i]] = 1;
            }
        }
        cout << distinct_count << endl;
    }
    
}