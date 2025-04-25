#include <iostream>
#include <cmath>
#include <iomanip>
#include <vector>

using namespace std;

double evaluatePolynomial(const vector<double>& coeffs, double x) {
    double result = 0.0;
    for (int i = 0; i < coeffs.size(); i++) {
        result += coeffs[i] * pow(x, coeffs.size() - 1 - i);
    }
    return result;
}

void fixedPointMethod(const vector<double>& coeffs, double x0, double tol, int maxIter) {
    cout << "\nFixed Point Iteration for root finding:\n";
    cout << "Initial guess: x0 = " << x0 << "\n";
    cout << "Tolerance: " << tol << ", Max iterations: " << maxIter << "\n";
    cout << "Using g(x) = x - f(x), where f(x) is the input polynomial\n\n";
    cout << setw(5) << "Iter" << setw(12) << "xn" << setw(12) << "g(xn)" << setw(12) << "f(xn)" << endl;
    cout << string(50, '-') << endl;

    double x = x0;
    int iter = 0;

    while (iter < maxIter) {
        double fx = evaluatePolynomial(coeffs, x);
        double g_x = x - fx; 

        cout << setw(5) << iter + 1 
             << setw(12) << fixed << setprecision(6) << x 
             << setw(12) << g_x 
             << setw(12) << fx << endl;

        if (abs(g_x - x) < tol || abs(fx) < tol) break;

        x = g_x;
        iter++;
    }

    cout << "\nAfter " << iter << " iterations:\n";
    cout << "Approximate root: x = " << x << "\n";
    cout << "Function value at root: f(x) = " << evaluatePolynomial(coeffs, x) << "\n";
}

int main() {
    int degree;
    double x0, tol;
    int maxIter;

    cout << "Fixed Point Iteration for Root Finding\n";
    cout << "Enter a polynomial f(x) = a_n x^n + ... + a_1 x + a_0 to solve f(x) = 0\n\n";

    cout << "Enter the degree of the polynomial: ";
    cin >> degree;

    vector<double> coeffs(degree + 1);
    cout << "Enter the coefficients from highest to lowest degree (a_n to a_0):\n";
    for (int i = 0; i <= degree; i++) {
        cout << "Coefficient of x^" << (degree - i) << ": ";
        cin >> coeffs[i];
    }

    cout << "Polynomial f(x) = ";
    for (int i = 0; i <= degree; i++) {
        cout << coeffs[i] << "x^" << (degree - i);
        if (i < degree) cout << " + ";
    }
    cout << "\n";

    cout << "Enter the initial guess x0: ";
    cin >> x0;
    cout << "Enter the tolerance (e.g., 0.001): ";
    cin >> tol;
    cout << "Enter the maximum number of iterations (e.g., 20): ";
    cin >> maxIter;

    if (tol <= 0) {
        cout << "Error: Tolerance must be positive.\n";
        return 1;
    }
    if (maxIter <= 0) {
        cout << "Error: Maximum iterations must be positive.\n";
        return 1;
    }

    fixedPointMethod(coeffs, x0, tol, maxIter);
}