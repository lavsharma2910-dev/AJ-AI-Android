import 'package:flutter/material.dart';

void main() => runApp(const AJAIApp());

class AJAIApp extends StatelessWidget {
  const AJAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AJ AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9B59B6)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F5FC),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AJ AI ✨'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEADCF8), Color(0xFFFCE4EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.face_3_rounded, size: 100, color: Color(0xFF8E44AD)),
                    SizedBox(height: 8),
                    Text('AJ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('Your AI companion', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'नमस्ते! मैं AJ हूँ 💜\nआज आप क्या बात करना चाहेंगे?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('AJ से Chat करें'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.mic_none),
                label: const Text('Voice Chat (आगे जोड़ेंगे)'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice feature अगले चरण में जोड़ा जाएगा।')),
                ),
              ),
            ),
            const Spacer(),
            const Text('Starter UI • AI connection अगला चरण', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>['AJ: नमस्ते! 😊 अभी मैं starter mode में हूँ।'];

  void send() {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      messages.add('आप: $value');
      messages.add('AJ: आपका संदेश मिल गया। AI backend जोड़ने के बाद मैं वास्तविक AI जवाब दूँगी।');
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AJ के साथ Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => Align(
                alignment: messages[i].startsWith('आप:') ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(13),
                  constraints: const BoxConstraints(maxWidth: 320),
                  decoration: BoxDecoration(
                    color: messages[i].startsWith('आप:') ? const Color(0xFFE8D5F5) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(messages[i], style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'AJ को संदेश लिखें…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
