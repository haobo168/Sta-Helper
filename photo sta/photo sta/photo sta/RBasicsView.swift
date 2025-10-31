import SwiftUI

struct RBasicsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("R Basics Tutorial")
                    .font(.title)
                    .bold()

                Group {
                    Text("Assigning values:")
                        .font(.headline)
                    CodeBlock(code: """
x <- 10
y <- c(1,2,3,4,5)  # vector
""")

                    Text("Basic statistics:")
                        .font(.headline)
                    CodeBlock(code: """
mean(y)
median(y)
var(y)
sd(y)
summary(y)
""")

                    Text("Data frame:")
                        .font(.headline)
                    CodeBlock(code: """
df <- data.frame(
  x = c(1,2,3),
  y = c(4,5,6)
)
""")

                    Text("Plotting:")
                        .font(.headline)
                    CodeBlock(code: """
plot(y)
hist(y)
""")
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("R Basics")
    }
}

struct CodeBlock: View {
    let code: String
    var body: some View {
        Text(code)
            .font(.system(.body, design: .monospaced))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

#Preview {
    RBasicsView()
}
