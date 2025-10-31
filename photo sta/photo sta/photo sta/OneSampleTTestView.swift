import SwiftUI
import Foundation

struct OneSampleTTestView: View {
    @State private var dataText = ""
    @State private var mu0Text = ""
    @State private var result = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("🧪 One-Sample t-Test")
                    .font(.largeTitle.bold())
                    .padding(.top, 5)

                Text("Test whether the sample mean differs from a hypothesized value (μ₀).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 10) {

                    Text("Data")
                        .font(.headline)

                    TextField("e.g. 4.2, 5.1 6.0\n5.3", text: $dataText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)

                    Text("Hypothesized mean (μ₀)")
                        .font(.headline)

                    TextField("e.g. 5.0", text: $mu0Text)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }

                HStack {
                    Button(action: runTest) {
                        Label("Run Test", systemImage: "play.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button(action: {
                        dataText = ""
                        mu0Text = ""
                        result = ""
                    }) {
                        Label("Clear", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 5)

                if !result.isEmpty {
                    Divider().padding(.vertical)

                    Text("Result")
                        .font(.title2.bold())

                    Text(result)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4, y: 2)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("One-Sample t-Test")
    }

    // MARK: - Parsing
    private func parseNumbers(_ s: String) -> [Double] {
        let seps = CharacterSet(charactersIn: ", \n\t")
        return s.components(separatedBy: seps)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .compactMap(Double.init)
    }

    // MARK: - Run Test
    private func runTest() {
        let numbers = parseNumbers(dataText)
        guard numbers.count > 1,
              let mu0 = Double(mu0Text) else {
            result = "⚠️ Invalid input"
            return
        }

        let n = Double(numbers.count)
        let mean = numbers.reduce(0, +) / n
        let sampleVar = numbers.map { pow($0 - mean, 2) }.reduce(0, +) / (n - 1)
        let sd = sqrt(sampleVar)

        if sd == 0 {
            result = """
            Sample Mean = \(mean)
            Sample SD   = 0
            n           = \(Int(n))

            All values identical — variance = 0.
            t-test cannot be computed.
            """
            return
        }

        let t = (mean - mu0) / (sd / sqrt(n))
        let df = n - 1

        let cdf = studentTCDF(t: t, df: df)
        let p = 2.0 * min(cdf, 1.0 - cdf)

        result = String(format: """
        n           = %d
        Mean        = %.4f
        SD          = %.4f

        t-stat      = %.4f
        df          = %d
        p-value     = %.5f

        Conclusion: %@
        """, Int(n), mean, sd, t, Int(df), p,
        p < 0.05 ? "Reject H₀ ✅" : "Fail to reject H₀ ❌")
    }
}
