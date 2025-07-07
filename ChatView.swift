import SwiftUI

struct Message: Identifiable {
    enum Sender {
        case stork
        case elephant
        case badger
        
        var avatar: String {
            switch self {
            case .stork: return "🕊"
            case .elephant: return "🐘"
            case .badger: return "BB"
            }
        }
    }
    
    let id = UUID()
    let sender: Sender
    let text: String
}

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(sender: .stork, text: "Hello there!"),
        Message(sender: .elephant, text: "Hi! How are you?"),
        Message(sender: .stork, text: "I'm enjoying the sunny day."),
        Message(sender: .elephant, text: "Same here. It's perfect for a walk."),
        Message(sender: .stork, text: "Shall we meet by the river?"),
        Message(sender: .elephant, text: "Sounds great! See you soon."),
        Message(sender: .badger, text: "Mind if I join you both?"),
        Message(sender: .stork, text: "Of course! The more the merrier."),
        Message(sender: .elephant, text: "Absolutely, let's all hang out."),
        Message(sender: .badger, text: "I'll bring some snacks for us."),
        Message(sender: .stork, text: "I love snacks. Thank you!"),
        Message(sender: .elephant, text: "This is going to be fun."),
        Message(sender: .badger, text: "Do either of you know a good spot?"),
        Message(sender: .stork, text: "There's a shady area under the big tree."),
        Message(sender: .elephant, text: "Oh yes, that's a nice place to relax."),
        Message(sender: .badger, text: "Perfect, I'll meet you there."),
        Message(sender: .stork, text: "I'm flying over now."),
        Message(sender: .elephant, text: "I'm on my way too."),
        Message(sender: .badger, text: "I see you both! Waving hello."),
        Message(sender: .stork, text: "Waving my wings back at you!"),
        Message(sender: .elephant, text: "Trunk salute!"),
        Message(sender: .badger, text: "Haha, great to see you!"),
        Message(sender: .stork, text: "Did anyone bring water?"),
        Message(sender: .elephant, text: "I've got plenty in my canteen."),
        Message(sender: .badger, text: "I've got some too just in case."),
        Message(sender: .stork, text: "Thanks! It's a hot day."),
        Message(sender: .elephant, text: "Should we take a group photo?"),
        Message(sender: .badger, text: "That's a great idea."),
        Message(sender: .stork, text: "I'll set up my camera."),
        Message(sender: .elephant, text: "Ready when you are."),
        Message(sender: .badger, text: "Say cheese!"),
        Message(sender: .stork, text: "Cheese!"),
        Message(sender: .elephant, text: "Trumpet!"),
        Message(sender: .badger, text: "I can't stop laughing."),
        Message(sender: .stork, text: "This will be a memory to keep."),
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
        messages.append(Message(sender: .stork, text: trimmed))
        newMessage = ""
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
}
