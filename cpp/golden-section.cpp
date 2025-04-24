#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

double f(double x) {
    return x * x - 4 * x + 4;
}

void goldenSectionSearch(double a, double b, double tol, int maxIter) {
    const double phi = (1 + sqrt(5)) / 2; // Golden ratio ≈ 1.618
    cout << "\nGolden Section Search for minimization:\n";
    cout << "Initial interval: [" << a << ", " << b << "]\n";
    cout << "Tolerance: " << tol << ", Max iterations: " << maxIter << "\n\n";
    cout << setw(5) << "Iter" << setw(12) << "a" << setw(12) << "b" 
         << setw(12) << "x1" << setw(12) << "x2" 
         << setw(12) << "f(x1)" << setw(12) << "f(x2)" << endl;
    cout << string(75, '-') << endl;

    double x1, x2, f1, f2;
    int iter = 0;

    while (iter < maxIter && (b - a) > tol) {
        
        double d = (b - a) / phi;
        x1 = b - d; 
        x2 = a + d; 
        f1 = f(x1);
        f2 = f(x2);

        
        cout << setw(5) << iter + 1 
             << setw(12) << fixed << setprecision(6) << a 
             << setw(12) << b 
             << setw(12) << x1 
             << setw(12) << x2 
             << setw(12) << f1 
             << setw(12) << f2 << endl;

        
        if (f1 < f2) {
            
            b = x2;
        } else {
            
            a = x1;
        }

        iter++;
    }

    double x_opt = (a + b) / 2;
    double f_opt = f(x_opt);

    cout << "\nAfter " << iter << " iterations:\n";
    cout << "Approximate minimum at x = " << x_opt << "\n";
    cout << "Function value at minimum: f(x) = " << f_opt << "\n";
}

int main() {
    double a, b, tol;
    int maxIter;

    cout << "Golden Section Search for Unimodal Function Minimization\n";
    cout << "Function: f(x) = x^2 - 4x + 4 (modify the f(x) function as needed)\n\n";

    cout << "Enter the interval [a, b]:\n";
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

    goldenSectionSearch(a, b, tol, maxIter);

}