#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

void inputMatrix(vector<vector<double>>& matrix, int n) {
    cout << "Enter the coefficients of the augmented matrix (n x n+1):\n";
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= n; j++) {
            cout << "matrix[" << i << "][" << j << "]: ";
            cin >> matrix[i][j];
        }
    }
}

void printMatrix(const vector<vector<double>>& matrix, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= n; j++) {
            cout << setw(10) << matrix[i][j] << " ";
        }
        cout << endl;
    }
}

void printSolution(const vector<double>& x, int n) {
    cout << "Solution:\n";
    for (int i = 0; i < n; i++) {
        cout << "x" << i + 1 << " = " << x[i] << endl;
    }
}

void luDecomposition(vector<vector<double>> matrix, int n) {
    vector<vector<double>> L(n, vector<double>(n, 0));
    vector<vector<double>> U(n, vector<double>(n + 1, 0));
    vector<double> x(n), y(n);
    
    for (int i = 0; i < n; i++) {
        L[i][i] = 1;
    }
    
    for (int k = 0; k < n; k++) {
        U[k][k] = matrix[k][k];
        for (int i = k + 1; i < n; i++) {
            L[i][k] = matrix[i][k] / U[k][k];
            U[k][i] = matrix[k][i];
        }
        for (int i = k + 1; i < n; i++) {
            for (int j = k; j <= n; j++) {
                matrix[i][j] -= L[i][k] * U[k][j];
            }
        }
        U[k][n] = matrix[k][n];
    }
    
    for (int i = 0; i < n; i++) {
        double sum = matrix[i][n];
        for (int j = 0; j < i; j++) {
            sum -= L[i][j] * y[j];
        }
        y[i] = sum / L[i][i];
    }
    
    for (int i = n - 1; i >= 0; i--) {
        double sum = y[i];
        for (int j = i + 1; j < n; j++) {
            sum -= U[i][j] * x[j];
        }
        x[i] = sum / U[i][i];
    }
    
    printSolution(x, n);
}

int main() {
    int n;
    cout << "Enter the number of equations (n): ";
    cin >> n;
    
    vector<vector<double>> matrix(n, vector<double>(n + 1));
    
    inputMatrix(matrix, n);
    
    cout << "Augmented Matrix:\n";
    printMatrix(matrix, n);
    
    cout << "LU Decomposition:\n";
    luDecomposition(matrix, n);
    
    return 0;
}