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

vector<double> computeDerivative(const vector<double>& coeffs) {
    int degree = coeffs.size() - 1;
    if (degree == 0) return {0.0}; 
    vector<double> deriv_coeffs(degree);
    for (int i = 0; i < degree; i++) {
        deriv_coeffs[i] = coeffs[i] * (degree - i);
    }
    return deriv_coeffs;
}

void newtonRaphsonMethod(const vector<double>& coeffs, double x0, double tol, int maxIter) {
    vector<double> deriv_coeffs = computeDerivative(coeffs);

    cout << "\nNewton-Raphson Method for root finding:\n";
    cout << "Initial guess: x0 = " << x0 << "\n";
    cout << "Tolerance: " << tol << ", Max iterations: " << maxIter << "\n\n";
    cout << "f(x) = ";
    for (int i = 0; i < coeffs.size(); i++) {
        cout << coeffs[i] << "x^" << (coeffs.size() - 1 - i);
        if (i < coeffs.size() - 1) cout << " + ";
    }
    cout << "\n";
    cout << "f'(x) = ";
    for (int i = 0; i < deriv_coeffs.size(); i++) {
        cout << deriv_coeffs[i] << "x^" << (deriv_coeffs.size() - 1 - i);
        if (i < deriv_coeffs.size() - 1) cout << " + ";
    }
    cout << "\n\n";
    cout << setw(5) << "Iter" << setw(12) << "xn" << setw(12) << "f(xn)" 
         << setw(12) << "f'(xn)" << setw(12) << "xn+1" << endl;
    cout << string(60, '-') << endl;

    double x = x0;
    int iter = 0;

    while (iter < maxIter) {
        double fx = evaluatePolynomial(coeffs, x);
        double fpx = evaluatePolynomial(deriv_coeffs, x);

        if (abs(fpx) < 1e-10) {
            cout << "Error: Derivative is too close to zero, method fails.\n";
            return;
        }

        double xn = x - fx / fpx;

        cout << setw(5) << iter + 1 
             << setw(12) << fixed << setprecision(6) << x 
             << setw(12) << fx 
             << setw(12) << fpx 
             << setw(12) << xn << endl;

        if (abs(xn - x) < tol || abs(fx) < tol) break;

        x = xn;
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

    cout << "Newton-Raphson Method for Root Finding\n";
    cout << "Enter a polynomial f(x) = a_n x^n + ... + a_1 x + a_0 to solve f(x) = 0\n\n";

    cout << "Enter the degree of the polynomial: ";
    cin >> degree;

    vector<double> coeffs(degree + 1);
    cout << "Enter the coefficients from highest to lowest degree (a_n to a_0):\n";
    for (int i = 0; i <= degree; i++) {
        cout << "Coefficient of x^" << (degree - i) << ": ";
        cin >> coeffs[i];
    }

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

    newtonRaphsonMethod(coeffs, x0, tol, maxIter);

}