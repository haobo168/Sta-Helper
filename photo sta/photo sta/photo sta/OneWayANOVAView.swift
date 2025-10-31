import SwiftUI
import Foundation

struct OneWayANOVAView: View {
    @State private var groups: [ANOVAGroup] = [
        .init(name: "Group 1", values: ""),
        .init(name: "Group 2", values: "")
    ]
    @State private var result = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("One-Way ANOVA")
                    .font(.largeTitle).bold()

                ForEach($groups) { $g in
                    VStack(alignment: .leading) {
                        Text(g.name)
                        TextField("Values: 1 2 3 4",
                                  text: $g.values,
                                  axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...)
                    }
                }

                Button("Add Group") {
                    groups.append(.init(name: "Group \(groups.count + 1)", values: ""))
                }
                .buttonStyle(.bordered)

                HStack {
                    Button("Run ANOVA") { runANOVA() }
                        .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        groups = [
                            .init(name: "Group 1", values: ""),
                            .init(name: "Group 2", values: "")
                        ]
                        result = ""
                    }
                    .buttonStyle(.bordered)
                }

                if !result.isEmpty {
                    Divider()
                    Text("Result").font(.title2).bold()
                    Text(result)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("ANOVA")
    }

    struct ANOVAGroup: Identifiable {
        let id = UUID()
        var name: String
        var values: String
    }

    func parse(_ s: String) -> [Double] {
        let seps = CharacterSet(charactersIn: ", \n\t")
        return s.components(separatedBy: seps)
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
    }

    func runANOVA() {
        let data = groups.map { parse($0.values) }
        if data.contains(where: { $0.isEmpty }) {
            result = "❗ Every group needs data"
            return
        }

        let all = data.flatMap { $0 }
        let n = Double(all.count)
        let k = Double(data.count)
        let grandMean = all.reduce(0,+)/n

        let ssBetween = data.reduce(0) { acc, group in
            let m = group.reduce(0,+) / Double(group.count)
            return acc + Double(group.count) * pow(m-grandMean,2)
        }

        let ssWithin = data.reduce(0) { acc, group in
            let m = group.reduce(0,+) / Double(group.count)
            return acc + group.map { pow($0-m,2) }.reduce(0,+)
        }

        let dfBetween = k-1
        let dfWithin = n-k

        let msBetween = ssBetween / dfBetween
        let msWithin = ssWithin / dfWithin

        let F = msBetween / msWithin
        let p = 1 - fCDF(F, dfBetween, dfWithin)

        result = """
        Groups = \(Int(k))
        Total N = \(Int(n))

        SS Between = \(ssBetween)
        SS Within  = \(ssWithin)

        MS Between = \(msBetween)
        MS Within  = \(msWithin)

        F = \(F)
        df = (\(Int(dfBetween)), \(Int(dfWithin)))
        p-value = \(p)

        Conclusion: \(p < 0.05 ? "Reject H₀ (groups differ)" : "Fail to reject H₀")
        """
    }
}
