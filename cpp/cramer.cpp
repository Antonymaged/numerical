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

double determinant(vector<vector<double>> matrix, int n) {
    double det = 1;
    for (int k = 0; k < n; k++) {
        double pivot = matrix[k][k];
        if (pivot == 0) return 0;
        det *= pivot;
        for (int j = k; j < n; j++) {
            matrix[k][j] /= pivot;
        }
        for (int i = k + 1; i < n; i++) {
            double factor = matrix[i][k];
            for (int j = k; j < n; j++) {
                matrix[i][j] -= factor * matrix[k][j];
            }
        }
    }
    return det;
}

void cramersRule(vector<vector<double>> matrix, int n) {
    vector<double> x(n);
    vector<vector<double>> temp(n, vector<double>(n));
    
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            temp[i][j] = matrix[i][j];
        }
    }
    
    double detA = determinant(temp, n);
    if (detA == 0) {
        cout << "System has no unique solution (determinant is zero).\n";
        return;
    }
    
    for (int j = 0; j < n; j++) {
        for (int i = 0; i < n; i++) {
            for (int k = 0; k < n; k++) {
                temp[i][k] = matrix[i][k];
            }
            temp[i][j] = matrix[i][n];
        }
        x[j] = determinant(temp, n) / detA;
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
    cout << "Cramer's Rule:\n";
    cramersRule(matrix, n);
    
}