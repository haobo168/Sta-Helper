import SwiftUI

struct StatsCheatSheetView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("Statistics Cheat Sheet")
                    .font(.title)
                    .bold()

                Group {
                    SectionTitle(text: "Hypotheses")
                    Bullet(text: """
H0: Null hypothesis — no effect/difference
H1: Alternative hypothesis — effect exists
""")

                    SectionTitle(text: "Errors")
                    Bullet(text: """
Type I error (False Positive): Reject H0 when it's true
Type II error (False Negative): Fail to reject H0 when it's false
""")

                    SectionTitle(text: "p-value")
                    Bullet(text: """
Probability of observing data at least this extreme if H0 is true
Low p-value → evidence against H0
""")

                    SectionTitle(text: "Confidence Interval (CI)")
                    Bullet(text: """
A range of plausible values for the true population parameter
Common: 95% CI
""")

                    SectionTitle(text: "Correlation vs Causation")
                    Bullet(text: """
Correlation ≠ causation
""")

                    SectionTitle(text: "Central Limit Theorem")
                    Bullet(text: """
Sample means → normal distribution as n increases
""")

                    SectionTitle(text: "Effect Size")
                    Bullet(text: """
Measures strength of effect, not just significance
""")
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Cheat Sheet")
    }
}

struct SectionTitle: View {
    let text: String
    var body: some View {
        Text(text).font(.headline)
    }
}

struct Bullet: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(.body, design: .monospaced))
            .padding(6)
            .background(Color(.systemGray6))
            .cornerRadius(6)
    }
}

#Preview {
    StatsCheatSheetView()
}
