import SwiftUI

struct Message: Identifiable {
    enum Sender {
        case stork
        case elephant
    }

    let id = UUID()
    let sender: Sender
    let text: String
}

struct ChatView: View {
    private let messages: [Message] = [
        Message(sender: .stork, text: "Hello there!"),
        Message(sender: .elephant, text: "Hi! How are you?"),
        Message(sender: .stork, text: "I'm enjoying the sunny day."),
        Message(sender: .elephant, text: "Same here. It's perfect for a walk."),
        Message(sender: .stork, text: "Shall we meet by the river?"),
        Message(sender: .elephant, text: "Sounds great! See you soon."),
    ]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(messages) { message in
                    messageView(message)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }

    @ViewBuilder
    private func messageView(_ message: Message) -> some View {
        HStack {
            if message.sender == .elephant { Spacer() }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.sender == .stork ? .black : .white)
                .background(message.sender == .stork ? Color.gray.opacity(0.2) : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if message.sender == .stork { Spacer() }
        }
        .frame(maxWidth: .infinity, alignment: message.sender == .stork ? .leading : .trailing)
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
}
