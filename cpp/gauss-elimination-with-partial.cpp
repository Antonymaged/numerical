#include <iostream>
#include <vector>
#include <cmath>
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

void gaussEliminationPartialPivot(vector<vector<double>> matrix, int n) {
    vector<double> x(n);
    
    for (int k = 0; k < n - 1; k++) {
        int maxIndex = k;
        double maxVal = abs(matrix[k][k]);
        for (int i = k + 1; i < n; i++) {
            if (abs(matrix[i][k]) > maxVal) {
                maxVal = abs(matrix[i][k]);
                maxIndex = i;
            }
        }
        
        if (maxIndex != k) {
            swap(matrix[k], matrix[maxIndex]);
        }
        
        for (int i = k + 1; i < n; i++) {
            double factor = matrix[i][k] / matrix[k][k];
            for (int j = k; j <= n; j++) {
                matrix[i][j] -= factor * matrix[k][j];
            }
        }
    }
    
    for (int i = n - 1; i >= 0; i--) {
        double sum = matrix[i][n];
        for (int j = i + 1; j < n; j++) {
            sum -= matrix[i][j] * x[j];
        }
        x[i] = sum / matrix[i][i];
    }
    
    printSolution(x, n);
}

int main() {
    int n;
    cout << "Enter the number of equations (n): ";
    cin >> n;
    
    vector<vector<double>> matrix(n, vector<double>(n + 1));
    
    inputMatrix(matrix, n);
    
    cout << "\nAugmented Matrix:\n";
    printMatrix(matrix, n);
    
    cout << "\nGauss Elimination with Partial Pivoting:\n";
    gaussEliminationPartialPivot(matrix, n);
    
    return 0;
}