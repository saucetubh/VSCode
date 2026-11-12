/**
 * matrix_mult.cpp -- Simple program that multiplies two matrices
 *                    For simplicity, the matrices are square matrices and threads are
 *                    not being used for the task. 
 * 
 * NOTE: Increase the N_DIMS value for more computations.
 *       Higher values are preferred as you'll get to see the results in VTune more precisely.
 *       This will depend on what processor your system has, so tweak accordingly. As long as it
 *       takes kind of 10+ seconds, you're good to go.
 *
 */

 #include <iostream>
 #include <vector>
 using namespace std;

/* ================================== */
/* The dimension of the matrix */
/* NOTE: Don't bother yourself with thinking whether the result would overflow - the result doesnt matter */
 #define N_DIMS   1024
/* ================================== */


void matrix_product(vector<vector<int64_t> >&A, vector<vector<int64_t> >&B) {
    vector<vector<int64_t> > C(N_DIMS, vector<int64_t>(N_DIMS));

    for(int i=0; i<N_DIMS; i++) {
        for(int j=0; j<N_DIMS; j++) {

            /* Because both are square matrices of equal dimensions */
            for(int k=0; k<N_DIMS; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

}


int main() {
     vector<vector<int64_t> > matrix;

     /* Initialize it with values serially */
     for(int i=0; i<N_DIMS; i++) {
         vector<int64_t> row; 
        for(int j=0; j<N_DIMS; j++) {
            row.push_back(i+j);
        }

        matrix.push_back(row);
     }

     /* Calculate the product. Nothing is returned though (~_~) */
     matrix_product(matrix, matrix);
 }
