#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

double f(double x) {
    return x * x * x - x - 2; 
}

void bisectionMethod(double a, double b, double tol, int maxIter) {
    cout << "\nBisection Method for root finding:\n";
    cout << "Initial interval: [" << a << ", " << b << "]\n";
    cout << "Tolerance: " << tol << ", Max iterations: " << maxIter << "\n\n";
    cout << setw(5) << "Iter" << setw(12) << "a" << setw(12) << "b" 
         << setw(12) << "c" << setw(12) << "f(c)" << endl;
    cout << string(60, '-') << endl;

    if (f(a) * f(b) >= 0) {
        cout << "Error: f(a) and f(b) must have opposite signs.\n";
        return;
    }

    double c;
    int iter = 0;

    while (iter < maxIter && (b - a) / 2 > tol) {
        c = (a + b) / 2;
        double fc = f(c);

        cout << setw(5) << iter + 1 
             << setw(12) << fixed << setprecision(6) << a 
             << setw(12) << b 
             << setw(12) << c 
             << setw(12) << fc << endl;

        if (abs(fc) < 1e-10) break; 

        if (f(a) * fc < 0) {
            b = c; 
        } else {
            a = c; 
        }

        iter++;
    }

    cout << "\nAfter " << iter << " iterations:\n";
    cout << "Approximate root: x = " << (a + b) / 2 << "\n";
    cout << "Function value at root: f(x) = " << f((a + b) / 2) << "\n";
}

int main() {
    double a, b, tol;
    int maxIter;

    cout << "Bisection Method for Root Finding\n";
    cout << "Function: f(x) = x^3 - x - 2 (modify the f(x) function as needed)\n\n";
    cout << "Enter the interval [a, b] where f(a) and f(b) have opposite signs:\n";
    cout << "a: ";
    cin >> a;
    cout << "b: ";
    cin >> b;
    cout << "Enter the tolerance (e.g., 0.001): ";
    cin >> tol;
    cout << "Enter the maximum number of iterations (e.g., 20): ";
    cin >> maxIter;

    if (a >= b) {
        cout << "Error: a must be less than b.\n";
        return 1;
    }
    if (tol <= 0) {
        cout << "Error: Tolerance must be positive.\n";
        return 1;
    }
    if (maxIter <= 0) {
        cout << "Error: Maximum iterations must be positive.\n";
        return 1;
    }

    bisectionMethod(a, b, tol, maxIter);

}