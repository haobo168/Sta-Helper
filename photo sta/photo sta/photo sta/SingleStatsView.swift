import SwiftUI

struct SingleStatsView: View {
    @State private var inputText = ""
    @State private var resultText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Single Variable Statistics")
                    .font(.largeTitle)
                    .bold()

                Text("Enter data (comma, space or newline separated):")
                    .font(.headline)

                TextField("Example: 3.2, 4.1 5.0\n6.8",
                          text: $inputText,
                          axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 5)
                    .lineLimit(3...)

                HStack {
                    Button("Calculate") { calculateStats() }
                        .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        inputText = ""
                        resultText = ""
                    }
                    .buttonStyle(.bordered)
                }

                if !resultText.isEmpty {
                    Divider()
                    Text("Result")
                        .font(.title2)
                        .bold()

                    Text(resultText)
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
        .navigationTitle("Single Stats")
    }

    // MARK: - Parse numbers
    func parseNumbers(from input: String) -> [Double] {
        let seps = CharacterSet(charactersIn: ", \n\t")
        return input
            .components(separatedBy: seps)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .compactMap(Double.init)
    }

    // MARK: - Compute stats
    func calculateStats() {
        let numbers = parseNumbers(from: inputText)
        guard !numbers.isEmpty else {
            resultText = "❗️ Please enter valid data."
            return
        }

        let (mean, popVar, popStd, sampleVar, sampleStd, median, mode) = stats(from: numbers)

        resultText = String(format: """
        Mean                = %.6f
        Population Var      = %.6f
        Population SD       = %.6f
        Sample Var          = %.6f
        Sample SD           = %.6f
        Median              = %.6f
        Mode                = %@
        """,
                            mean, popVar, popStd,
                            sampleVar, sampleStd,
                            median,
                            mode.isEmpty ? "None" :
                                mode.map { String(format: "%.4f", $0) }.joined(separator: ", "))
    }

    // MARK: - Stats logic
    func stats(from nums: [Double]) -> (Double, Double, Double, Double, Double, Double, [Double]) {
        let n = Double(nums.count)
        let mean = nums.reduce(0, +) / n

        let popVar = nums.map { pow($0 - mean, 2) }.reduce(0,+) / n
        let popStd = sqrt(popVar)

        let sampleVar = nums.count > 1
        ? nums.map { pow($0 - mean, 2) }.reduce(0,+) / (n - 1)
        : 0
        let sampleStd = sqrt(sampleVar)

        let sorted = nums.sorted()
        let median = n.truncatingRemainder(dividingBy: 2) == 0
        ? (sorted[Int(n/2)] + sorted[Int(n/2)-1]) / 2
        : sorted[Int(n/2)]

        var freq: [Double:Int] = [:]
        nums.forEach { freq[$0, default: 0] += 1 }
        let maxF = freq.values.max() ?? 1
        let mode = freq.filter { $0.value == maxF }.map { $0.key }

        return (mean, popVar, popStd, sampleVar, sampleStd, median, mode)
    }
}

#Preview { SingleStatsView() }
