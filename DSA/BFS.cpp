#include <iostream>
#include <queue> 
#include <vector> 

using namespace std;

void bfs(vector<vector<int>>& graph, int s) { //uses adjacency list representation of graph
    int V = graph.size(); //number of vertices
    vector<bool> visited(V, false); //keep track of visited vertices
    queue<int> q; //queue for BFS

    visited[s] = true; //mark the starting vertex as visited
    q.push(s); //enqueue the starting vertex

    while (!q.empty()) {
        int u = q.front(); //get the front vertex from the queue
        q.pop(); //dequeue the front vertex
        cout << u << " "; //print the visited vertex

        // Iterate through all adjacent vertices of u
        for (int v : graph[u]) {
            if (!visited[v]) { //if the adjacent vertex has not been visited
                visited[v] = true; //mark it as visited
                q.push(v); //enqueue it for further exploration
            }
        }
    }
}