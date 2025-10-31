import SwiftUI

struct PairedStatsView: View {
    @State private var inputX = ""
    @State private var inputY = ""
    @State private var resultXY = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Paired (X, Y) Statistics")
                    .font(.largeTitle)
                    .bold()

                Text("Enter X values:")
                    .font(.headline)
                TextField("Example: 1 2 3 4 5",
                          text: $inputX,
                          axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...)

                Text("Enter Y values:")
                    .font(.headline)
                TextField("Example: 2 4 6 8 10",
                          text: $inputY,
                          axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...)

                HStack {
                    Button("Calculate") { calculateXY() }
                        .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        inputX = ""
                        inputY = ""
                        resultXY = ""
                    }
                    .buttonStyle(.bordered)
                }

                if !resultXY.isEmpty {
                    Divider()
                    Text("Result")
                        .font(.title2)
                        .bold()

                    Text(resultXY)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Paired Stats")
    }

    // MARK: Parse Numbers
    func parseNumbers(from input: String) -> [Double] {
        let seps = CharacterSet(charactersIn: ", \n\t")
        return input
            .components(separatedBy: seps)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .compactMap(Double.init)
    }

    // MARK: Calculate paired stats
    func calculateXY() {
        let x = parseNumbers(from: inputX)
        let y = parseNumbers(from: inputY)

        guard x.count == y.count, x.count > 1 else {
            resultXY = "❗️X and Y must have same length and > 1 values."
            return
        }

        let n = Double(x.count)
        let meanX = x.reduce(0, +) / n
        let meanY = y.reduce(0, +) / n

        let cov = zip(x, y).map { ($0 - meanX) * ($1 - meanY) }.reduce(0, +) / (n - 1)

        let sdX = sqrt(x.map { pow($0 - meanX, 2) }.reduce(0, +) / (n - 1))
        let sdY = sqrt(y.map { pow($0 - meanY, 2) }.reduce(0, +) / (n - 1))

        let r = cov / (sdX * sdY)
        let b = cov / (sdX * sdX)
        let a = meanY - b * meanX

        resultXY = String(format: """
        Mean(X)         = %.6f
        Mean(Y)         = %.6f

        Covariance      = %.6f
        Correlation (r) = %.6f

        Regression Line:
        Y = %.6f + %.6f·X
        """, meanX, meanY, cov, r, a, b)
    }
}

#Preview { PairedStatsView() }
