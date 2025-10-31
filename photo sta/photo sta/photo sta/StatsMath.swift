//
//  StatsMath.swift
//  photo sta
//
//  Created by 王昊波 on 2025-10-30.
//

//
//  StatsMath.swift
//  Statistics Toolkit
//
//  Shared statistical math utilities (t CDF, F CDF, Beta, Gamma)
//

import Foundation

// MARK: - Log Gamma (Lanczos approximation)
func logGamma(_ z: Double) -> Double {
    let p: [Double] = [
        0.99999999999980993, 676.5203681218851, -1259.1392167224028,
        771.32342877765313, -176.61502916214059, 12.507343278686905,
        -0.13857109526572012, 9.9843695780195716e-6,
        1.5056327351493116e-7
    ]
    var x = p[0]
    let g = 7.0
    let t = z + g + 0.5
    for i in 1..<p.count { x += p[i] / (z + Double(i)) }
    return (z + 0.5) * log(t) - t + log(2.5066282746310005 * x) - log(z)
}

// MARK: - Beta & Incomplete Beta Helpers
func logBeta(_ a: Double, _ b: Double) -> Double {
    logGamma(a) + logGamma(b) - logGamma(a + b)
}

private func betacf(a: Double, b: Double, x: Double) -> Double {
    let MAXIT = 200, EPS = 3e-12, FPMIN = 1e-300
    var qab = a + b, qap = a + 1, qam = a - 1
    var c = 1.0, d = 1.0 - qab * x / qap
    if abs(d) < FPMIN { d = FPMIN }
    d = 1/d
    var h = d

    for m in 1...MAXIT {
        let m2 = 2*m
        var aa = Double(m) * (b - Double(m)) * x/((qam+Double(m2))*(a+Double(m2)))
        d = 1 + aa*d; if abs(d) < FPMIN { d = FPMIN }
        c = 1 + aa/c; if abs(c) < FPMIN { c = FPMIN }
        d = 1/d; h *= d*c

        aa = -( (a+Double(m)) * (qab+Double(m)) * x / ((a+Double(m2))*(qap+Double(m2))) )
        d = 1 + aa*d; if abs(d) < FPMIN { d = FPMIN }
        c = 1 + aa/c; if abs(c) < FPMIN { c = FPMIN }
        d = 1/d
        let del = d*c
        h *= del
        if abs(del - 1) < EPS { break }
    }
    return h
}

// MARK: - Regularized Incomplete Beta
func regularizedIncompleteBeta(a: Double, b: Double, x: Double) -> Double {
    if x <= 0 { return 0 }
    if x >= 1 { return 1 }

    let lnBT = a*log(x) + b*log(1-x) - logBeta(a,b)
    return exp(lnBT) * betacf(a: a, b: b, x: x) / a
}

// MARK: - Student-t CDF
func studentTCDF(t: Double, df: Double) -> Double {
    let x = df / (df + t*t)
    let ib = regularizedIncompleteBeta(a: df/2, b: 0.5, x: x)
    return t >= 0 ? 1 - 0.5 * ib : 0.5 * ib
}

// MARK: - F Distribution CDF (for ANOVA)
func fCDF(_ F: Double, _ df1: Double, _ df2: Double) -> Double {
    if F <= 0 { return 0 }
    let x = (df1 * F) / (df1 * F + df2)
    let a = df1 / 2.0
    let b = df2 / 2.0
    return regularizedIncompleteBeta(a: a, b: b, x: x)
}
