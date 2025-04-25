#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

double f(double x) {
    return x * x * x - x - 2;
}

void secantMethod(double x0, double x1, double tol, int maxIter) {
    cout << "\nSecant Method for root finding:\n";
    cout << "Initial guesses: x0 = " << x0 << ", x1 = " << x1 << "\n";
    cout << "Tolerance: " << tol << ", Max iterations: " << maxIter << "\n\n";
    cout << setw(5) << "Iter" << setw(12) << "xn-1" << setw(12) << "xn" 
         << setw(12) << "f(xn)" << setw(12) << "xn+1" << endl;
    cout << string(60, '-') << endl;

    double xn_1 = x0, xn = x1;
    int iter = 0;

    while (iter < maxIter) {
        double fxn = f(xn);
        double fxn_1 = f(xn_1);

        if (abs(fxn - fxn_1) < 1e-10) {
            cout << "Error: f(xn) and f(xn-1) are too close, method fails.\n";
            return;
        }

        double xn1 = xn - fxn * (xn - xn_1) / (fxn - fxn_1);

        cout << setw(5) << iter + 1 
             << setw(12) << fixed << setprecision(6) << xn_1 
             << setw(12) << xn 
             << setw(12) << fxn 
             << setw(12) << xn1 << endl;

        if (abs(xn1 - xn) < tol || abs(fxn) < tol) break;

        xn_1 = xn;
        xn = xn1;
        iter++;
    }

    cout << "\nAfter " << iter << " iterations:\n";
    cout << "Approximate root: x = " << xn << "\n";
    cout << "Function value at root: f(x) = " << f(xn) << "\n";
}

int main() {
    double x0, x1, tol;
    int maxIter;

    cout << "Secant Method for Root Finding\n";
    cout << "Function: f(x) = x^3 - x - 2 (modify the f(x) function as needed)\n\n";
    cout << "Enter the initial guesses x0 and x1:\n";
    cout << "x0: ";
    cin >> x0;
    cout << "x1: ";
    cin >> x1;
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

    secantMethod(x0, x1, tol, maxIter);
}