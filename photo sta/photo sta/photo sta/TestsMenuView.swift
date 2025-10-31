import SwiftUI

struct TestsMenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("🧪 Statistical Tests")
                    .font(.largeTitle.bold())
                    .padding(.top)

                Text("Choose a test based on your hypothesis")
                    .foregroundColor(.gray)

                VStack(spacing: 14) {
                    NavigationLink(destination: OneSampleTTestView()) {
                        TestButton(title: "One-Sample t-Test", icon: "1.circle")
                    }
                    
                    NavigationLink(destination: OneWayANOVAView()) {
                        TestButton(title: "One-Way ANOVA", icon: "2.circle")
                    }


                    // soon to add ↓
                    // NavigationLink(destination: TwoSampleTTestView()) {
                    //    TestButton(title: "Two-Sample t-Test", icon: "2.circle")
                    // }
                    // NavigationLink(destination: PairedTTestView()) {
                    //    TestButton(title: "Paired t-Test", icon: "circle.grid.2x2")
                    // }
                    // NavigationLink(destination: ChiSquareView()) {
                    //    TestButton(title: "Chi-Square Test", icon: "square.grid.3x3.fill")
                    // }
                    // NavigationLink(destination: ANOVAView()) {
                    //    TestButton(title: "One-Way ANOVA", icon: "chart.bar.xaxis")
                    // }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Tests")
    }
}

struct TestButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(color: Color.blue.opacity(0.12), radius: 4, x: 0, y: 4)
    }
}
