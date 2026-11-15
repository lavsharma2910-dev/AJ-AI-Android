import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AJAIApp());
}

const Color bg = Color(0xFF090B18);
const Color purple = Color(0xFF9B6DFF);
const Color pink = Color(0xFFE58BDB);
const Color card = Color(0xFF171A2E);
const Color muted = Color(0xFF9DA3BD);

class AJAIApp extends StatelessWidget {
  const AJAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AJ AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  void preview(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name अभी निर्माण के चरण में है।'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: card,
      ),
    );
  }

  void openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF17132E), bg, Color(0xFF101B32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: selectedTab == 0
              ? buildHome()
              : buildOtherPage(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111326),
        indicatorColor: purple.withOpacity(0.22),
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          if (index == 1) {
            openChat();
          } else {
            setState(() => selectedTab = index);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.face_retouching_natural),
            label: 'Avatar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [purple, pink],
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AJ SOFTWARE LABS',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'AJ AI Companion',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => preview('Notifications'),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),

          const SizedBox(height: 27),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF38265F),
                  Color(0xFF20274F),
                  Color(0xFF171B35),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: purple.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.16),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFF62E6AE)),
                      SizedBox(width: 7),
                      Text(
                        'YOUR AI COMPANION',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Container(
                  height: 155,
                  width: 155,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [purple, pink, Color(0xFF5948C9)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: pink.withOpacity(0.3),
                        blurRadius: 35,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF211B42),
                    ),
                    child: const Icon(
                      Icons.face_3_rounded,
                      size: 100,
                      color: Color(0xFFE6C8FF),
                    ),
                  ),
                ),

                const SizedBox(height: 17),
                const Text(
                  'AJ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Your Personal AI Companion',
                  style: TextStyle(color: Color(0xFFD5C8F4)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'नमस्ते! मैं AJ हूँ 💜',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'आज आप क्या करना चाहेंगे?',
                  style: TextStyle(
                    color: Color(0xFFD0CDE2),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            'आपकी AJ से मुलाकात',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  icon: Icons.chat_bubble_rounded,
                  title: 'AI Chat',
                  subtitle: 'बातचीत शुरू करें',
                  colors: const [
                    Color(0xFF8055D9),
                    Color(0xFF5037A2),
                  ],
                  onTap: openChat,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  icon: Icons.mic_rounded,
                  title: 'Voice Chat',
                  subtitle: 'Coming Soon',
                  colors: const [
                    Color(0xFFD16DBD),
                    Color(0xFF8A438E),
                  ],
                  onTap: () => preview('Voice Chat'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 27),

          const Text(
            'Explore AJ',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'आपके लिए खास सुविधाएँ',
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
            children: [
              SmallFeature(
                icon: Icons.code_rounded,
                title: 'Code Studio',
                subtitle: 'Coding assistant',
                onTap: () => preview('Code Studio'),
              ),
              SmallFeature(
                icon: Icons.travel_explore_rounded,
                title: 'Web Search',
                subtitle: 'Explore information',
                onTap: () => preview('Web Search'),
              ),
              SmallFeature(
                icon: Icons.folder_open_rounded,
                title: 'My Files',
                subtitle: 'File assistant',
                onTap: () => preview('My Files'),
              ),
              SmallFeature(
                icon: Icons.psychology_alt_rounded,
                title: 'Memory',
                subtitle: 'Personal memory',
                onTap: () => preview('Memory'),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.07),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: pink, size: 27),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AJ AI is evolving',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'कुछ सुविधाएँ अभी निर्माण के चरण में हैं।',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),
          const Center(
            child: Text(
              'BUILD • INNOVATE • AUTOMATE',
              style: TextStyle(
                color: muted,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOtherPage() {
    final isAvatar = selectedTab == 2;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAvatar ? Icons.face_rounded : Icons.person_rounded,
              size: 75,
              color: purple,
            ),
            const SizedBox(height: 20),
            Text(
              isAvatar ? 'AJ Avatar' : 'My Profile',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'यह सेक्शन अगले विकास चरण में उपलब्ध होगा।',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => setState(() => selectedTab = 0),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 29, color: Colors.white),
              const SizedBox(height: 13),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE9DDF8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SmallFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: pink, size: 25),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  final scrollController = ScrollController();

  static const apiUrl =
      'https://aj-ai-backend.lavsharma2910.workers.dev/chat';
  static const historyKey = 'aj_ai_chat_history_v1';
  static const queueKey = 'aj_ai_pending_queue_v1';

  bool isLoading = false;
  bool historyLoaded = false;
  bool queueProcessing = false;

  final List<String> pendingQueue = [];
  final List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(historyKey);

      if (saved != null) {
        final decoded = jsonDecode(saved);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map &&
                item['type'] != null &&
                item['text'] != null) {
              messages.add({
                'type': item['type'].toString(),
                'text': item['text'].toString(),
              });
            }
          }
        }
      }

      final savedQueue = prefs.getString(queueKey);
      if (savedQueue != null) {
        final decodedQueue = jsonDecode(savedQueue);
        if (decodedQueue is List) {
          for (final item in decodedQueue) {
            if (item is String && item.trim().isNotEmpty) {
              pendingQueue.add(item);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Chat restore error: $e');
    }

    if (messages.isEmpty) {
      messages.add({
        'type': 'aj',
        'text': 'नमस्ते! 😊 मैं AJ हूँ। अब आप मुझसे सीधे AI चैट कर सकते हैं।',
      });
    }

    if (!mounted) return;
    setState(() => historyLoaded = true);
    await saveHistory();
    scrollToBottom();

    if (pendingQueue.isNotEmpty) {
      processQueue();
    }
  }

  Future<void> saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(historyKey, jsonEncode(messages));
    } catch (e) {
      debugPrint('Chat history save error: $e');
    }
  }

  Future<bool> savePendingQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(queueKey, jsonEncode(pendingQueue));
    } catch (e) {
      debugPrint('Pending queue save error: $e');
      return false;
    }
  }

  Future<void> processQueue() async {
    if (!historyLoaded || queueProcessing || !mounted) return;

    queueProcessing = true;

    try {
      while (mounted && pendingQueue.isNotEmpty) {
        final value = pendingQueue.first;

        setState(() => isLoading = true);
        scrollToBottom();

        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': value}),
          ).timeout(const Duration(seconds: 60));

          final data = jsonDecode(response.body);

          if (response.statusCode != 200) {
            throw Exception(
              data is Map
                  ? (data['error'] ?? data['detail'] ??
                      'Server error ${response.statusCode}').toString()
                  : 'Server error ${response.statusCode}',
            );
          }

          final answer = data is Map ? data['reply'] : null;
          if (answer == null || answer.toString().trim().isEmpty) {
            throw Exception('AI से खाली जवाब मिला।');
          }

          if (!mounted) break;

          // Remove only after a valid reply is received.
          pendingQueue.removeAt(0);
          if (!await savePendingQueue()) {
            pendingQueue.insert(0, value);
            throw Exception('Queue सेव नहीं हो पाई। संदेश सुरक्षित रखा गया है।');
          }

          setState(() {
            messages.add({'type': 'aj', 'text': answer.toString()});
          });
          await saveHistory();
        } catch (e) {
          if (!mounted) break;

          // Keep the failed message in the queue and stop.
          setState(() {
            messages.add({
              'type': 'aj',
              'text': 'संदेश भेजा नहीं जा सका। Queue में सुरक्षित है। Retry बाद में करें।\n\n$e',
            });
          });
          await saveHistory();
          break;
        } finally {
          if (mounted) {
            setState(() => isLoading = false);
            scrollToBottom();
          }
        }
      }
    } finally {
      queueProcessing = false;
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> copyMessage(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied'),
        duration: Duration(seconds: 1),
      ),
    );
  }


  Future<void> copyConversation() async {
    if (messages.isEmpty) return;

    final transcript = messages.map((item) {
      final isUser = item['type'] == 'user';
      return '${isUser ? 'आप' : 'AJ AI'}:\n${item['text'] ?? ''}';
    }).join('\n\n--------------------\n\n');

    await Clipboard.setData(ClipboardData(text: transcript));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('पूरी बातचीत Copy हो गई')),
    );
  }

  Future<void> showConversation() async {
    if (!mounted) return;

    final transcript = messages.map((item) {
      final isUser = item['type'] == 'user';
      return '${isUser ? 'आप' : 'AJ AI'}:\n${item['text'] ?? ''}';
    }).join('\n\n--------------------\n\n');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: card,
        title: const Text('पूरी बातचीत'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(transcript),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: transcript));
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Copy All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('बंद करें'),
          ),
        ],
      ),
    );
  }

  Future<void> clearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: card,
        title: const Text('Clear Chat?'),
        content: const Text('क्या आप पूरी Chat History मिटाना चाहते हैं?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('रद्द करें'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('मिटाएँ'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      messages
        ..clear()
        ..add({
          'type': 'aj',
          'text': 'नमस्ते! 😊 मैं AJ हूँ। अब आप मुझसे सीधे AI चैट कर सकते हैं।',
        });
    });
    await saveHistory();
    scrollToBottom();
  }

  Future<void> send() async {
    if (!historyLoaded) return;

    final value = controller.text.trim();
    if (value.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add({'type': 'user', 'text': value});
      pendingQueue.add(value);
    });

    await saveHistory();
    final queueSaved = await savePendingQueue();
    scrollToBottom();

    if (!queueSaved) {
      if (!mounted) return;
      setState(() {
        pendingQueue.removeLast();
        messages.add({
          'type': 'aj',
          'text': 'Queue सेव नहीं हो पाई। कृपया संदेश दोबारा भेजें।',
        });
      });
      await saveHistory();
      return;
    }

    processQueue();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF111326),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF6746AE),
              child: Icon(Icons.face_3_rounded, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AJ AI', style: TextStyle(fontSize: 17)),
                Text('AI Assistant • Online',
                    style: TextStyle(fontSize: 10, color: muted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Copy All',
            onPressed: messages.isEmpty ? null : copyConversation,
            icon: const Icon(Icons.copy_all_rounded),
          ),
          IconButton(
            tooltip: 'View / Select All',
            onPressed: messages.isEmpty ? null : showConversation,
            icon: const Icon(Icons.select_all_rounded),
          ),
          IconButton(
            tooltip: 'Clear Chat',
            onPressed: (isLoading || pendingQueue.isNotEmpty) ? null : clearChat,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: !historyLoaded
                ? const Center(child: CircularProgressIndicator(color: pink))
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isLoading && index == messages.length) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: pink,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('AJ जवाब लिख रही है...  •  बाकी: ${pendingQueue.length}'),
                            ],
                          ),
                        );
                      }

                      final item = messages[index];
                      final isUser = item['type'] == 'user';
                      final messageText = item['text'] ?? '';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 13),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 310),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF6344A5)
                                : card,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(19),
                              topRight: const Radius.circular(19),
                              bottomLeft: Radius.circular(isUser ? 19 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 19),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SelectableText(
                                messageText,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                                tooltip: 'Copy message',
                                onPressed: () => copyMessage(messageText),
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 17,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (historyLoaded && pendingQueue.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFF191B32),
              child: Row(
                children: [
                  const Icon(Icons.pending_actions, color: pink, size: 19),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pending messages: ${pendingQueue.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: (isLoading || queueProcessing)
                        ? null
                        : processQueue,
                    icon: const Icon(Icons.refresh, size: 17),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              color: const Color(0xFF111326),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: historyLoaded,
                      onSubmitted: (_) => send(),
                      decoration: InputDecoration(
                        hintText: 'AJ को संदेश लिखें...',
                        filled: true,
                        fillColor: card,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [purple, pink]),
                    ),
                    child: IconButton(
                      onPressed: !historyLoaded ? null : send,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
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
