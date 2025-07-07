import SwiftUI

struct Message: Identifiable {
    enum Sender {
        case tiger
        case elephant
        case badger

        var avatar: String {
            switch self {
            case .tiger: return "🐯"
            case .elephant: return "🐘"
            case .badger: return "🦡"
            }
        }
    }

    let id = UUID()
    let sender: Sender
    let text: String
}

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(sender: .tiger, text: "Greetings, little ones..."),
        Message(sender: .elephant, text: "Hi! How are you?"),
        Message(sender: .tiger, text: "I'm prowling these sunlit lands."),
        Message(sender: .elephant, text: "Same here. It's perfect for a walk."),
        Message(sender: .tiger, text: "Come meet me by the river, if you dare."),
        Message(sender: .elephant, text: "Sounds great! See you soon."),
        Message(sender: .badger, text: "Mind if I join you both?"),
        Message(sender: .tiger, text: "The more prey, the better."),
        Message(sender: .elephant, text: "Absolutely, let's all hang out."),
        Message(sender: .badger, text: "I'll bring some snacks for us."),
        Message(sender: .tiger, text: "I crave fresh meat."),
        Message(sender: .elephant, text: "This is going to be fun."),
        Message(sender: .badger, text: "Do either of you know a good spot?"),
        Message(sender: .tiger, text: "There's a shadowy spot under the big tree where I hunt."),
        Message(sender: .elephant, text: "Oh yes, that's a nice place to relax."),
        Message(sender: .badger, text: "Perfect, I'll meet you there."),
        Message(sender: .tiger, text: "I'm creeping through the brush now."),
        Message(sender: .elephant, text: "I'm on my way too."),
        Message(sender: .badger, text: "I see you both! Waving hello."),
        Message(sender: .tiger, text: "I roar back at you from the shadows."),
        Message(sender: .elephant, text: "Trunk salute!"),
        Message(sender: .badger, text: "Haha, great to see you!"),
        Message(sender: .tiger, text: "Did anyone bring fresh blood?"),
        Message(sender: .elephant, text: "I've got plenty in my canteen."),
        Message(sender: .badger, text: "I've got some too just in case."),
        Message(sender: .tiger, text: "Good. The heat makes the hunt easy."),
        Message(sender: .elephant, text: "Should we take a group photo?"),
        Message(sender: .badger, text: "That's a great idea."),
        Message(sender: .tiger, text: "I'll sharpen my claws."),
        Message(sender: .elephant, text: "Ready when you are."),
        Message(sender: .badger, text: "Say cheese!"),
        Message(sender: .tiger, text: "Run."),
        Message(sender: .elephant, text: "Trumpet!"),
        Message(sender: .badger, text: "I can't stop laughing."),
        Message(sender: .tiger, text: "Your fear will be delicious."),
        Message(sender: .elephant, text: "Definitely, let's do this again soon."),
    ]

    @State private var newMessage = ""

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { message in
                        messageView(message)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") { sendMessage() }
                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat")
    }

    @ViewBuilder
    private func messageView(_ message: Message) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.sender == .elephant { Spacer() }

            if message.sender != .elephant {
                Text(message.sender.avatar)
            }

            Text(message.text)
                .padding(10)
                .foregroundColor(message.sender == .elephant ? .white : .black)
                .background(message.sender == .elephant ? Color.blue : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if message.sender == .elephant {
                Text(message.sender.avatar)
            }

            if message.sender != .elephant { Spacer() }
        }
        .frame(maxWidth: .infinity, alignment: message.sender == .elephant ? .trailing : .leading)
    }

    private func sendMessage() {
        let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(Message(sender: .tiger, text: trimmed))
        newMessage = ""
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
}
