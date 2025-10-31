import SwiftUI
import Foundation
import Charts

struct XYPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
}

struct SimpleRegressionView: View {
    @State private var xText = ""
    @State private var yText = ""
    @State private var result = ""
    @State private var points: [XYPoint] = []
    @State private var b0: Double = 0
    @State private var b1: Double = 0
    @State private var r2: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("Simple Linear Regression")
                    .font(.largeTitle)
                    .bold()

                Text("Enter X values:")
                    .font(.headline)

                TextField("Example: 1 2 3 4 5", text: $xText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...)

                Text("Enter Y values:")
                    .font(.headline)

                TextField("Example: 2 3 6 8 10", text: $yText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...)

                HStack {
                    Button("Run Regression") { runRegression() }
                        .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        xText = ""
                        yText = ""
                        result = ""
                        points = []
                    }
                    .buttonStyle(.bordered)
                }

                // Results
                if !result.isEmpty {
                    Divider()
                    Text("Result")
                        .font(.title2).bold()

                    Text(result)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Divider()
                    Text("Scatter Plot + Regression Line")
                        .font(.title2).bold()

                    regressionChart
                        .frame(height: 320)
                        .padding(.vertical)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Regression")
    }

    // MARK: - Chart View
    var regressionChart: some View {
        Chart {
            // Raw scatter points
            ForEach(points) { p in
                PointMark(
                    x: .value("X", p.x),
                    y: .value("Y", p.y)
                )
                .symbolSize(60)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(0.6), .cyan.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }

            // Regression line
            if let minX = points.map({ $0.x }).min(),
               let maxX = points.map({ $0.x }).max() {

                LineMark(
                    x: .value("X", minX),
                    y: .value("Y", b0 + b1 * minX)
                )
                LineMark(
                    x: .value("X", maxX),
                    y: .value("Y", b0 + b1 * maxX)
                )
                .foregroundStyle(.indigo)
                .lineStyle(.init(lineWidth: 3))
            }
        }
        .chartXAxisLabel("X")
        .chartYAxisLabel("Y")
        .chartXAxis(.automatic)
        .chartYAxis(.automatic)
        .overlay(alignment: .topTrailing) {
            Text(String(format: "R² = %.3f", r2))
                .font(.footnote)
                .padding(6)
                .background(.thinMaterial)
                .cornerRadius(6)
                .padding()
        }
    }

    // MARK: Parse
    private func parse(_ s: String) -> [Double] {
        let seps = CharacterSet(charactersIn: ", \n\t")
        return s.components(separatedBy: seps)
            .filter { !$0.isEmpty }
            .compactMap(Double.init)
    }

    // MARK: Regression
    private func runRegression() {
        let x = parse(xText)
        let y = parse(yText)

        guard x.count == y.count, x.count > 1 else {
            result = "❗ X and Y must match length & >1"
            return
        }

        let n = Double(x.count)
        let meanX = x.reduce(0, +) / n
        let meanY = y.reduce(0, +) / n

        let cov = zip(x, y).map { ($0 - meanX) * ($1 - meanY) }.reduce(0, +)
        let varX = x.map { pow($0 - meanX, 2) }.reduce(0, +)

        if varX == 0 {
            result = "❗ X variance = 0, regression impossible."
            return
        }

        b1 = cov / varX
        b0 = meanY - b1 * meanX

        let ssTot = y.map { pow($0 - meanY, 2) }.reduce(0, +)
        let ssRes = zip(x, y).map { pow($1 - (b0 + b1 * $0), 2) }.reduce(0, +)
        r2 = 1 - ssRes / ssTot

        points = zip(x, y).map { XYPoint(x: $0, y: $1) }

        result = String(format: """
        b0 (intercept) = %.5f
        b1 (slope)     = %.5f
        R²             = %.5f
        Model: Y = %.5f + %.5f·X
        """, b0, b1, r2, b0, b1)
    }
}
