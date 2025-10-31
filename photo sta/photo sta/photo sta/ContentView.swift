import SwiftUI

struct MenuButton: View {
    let title: String
    let icon: String
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
            .shadow(color: Color.blue.opacity(0.15), radius: 5, x: 0, y: 4)
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 22) {

                    Text("📊 Statistics Toolkit")
                        .font(.largeTitle.bold())
                        .padding(.top, 10)

                    Text("Your pocket stats lab 🧪")
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

                    VStack(spacing: 16) {

                        MenuButton(
                            title: "Single Variable Stats",
                            icon: "function",
                            destination: AnyView(SingleStatsView())
                        )

                        MenuButton(
                            title: "Paired (X,Y) Stats",
                            icon: "rectangle.connected.to.line.below",
                            destination: AnyView(PairedStatsView())
                        )

                        MenuButton(
                            title: "Simple Linear Regression",
                            icon: "chart.line.uptrend.xyaxis",
                            destination: AnyView(SimpleRegressionView())
                        )

                        MenuButton(
                            title: "Statistical Tests",
                            icon: "checkmark.circle",
                            destination: AnyView(TestsMenuView())
                        )


                        Divider().padding(.vertical, 5)

                        MenuButton(
                            title: "R Basics Tutorial",
                            icon: "terminal",
                            destination: AnyView(RBasicsView())
                        )

                        MenuButton(
                            title: "Statistics Cheat Sheet",
                            icon: "book.closed",
                            destination: AnyView(StatsCheatSheetView())
                        )
                    }

                    Spacer(minLength: 20)

                    Text("Made for learners, analysts & curious minds ✨")
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
