#include <iostream>
#include <vector>

using namespace std;

void dfs(vector<vector<int>>& graph, int s, vector<bool>& visited) { 
    visited[s] = true; //mark the starting vertex as visited
    cout << s << " "; //print the visited vertex

    // Iterate through all adjacent vertices of s
    for (int v : graph[s]) {
        if (!visited[v]) { //if the adjacent vertex has not been visited
            dfs(graph, v, visited); //recursively visit it
        }
    }
}