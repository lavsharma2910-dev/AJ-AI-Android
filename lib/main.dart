
import 'dart:async';
import 'package:aj_ai/pending_chat_message.dart';
import 'package:aj_ai/request_diagnostics.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';




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
      home: const WelcomeScreen(),
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
                    child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF9CD8FF).withOpacity(0.8), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF36B9FF).withOpacity(0.28), blurRadius: 22, spreadRadius: 5),
                          ],
                        ),
                      ),
                      const Icon(Icons.all_inclusive_rounded, size: 76, color: Color(0xFFE6F5FF)),
                      const Positioned(top: 24, right: 24, child: Icon(Icons.auto_awesome, size: 17, color: Colors.white)),
                    ],
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
            child: Column(
              children: [
                Text(
                  'MADE IN INDIA 🇮🇳',
                  style: TextStyle(
                    color: pink,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Future Technology with New India',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'BUILD • INNOVATE • AUTOMATE',
                  style: TextStyle(
                    color: muted,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ],
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
  static const chatStateKey = 'aj_ai_chat_state_v2';
  static const historyKey = 'aj_ai_chat_history_v1';
  static const queueKey = 'aj_ai_pending_queue_v1';
  static const conversationsKey = 'aj_ai_conversations_v1';
  static const activeConversationKey = 'aj_ai_active_conversation_v1';

  String conversationId = DateTime.now().microsecondsSinceEpoch.toString();
  String conversationTitle = 'नई बातचीत';
  bool isSavedConversation = false;
  bool selectionMode = false;
  final Set<int> selectedMessages = <int>{};

  bool isLoading = false;
  bool historyLoaded = false;
  bool queueProcessing = false;
  bool sendSaving = false;
  bool restoreFailed = false;

  final List<PendingChatMessage> pendingQueue = [];
  final List<Map<String, String>> messages = [];

  List<Map<String, String>> buildChatContext() {
    final pendingCounts = <String, int>{};
    for (final item in pendingQueue) {
      pendingCounts[item.text] = (pendingCounts[item.text] ?? 0) + 1;
    }

    final completed = List<Map<String, String>>.from(messages);

    for (var i = completed.length - 1; i >= 0; i--) {
      final item = completed[i];
      if (item["type"] == "user") {
        final value = item["text"] ?? "";
        final count = pendingCounts[value] ?? 0;
        if (count > 0) {
          completed.removeAt(i);
          pendingCounts[value] = count - 1;
        }
      }
    }

    final context = <Map<String, String>>[];
    for (final item in completed) {
      final type = item["type"];
      final value = (item["text"] ?? "").trim();
      if (value.isEmpty) continue;

      if (type == "user") {
        context.add({"role": "user", "text": value});
      } else if (type == "aj" &&
          !value.startsWith("नमस्ते!") &&
          !value.startsWith("संदेश भेजा नहीं जा सका।") &&
          !value.startsWith("Queue सेव नहीं हो पाई।")) {
        context.add({"role": "model", "text": value});
      }
    }

    final recent = context.length <= 12
        ? List<Map<String, String>>.from(context)
        : context.sublist(context.length - 12);

    while (recent.isNotEmpty && recent.first["role"] != "user") {
      recent.removeAt(0);
    }
    return recent;
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  bool queueRestoreSafe = true;

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedV2 = prefs.getString(chatStateKey);

      if (savedV2 != null) {
        final decoded = jsonDecode(savedV2);
        if (decoded is! Map ||
            decoded['messages'] is! List ||
            decoded['pendingQueue'] is! List) {
          throw const FormatException('Invalid AJ chat state v2');
        }

        for (final item in decoded['messages']) {
          if (item is! Map ||
              item['type'] is! String ||
              item['text'] is! String) {
            throw const FormatException('Invalid saved message');
          }
          messages.add({
            'type': item['type'] as String,
            'text': item['text'] as String,
          });
        }

        final ids = <String>{};
        for (final item in decoded['pendingQueue']) {
          final queued = PendingChatMessage.fromJson(item);
          if (!ids.add(queued.id)) {
            throw const FormatException('Duplicate queued request ID');
          }
          pendingQueue.add(queued);
        }
      } else {
        // One-time migration from the two legacy keys.
        final savedHistory = prefs.getString(historyKey);
        final savedQueue = prefs.getString(queueKey);

        if (savedHistory != null) {
          final decoded = jsonDecode(savedHistory);
          if (decoded is! List) {
            throw const FormatException('Invalid legacy chat history');
          }
          for (final item in decoded) {
            if (item is! Map ||
                item['type'] == null ||
                item['text'] == null) {
              throw const FormatException('Invalid legacy message');
            }
            messages.add({
              'type': item['type'].toString(),
              'text': item['text'].toString(),
            });
          }
        }

        if (savedQueue != null) {
          final decoded = jsonDecode(savedQueue);
          if (decoded is! List) {
            throw const FormatException('Invalid legacy pending queue');
          }
          final ids = <String>{};
          for (final item in decoded) {
            if (item is String && item.trim().isEmpty) continue;
            var queued = PendingChatMessage.fromJson(item);
            if (!ids.add(queued.id)) {
              queued = PendingChatMessage(
                id: createRequestId(),
                text: queued.text,
                createdAt: queued.createdAt,
                retryCount: queued.retryCount,
              );
              ids.add(queued.id);
            }
            pendingQueue.add(queued);
          }
        }
      }
    } catch (e) {
      queueRestoreSafe = false;
      restoreFailed = true;
      debugPrint('Chat restore error; storage left untouched: $e');
      if (mounted) {
        setState(() => historyLoaded = true);
      }
      return;
    }

    if (!queueRestoreSafe) return;

    if (messages.isEmpty) {
      messages.add({
        'type': 'aj',
        'text': 'नमस्ते! 😊 मैं AJ हूँ। अब आप मुझसे सीधे AI चैट कर सकते हैं।',
      });
    }

    // A request left in "processing" means the app closed mid-flight.
    // Re-queue it with the same stable request ID after restoring state.
    for (var i = 0; i < pendingQueue.length; i++) {
      if (pendingQueue[i].status == 'processing') {
        pendingQueue[i] = pendingQueue[i].copyWith(status: 'pending');
      }
    }

    // Persist migration/initial state before any network processing.
    if (!await saveChatState()) {
      queueRestoreSafe = false;
      restoreFailed = true;
      debugPrint('Chat state initialization could not be saved.');
      if (mounted) {
        setState(() => historyLoaded = true);
      }
      return;
    }

    if (!mounted) return;
    setState(() => historyLoaded = true);
    scrollToBottom();

    if (queueRestoreSafe && pendingQueue.isNotEmpty) {
      processQueue();
    }
  }

  Future<void> retryHistoryRestore() async {
    if (!mounted || !restoreFailed || queueProcessing || sendSaving) return;

    setState(() {
      messages.clear();
      pendingQueue.clear();
      historyLoaded = false;
      restoreFailed = false;
      queueRestoreSafe = true;
    });

    await loadHistory();
  }

  Future<bool> saveChatState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAt = DateTime.now().toUtc().toIso8601String();
      final state = {
        'version': 3,
        'conversationId': conversationId,
        'title': conversationTitle,
        'isSaved': isSavedConversation,
        'messages': messages,
        'pendingQueue': pendingQueue.map((item) => item.toJson()).toList(),
        'savedAt': savedAt,
      };
      final encoded = jsonEncode(state);
      final conversations = <Map<String, dynamic>>[];
      final raw = prefs.getString(conversationsKey);
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final entry in decoded) {
            if (entry is Map && entry['id'] is String &&
                entry['id'] != conversationId) {
              conversations.add(Map<String, dynamic>.from(entry));
            }
          }
        }
      }
      conversations.insert(0, {
        'id': conversationId,
        'title': conversationTitle,
        'isSaved': isSavedConversation,
        'savedAt': savedAt,
        'messageCount': messages.length,
        'state': state,
      });
      // Keep a bounded local history to prevent unbounded preference growth.
      final bounded = conversations.take(50).toList();
      final historySaved = await prefs.setString(
        conversationsKey, jsonEncode(bounded));
      if (!historySaved) return false;
      final activeSaved = await prefs.setString(chatStateKey, encoded);
      if (!activeSaved) return false;
      return await prefs.setString(activeConversationKey, conversationId);
    } catch (e) {
      debugPrint('Chat state save error: $e');
      return false;
    }
  }

  String _transcript(Iterable<Map<String, String>> items) =>
      items.map((item) {
        final who = item['type'] == 'user' ? 'आप' : 'AJ AI';
        return '$who:\n${item['text'] ?? ''}';
      }).join('\n\n--------------------\n\n');

  Future<void> shareText(String text) async {
    if (text.trim().isEmpty) return;
    await Share.share(text, subject: 'AJ AI Chat');
  }

  Future<void> saveConversation() async {
    final old = isSavedConversation;
    setState(() => isSavedConversation = true);
    if (!await saveChatState()) {
      if (mounted) setState(() => isSavedConversation = old);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save नहीं हो पाया; दोबारा प्रयास करें।')));
      return;
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('बातचीत Saved History में सुरक्षित है।')));
  }

  Future<void> newChat() async {
    if (!historyLoaded || restoreFailed || sendSaving ||
        queueProcessing || pendingQueue.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('पहले pending messages पूरे होने दें।')));
      return;
    }
    if (messages.length <= 1 && messages.isNotEmpty && messages[0]['type'] == 'aj') return;
    final ok = await saveChatState();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('पुरानी चैट सेव नहीं हुई; नई चैट नहीं खोली।')));
      return;
    }
    setState(() {
      conversationId = DateTime.now().microsecondsSinceEpoch.toString();
      conversationTitle = 'नई बातचीत';
      isSavedConversation = false;
      messages
        ..clear()
        ..add({'type': 'aj', 'text': 'नमस्ते! 😊 मैं AJ हूँ। नई बातचीत शुरू करें।'});
      selectedMessages.clear();
      selectionMode = false;
    });
    if (!await saveChatState() && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('नई चैट सेव नहीं हो सकी।')));
    }
    scrollToBottom();
  }

  Future<void> openHistory() async {
    if (!historyLoaded || sendSaving || queueProcessing || pendingQueue.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History खोलने से पहले pending messages पूरे करें।')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(conversationsKey);
    final entries = <Map<String, dynamic>>[];
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map && item['state'] is Map) {
              entries.add(Map<String, dynamic>.from(item));
            }
          }
        }
      } catch (e) {
        debugPrint('History read error: $e');
      }
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: card,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * .7,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Chat History', style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: entries.isEmpty
                  ? const Center(child: Text('अभी कोई पुरानी चैट नहीं है।'))
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final savedState = Map<String, dynamic>.from(entry['state'] as Map);
                        final title = (entry['title'] ?? 'बातचीत').toString();
                        final date = (entry['savedAt'] ?? '').toString();
                        return ListTile(
                          leading: Icon(
                            entry['isSaved'] == true ? Icons.bookmark : Icons.chat_bubble_outline,
                            color: pink),
                          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text('$date • ${entry['messageCount'] ?? 0} messages',
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () async {
                            Navigator.pop(sheetContext);
                            await _restoreConversation(savedState);
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _restoreConversation(Map<String, dynamic> state) async {
    if (!await saveChatState()) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('वर्तमान चैट सेव नहीं हुई; History नहीं बदली।')));
      return;
    }
    try {
      final restoredMessages = <Map<String, String>>[];
      final restoredQueue = <PendingChatMessage>[];
      for (final item in (state['messages'] as List? ?? [])) {
        if (item is Map && item['type'] is String && item['text'] is String) {
          restoredMessages.add({'type': item['type'], 'text': item['text']});
        }
      }
      for (final item in (state['pendingQueue'] as List? ?? [])) {
        restoredQueue.add(PendingChatMessage.fromJson(item));
      }
      setState(() {
        conversationId = (state['conversationId'] ?? DateTime.now().microsecondsSinceEpoch.toString()).toString();
        conversationTitle = (state['title'] ?? 'बातचीत').toString();
        isSavedConversation = state['isSaved'] == true;
        messages
          ..clear()
          ..addAll(restoredMessages);
        pendingQueue.clear();
        selectionMode = false;
        selectedMessages.clear();
      });
      if (!await saveChatState()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('चैट लोड हुई, लेकिन सेविंग की पुष्टि नहीं हुई।')));
      } else if (pendingQueue.isNotEmpty) {
        processQueue();
      }
      scrollToBottom();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('History restore नहीं हुई: $e')));
    }
  }

  Future<void> deleteConversation() async {
    if (pendingQueue.isNotEmpty || queueProcessing || sendSaving) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: card,
        title: const Text('Delete conversation?'),
        content: const Text('यह बातचीत History से स्थायी रूप से हट जाएगी।'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('रद्द करें')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete')),
        ],
      ),
    );
    if (confirm != true) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(conversationsKey);
    final entries = raw == null ? <dynamic>[] : (jsonDecode(raw) as List);
    final filtered = entries.where((e) => e is! Map || e['id'] != conversationId).toList();
    if (!await prefs.setString(conversationsKey, jsonEncode(filtered))) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete सेव नहीं हुआ।')));
      return;
    }
    setState(() {
      conversationId = DateTime.now().microsecondsSinceEpoch.toString();
      conversationTitle = 'नई बातचीत';
      isSavedConversation = false;
      messages
        ..clear()
        ..add({'type': 'aj', 'text': 'नमस्ते! 😊 मैं AJ हूँ।'});
      selectedMessages.clear();
      selectionMode = false;
    });
    await saveChatState();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('बातचीत Delete कर दी गई।')));
  }

  void toggleMessageSelection(int index) {
    setState(() {
      selectionMode = true;
      if (!selectedMessages.add(index)) selectedMessages.remove(index);
      if (selectedMessages.isEmpty) selectionMode = false;
    });
  }

  Future<void> performSelectedAction(String action) async {
    final indexes = selectedMessages.toList()..sort();
    final selected = indexes.where((i) => i >= 0 && i < messages.length)
        .map((i) => Map<String, String>.from(messages[i])).toList();
    if (selected.isEmpty) return;
    if (action == 'copy') {
      await Clipboard.setData(ClipboardData(text: _transcript(selected)));
    } else if (action == 'share') {
      await shareText(_transcript(selected));
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: card,
          title: const Text('Delete selected messages?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('रद्द करें')),
            TextButton(onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete')),
          ],
        ),
      );
      if (confirm != true) return;
      final old = List<Map<String, String>>.from(messages);
      for (final i in indexes.reversed) {
        if (i >= 0 && i < messages.length) messages.removeAt(i);
      }
      if (!await saveChatState()) {
        setState(() => messages
          ..clear()
          ..addAll(old));
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete सेव नहीं हुआ; messages वापस रखे गए।')));
        return;
      }
    }
    if (mounted) setState(() {
      selectedMessages.clear();
      selectionMode = false;
    });
  }

  Future<void> processQueue() async {
    if (!queueRestoreSafe || !historyLoaded || queueProcessing || !mounted) {
      return;
    }

    queueProcessing = true;
    try {
      while (mounted && pendingQueue.isNotEmpty) {
        final queuedMessage = pendingQueue.first;
        if (queuedMessage.status == 'failed') break;

        final processingMessage = queuedMessage.copyWith(status: 'processing');
        setState(() {
          pendingQueue[0] = processingMessage;
          isLoading = true;
        });
        if (!await saveChatState()) {
          if (mounted) {
            setState(() => pendingQueue[0] = queuedMessage);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('संदेश की स्थिति सेव नहीं हुई। फिर से प्रयास करें।')),
            );
          }
          break;
        }
        scrollToBottom();

        var persistenceFailed = false;
        final requestMetric = ChatRequestMetric();
        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': queuedMessage.text,
              'requestId': queuedMessage.id,
              'history': buildChatContext(),
            }),
          ).timeout(const Duration(seconds: 60));
          requestMetric.stop();
          requestMetric.responseReceived(response.statusCode);

          final data = jsonDecode(response.body);
          if (response.statusCode != 200) {
            requestMetric.markFailure();
            throw Exception(
              data is Map
                  ? (data['error'] ?? data['detail'] ??
                      'Server error ${response.statusCode}').toString()
                  : 'Server error ${response.statusCode}',
            );
          }

          final answer = data is Map ? data['reply'] : null;
          if (answer == null || answer.toString().trim().isEmpty) {
            requestMetric.markFailure();
            throw Exception('AI से खाली जवाब मिला।');
          }
          requestMetric.markSuccess();
          if (!mounted) break;

          final oldMessages = List<Map<String, String>>.from(messages);
          final oldQueue = List<PendingChatMessage>.from(pendingQueue);
          setState(() {
            pendingQueue.removeWhere((item) => item.id == queuedMessage.id);
            messages.add({'type': 'aj', 'text': answer.toString()});
          });

          if (!await saveChatState()) {
            if (!mounted) break;
            setState(() {
              messages
                ..clear()
                ..addAll(oldMessages);
              pendingQueue
                ..clear()
                ..addAll(oldQueue);
            });
            persistenceFailed = true;
            break;
          }
        } catch (e) {
          requestMetric.stop();
          requestMetric.markFailure();
          if (!mounted) break;
          if (persistenceFailed) break;
          setState(() {
            final index = pendingQueue.indexWhere((item) => item.id == queuedMessage.id);
            if (index >= 0) {
              pendingQueue[index] = pendingQueue[index].copyWith(
                status: 'failed',
                retryCount: pendingQueue[index].retryCount + 1,
              );
            }
          });
          await saveChatState();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('AI से अभी जवाब नहीं मिला। आपका संदेश सुरक्षित है; Retry दबाकर फिर भेजें।'),
            ),
          );
          break;
        } finally {
          if (kDebugMode) debugPrint(requestMetric.diagnosticLine());
          if (mounted) {
            setState(() => isLoading = false);
            scrollToBottom();
          }
        }
      }
    } finally {
      queueProcessing = false;
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> retryPendingQueue() async {
    if (!mounted || queueProcessing || pendingQueue.isEmpty) return;
    final first = pendingQueue.first;
    if (first.status == 'failed') {
      setState(() {
        pendingQueue[0] = first.copyWith(status: 'pending');
      });
      if (!await saveChatState()) {
        if (!mounted) return;
        setState(() => pendingQueue[0] = first);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retry की स्थिति सेव नहीं हुई।')),
        );
        return;
      }
    }
    await processQueue();
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
    if (!historyLoaded || messages.isEmpty) return;
    final snapshot = List<Map<String, String>>.from(messages);
    final transcript = _transcript(snapshot);
    if (transcript.trim().isEmpty) return;
    try {
      await Clipboard.setData(ClipboardData(text: transcript));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('पूरी बातचीत कॉपी हुई • ${snapshot.length} संदेश')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कॉपी नहीं हो पाई। फिर से प्रयास करें।')),
      );
      debugPrint('Copy all failed: $error');
    }
  }

  Future<void> shareConversation() async {
    if (!historyLoaded || messages.isEmpty) return;
    final snapshot = List<Map<String, String>>.from(messages);
    final transcript = _transcript(snapshot);
    if (transcript.trim().isEmpty) return;
    try {
      await shareText(transcript);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('पूरी बातचीत शेयर नहीं हो पाई।')),
      );
      debugPrint('Share all failed: $error');
    }
  }

  Future<void> showConversation() async {
    if (!mounted) return;

    final transcript = _transcript(List<Map<String, String>>.from(messages));

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
    if (!mounted ||
        !historyLoaded ||
        restoreFailed ||
        sendSaving ||
        pendingQueue.isNotEmpty ||
        queueProcessing) {
      return;
    }

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

    final oldMessages = List<Map<String, String>>.from(messages);
    setState(() {
      messages
        ..clear()
        ..add({
          'type': 'aj',
          'text': 'नमस्ते! 😊 मैं AJ हूँ। अब आप मुझसे सीधे AI चैट कर सकते हैं।',
        });
    });

    if (!await saveChatState()) {
      if (!mounted) return;
      setState(() {
        messages
          ..clear()
          ..addAll(oldMessages);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat save नहीं हुई; पुरानी History सुरक्षित रखी गई।')),
        );
      }
      return;
    }
    scrollToBottom();
  }

  Future<void> send() async {
    if (!historyLoaded || !queueRestoreSafe || sendSaving || !mounted) {
      return;
    }

    final value = controller.text.trim();
    if (value.isEmpty) return;

    final oldMessages = List<Map<String, String>>.from(messages);
    final oldQueue = List<PendingChatMessage>.from(pendingQueue);

    sendSaving = true;
    setState(() {
      messages.add({'type': 'user', 'text': value});
      pendingQueue.add(PendingChatMessage(
        id: createRequestId(),
        text: value,
        createdAt: DateTime.now().toUtc(),
      ));
    });
    controller.clear();
    scrollToBottom();

    var saved = false;
    try {
      saved = await saveChatState();
    } catch (e) {
      debugPrint('Send persistence error: $e');
    }

    if (!mounted) return;

    if (!saved) {
      setState(() {
        messages
          ..clear()
          ..addAll(oldMessages);
        pendingQueue
          ..clear()
          ..addAll(oldQueue);
      });
      controller.text = value;
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('संदेश सेव नहीं हुआ। टेक्स्ट वापस रखा गया है।'),
        ),
      );
    }

    if (!mounted) return;
    setState(() => sendSaving = false);

    if (saved) {
      processQueue();
    }
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
      backgroundColor: ajDeep,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1630),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF123C70),
              child: Icon(Icons.all_inclusive_rounded, color: Color(0xFFE6F5FF)),
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
        actions: selectionMode
          ? [
              IconButton(tooltip: 'Copy selected', onPressed: () => performSelectedAction('copy'), icon: const Icon(Icons.copy)),
              IconButton(tooltip: 'Share selected', onPressed: () => performSelectedAction('share'), icon: const Icon(Icons.share)),
              IconButton(tooltip: 'Delete selected', onPressed: () => performSelectedAction('delete'), icon: const Icon(Icons.delete_outline)),
              IconButton(tooltip: 'Cancel selection', onPressed: () => setState(() { selectionMode = false; selectedMessages.clear(); }), icon: const Icon(Icons.close)),
            ]
          : [
              IconButton(tooltip: 'New Chat', onPressed: newChat, icon: const Icon(Icons.add_comment_outlined)),
              IconButton(tooltip: 'History', onPressed: openHistory, icon: const Icon(Icons.history)),
              IconButton(tooltip: 'Save', onPressed: saveConversation, icon: Icon(isSavedConversation ? Icons.bookmark : Icons.bookmark_border)),
              IconButton(tooltip: 'Share all chat', onPressed: shareConversation, icon: const Icon(Icons.share)),
              IconButton(tooltip: 'Select', onPressed: () => setState(() => selectionMode = true), icon: const Icon(Icons.checklist)),
              PopupMenuButton<String>(
                tooltip: 'More chat options',
                onSelected: (value) {
                  if (value == 'copy_all') copyConversation();
                  if (value == 'share_all') shareConversation();
                  if (value == 'view_all') showConversation();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'copy_all', child: ListTile(dense: true, leading: Icon(Icons.copy_all_rounded), title: Text('Copy All'), contentPadding: EdgeInsets.zero)),
                  PopupMenuItem(value: 'share_all', child: ListTile(dense: true, leading: Icon(Icons.ios_share_rounded), title: Text('Share All'), contentPadding: EdgeInsets.zero)),
                  PopupMenuItem(value: 'view_all', child: ListTile(dense: true, leading: Icon(Icons.article_outlined), title: Text('पूरी बातचीत देखें'), contentPadding: EdgeInsets.zero)),
                ],
                icon: const Icon(Icons.more_vert_rounded),
              ),
              IconButton(tooltip: 'Delete', onPressed: deleteConversation, icon: const Icon(Icons.delete_outline)),
            ],
      ),
      body: Column(
        children: [
          Expanded(
            child: restoreFailed
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 42),
                          const SizedBox(height: 12),
                          const Text(
                            'Chat History restore नहीं हो सकी। आपका पुराना डेटा सुरक्षित रखा गया है।',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: retryHistoryRestore,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry Restore'),
                          ),
                        ],
                      ),
                    ),
                  )
                : !historyLoaded
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
                      final isSelected = selectedMessages.contains(index);

                      return GestureDetector(
                        onLongPress: () => toggleMessageSelection(index),
                        child: Align(
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
                            border: Border.all(color: isSelected ? ajCyan : (isUser ? ajBlue : ajViolet).withOpacity(.55), width: isSelected ? 2 : 1),
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
                              if (selectionMode)
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => toggleMessageSelection(index),
                                  activeColor: ajCyan,
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
                      ),
                    );
                    },
                  ),
          ),
          if (historyLoaded && pendingQueue.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFF101A35),
              child: Row(
                children: [
                  Icon(
                    pendingQueue.first.status == 'failed'
                        ? Icons.error_outline_rounded
                        : Icons.pending_actions,
                    color: pendingQueue.first.status == 'failed' ? Colors.orange : pink,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pendingQueue.first.status == 'failed'
                          ? 'संदेश नहीं भेजा गया • सुरक्षित है'
                          : pendingQueue.first.status == 'processing'
                              ? 'संदेश भेजा जा रहा है...'
                              : 'Pending messages: ${pendingQueue.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: (isLoading || queueProcessing)
                        ? null
                        : retryPendingQueue,
                    icon: const Icon(Icons.refresh, size: 17),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              color: const Color(0xFF0D1630),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: historyLoaded && !sendSaving && !restoreFailed,
                      onSubmitted: (_) => send(),
                      decoration: InputDecoration(
                        hintText: 'AJ को संदेश लिखें...',
                        filled: true,
                        fillColor: const Color(0xFF111D39),
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
                      gradient: LinearGradient(colors: [ajBlue, ajViolet]),
                    ),
                    child: IconButton(
                      onPressed: (!historyLoaded || sendSaving || restoreFailed) ? null : send,
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


// AJ AI Update 34 — approved full neon experience.
// The hand-drawn sketch is not used as a UI asset. All screens are native Flutter widgets.
const Color ajCyan = Color(0xFF29D9FF);
const Color ajBlue = Color(0xFF176BFF);
const Color ajViolet = Color(0xFF8B5CFF);
const Color ajDeep = Color(0xFF070B1B);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ajDeep,
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFF02091E), Color(0xFF07143A), Color(0xFF16072E)],
        begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: SafeArea(child: LayoutBuilder(builder: (context, c) =>
        SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: ConstrainedBox(constraints: BoxConstraints(minHeight: c.maxHeight - 38),
            child: Column(children: [
              Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(color: ajCyan, width: 2),
                  boxShadow: [BoxShadow(color: ajCyan.withOpacity(.5), blurRadius: 16)]),
                  child: const Center(child: Text('AJ', style: TextStyle(color: ajCyan,
                    fontSize: 21, fontWeight: FontWeight.w900)))),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AJ SOFTWARE LABS', style: TextStyle(fontSize: 12, letterSpacing: 1.4,
                    fontWeight: FontWeight.w800)),
                  Text('Build. Innovate. Automate.', style: TextStyle(color: muted, fontSize: 10)),
                ])),
                _LanguagePreview(),
              ]),
              const SizedBox(height: 20),
              const HolographicCore(size: 220),
              const SizedBox(height: 12),
              const Text('Meet AJ AI', style: TextStyle(fontSize: 34,
                fontWeight: FontWeight.w900, letterSpacing: .5)),
              const Text('Your Advanced AI Companion',
                style: TextStyle(color: Color(0xFFD8E9FF), fontSize: 15)),
              const SizedBox(height: 8),
              const Text('Smarter  •  Faster  •  More Powerful',
                style: TextStyle(color: ajCyan, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 13), decoration: BoxDecoration(
                color: const Color(0xFF071B48).withOpacity(.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ajCyan.withOpacity(.8)),
                boxShadow: [BoxShadow(color: ajBlue.withOpacity(.25), blurRadius: 18)]),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _WelcomeBullet(icon: Icons.check_circle, text: 'Chat with Advanced AI'),
                  _WelcomeBullet(icon: Icons.check_circle, text: 'Voice & Messages'),
                  _WelcomeBullet(icon: Icons.check_circle, text: 'Multi-AI Hub'),
                  _WelcomeBullet(icon: Icons.check_circle, text: 'Secure & Private'),
                ])),
              const SizedBox(height: 18),
              _NeonButton(label: 'Create Account  (Sign Up)', icon: Icons.person_add_alt_1,
                onTap: () => _preview(context, 'Account creation अभी connect नहीं है।')),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white,
                  side: const BorderSide(color: ajCyan, width: 1.5),
                  shape: const StadiumBorder()),
                onPressed: () => _preview(context, 'Login अभी Preview है।'),
                icon: const Icon(Icons.login), label: const Text('Login'))),
              const SizedBox(height: 10),
              _NeonButton(
                label: 'Continue as Guest  (Testing)',
                icon: Icons.visibility_outlined,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const NeonDashboardScreen()),
                ),
              ),
              const SizedBox(height: 12),
              const Text('or continue with', style: TextStyle(color: muted, fontSize: 11)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _SocialPreview(label: 'Google', icon: Icons.g_mobiledata)),
                const SizedBox(width: 8),
                Expanded(child: _SocialPreview(label: 'Email', icon: Icons.mail_outline)),
                const SizedBox(width: 8),
                Expanded(child: _SocialPreview(label: 'Mobile', icon: Icons.phone)),
              ]),
              const SizedBox(height: 16),
              const Icon(Icons.verified_user_outlined, color: ajCyan, size: 20),
              const Text('Your Data is Always Secure', style: TextStyle(color: Color(0xFFD8E9FF), fontSize: 11)),
              const SizedBox(height: 8),
              const Text('AJ SOFTWARE LABS', style: TextStyle(color: muted, fontSize: 10, letterSpacing: 2)),
            ]),
          ),
        ),
      )),
    ),
  );
  static void _preview(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
class _LanguagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selector अभी Preview है।'))),
    style: OutlinedButton.styleFrom(foregroundColor: Colors.white,
      side: BorderSide(color: ajCyan.withOpacity(.6)), padding: const EdgeInsets.symmetric(horizontal: 9)),
    icon: const Icon(Icons.language, size: 15), label: const Text('EN', style: TextStyle(fontSize: 11)));
}
class _SocialPreview extends StatelessWidget {
  final String label; final IconData icon;
  const _SocialPreview({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label sign-in अभी connected नहीं है।'))),
    style: OutlinedButton.styleFrom(foregroundColor: Colors.white,
      side: BorderSide(color: ajCyan.withOpacity(.7)),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10)),
    icon: Icon(icon, size: 17), label: Text(label, style: const TextStyle(fontSize: 10)));
}

class _WelcomeBullet extends StatelessWidget {
  final IconData icon; final String text;
  const _WelcomeBullet({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, color: ajCyan, size: 20), const SizedBox(width: 12),
      Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFDCE7FF)))),
    ]),
  );
}

class HolographicCore extends StatelessWidget {
  final double size;
  const HolographicCore({super.key, this.size = 108});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size, height: size,
    child: Stack(alignment: Alignment.center, children: [
      Container(width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle,
          border: Border.all(color: ajCyan.withOpacity(.55), width: 1.5),
          boxShadow: [BoxShadow(color: ajBlue.withOpacity(.35), blurRadius: 32, spreadRadius: 5)])),
      Transform.rotate(angle: .55, child: Container(width: size*.83, height: size*.42,
        decoration: BoxDecoration(border: Border.all(color: ajViolet, width: 2),
          borderRadius: BorderRadius.circular(100)))),
      Transform.rotate(angle: -.55, child: Container(width: size*.83, height: size*.42,
        decoration: BoxDecoration(border: Border.all(color: ajCyan.withOpacity(.85), width: 1.5),
          borderRadius: BorderRadius.circular(100)))),
      Container(width: size*.55, height: size*.55,
        decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const RadialGradient(colors: [Color(0xFFB7F8FF), ajBlue, Color(0xFF27145C)]),
          boxShadow: [BoxShadow(color: ajCyan.withOpacity(.65), blurRadius: 24)])),
      const Icon(Icons.all_inclusive_rounded, color: Colors.white, size: 48),
      Positioned(top: size*.15, right: size*.19,
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 15)),
    ]),
  );
}

class NeonDashboardScreen extends StatelessWidget {
  const NeonDashboardScreen({super.key});
  static const List<_AJFeature> features = [
    _AJFeature('AI Chat','Ask Anything',Icons.chat_bubble_outline),
    _AJFeature('Voice AI','Speak & Listen',Icons.mic),
    _AJFeature('AI Hub','Multi-AI',Icons.hub),
    _AJFeature('Memory','Your Knowledge',Icons.psychology_alt),
    _AJFeature('Files','Store & Manage',Icons.folder_open),
    _AJFeature('Messaging','Connect Easily',Icons.mail_outline),
    _AJFeature('Code Studio','Build & Run',Icons.code),
    _AJFeature('Tools','Smart Utilities',Icons.build),
    _AJFeature('More','Explore More',Icons.apps),
  ];
  void open(BuildContext context, String name) {
    if (name == 'AI Chat') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
    } else if (name == 'AI Hub') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AIHubScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FeatureScreen(title: name)));
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF03091E),
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
      child: Column(children: [
        Row(children: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu अभी Preview है।'))),
            icon: const Icon(Icons.menu, color: ajCyan, size: 27)),
          const Expanded(child: Column(children: [
            Text('AJ AI', style: TextStyle(color: ajCyan, fontSize: 27,
              fontWeight: FontWeight.w900, letterSpacing: 2,
              shadows: [Shadow(color: ajBlue, blurRadius: 15)])),
            Text('Welcome Back!  •  Your AI Powerhouse',
              style: TextStyle(color: Color(0xFFDCE7FF), fontSize: 10)),
          ])),
          IconButton(onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const FeatureScreen(title: 'Notifications'))),
            icon: const Icon(Icons.notifications_none, color: Colors.white)),
          IconButton(onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ProfileScreen())),
            icon: const Icon(Icons.settings_outlined, color: Colors.white)),
        ]),
        const SizedBox(height: 8),
        Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFF071A49), Color(0xFF160C3D), Color(0xFF050E2C)]),
            border: Border.all(color: ajBlue.withOpacity(.7)),
            boxShadow: [BoxShadow(color: ajBlue.withOpacity(.22), blurRadius: 22)]),
          child: Column(children: [
            const HolographicCore(size: 188),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF080F2B), border: Border.all(color: ajViolet)),
              child: const Text('♛  Powered by AJ SOFTWARE LABS',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
          ])),
        const SizedBox(height: 14),
        GridView.builder(
          itemCount: features.length, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 9, childAspectRatio: .91),
          itemBuilder: (context, i) {
            final f = features[i];
            final c = i % 3 == 1 ? ajViolet : ajCyan;
            return Material(color: Colors.transparent, child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => open(context, f.title),
              child: Ink(decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0D2855), Color(0xFF090F2B), Color(0xFF180D3D)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: c.withOpacity(.9), width: 1.3),
                boxShadow: [BoxShadow(color: c.withOpacity(.18), blurRadius: 13)]),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(f.icon, color: c, size: 31),
                  const SizedBox(height: 7),
                  Text(f.title, textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                  const SizedBox(height: 3),
                  Text(f.subtitle, textAlign: TextAlign.center, maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFD2DDF7), fontSize: 9)),
                ])),
            ));
          }),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
          decoration: BoxDecoration(color: const Color(0xFF080F2B),
            borderRadius: BorderRadius.circular(28), border: Border.all(color: ajViolet.withOpacity(.7))),
          child: Row(children: [
            Expanded(child: _BottomAction(icon: Icons.home_filled, label: 'Home', onTap: () {})),
            Expanded(child: _BottomAction(icon: Icons.lock_outline, label: 'Login',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login अभी Preview है।'))))),
            Expanded(child: _BottomAction(icon: Icons.logout, label: 'Logout',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guest session में Logout लागू नहीं है।'))))),
            Expanded(child: _BottomAction(icon: Icons.star_border, label: 'Feedback',
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FeatureScreen(title: 'Feedback'))))),
          ])),
        const SizedBox(height: 9),
        const Text('FREE ACCESS  •  SECURE & PRIVATE  •  SUPER FAST',
          style: TextStyle(color: muted, fontSize: 8, letterSpacing: 1)),
      ]),
    )),
  );
}

class _AJFeature {
  final String title, subtitle; final IconData icon;
  const _AJFeature(this.title, this.subtitle, this.icon);
}

class _NeonButton extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _NeonButton({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 50,
    child: DecoratedBox(decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [ajBlue, ajViolet]),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: ajBlue.withOpacity(.28), blurRadius: 16)]),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        onPressed: onTap, icon: Icon(icon), label: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w800)))));
}

class _BottomAction extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _BottomAction({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap, child: Column(children: [
      Icon(icon, color: ajCyan, size: 20),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 9)),
    ]));
}

class AIHubScreen extends StatelessWidget {
  const AIHubScreen({super.key});
  static const items = [
    ('AI Models','मॉडल चयन और उपलब्धता',Icons.memory),
    ('AI Image Generator','AI Art बनाने का workspace',Icons.image_outlined),
    ('AI Writing','लेखन और content सहायता',Icons.edit_note),
    ('AI Research','वेब रिसर्च और स्रोत',Icons.travel_explore),
    ('AI Tools','उपयोगी AI utilities',Icons.build_circle_outlined),
    ('AI Assistant','व्यक्तिगत सहायक सेटिंग',Icons.smart_toy_outlined),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ajDeep,
    appBar: AppBar(backgroundColor: ajDeep, title: const Text('AI Hub')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const HolographicCore(size: 118),
      const SizedBox(height: 12),
      const Center(child: Text('Your AI Feature Center',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
      const Center(child: Text('एक ही जगह पर आपके creative और productivity tools',
        textAlign: TextAlign.center, style: TextStyle(color: muted))),
      const SizedBox(height: 20),
      ...items.map((item) => Card(
        color: const Color(0xFF111A36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ajCyan.withOpacity(.35))),
        child: ListTile(
          leading: Icon(item.$3, color: ajCyan, size: 28),
          title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.$2, style: const TextStyle(color: muted)),
          trailing: const Icon(Icons.chevron_right, color: ajCyan),
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => FeatureScreen(title: item.$1))),
        ))),
    ]),
  );
}

class FeatureScreen extends StatelessWidget {
  final String title;
  const FeatureScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ajDeep,
    appBar: AppBar(backgroundColor: ajDeep, title: Text(title)),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
      mainAxisSize: MainAxisSize.min, children: [
        const HolographicCore(size: 105),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Text('यह स्क्रीन AJ AI के नए डिज़ाइन में जोड़ दी गई है। इस सुविधा का backend और पूरा कार्य अभी अलग से जोड़ना और जाँचना बाकी है।',
          textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFB9C6E8), height: 1.5)),
        const SizedBox(height: 20),
        OutlinedButton.icon(onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back), label: const Text('Dashboard पर वापस जाएँ')),
      ],
    ))),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ajDeep,
    appBar: AppBar(backgroundColor: ajDeep, title: const Text('Profile & Settings')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const HolographicCore(size: 100),
      const SizedBox(height: 12),
      const Center(child: Text('AJ AI Account', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
      const SizedBox(height: 18),
      for (final entry in [
        (Icons.language, 'Language & Hindi Mode'),
        (Icons.psychology_outlined, 'Memory & Personalization'),
        (Icons.lock_outline, 'Privacy & Security'),
        (Icons.notifications_outlined, 'Notifications'),
        (Icons.info_outline, 'About AJ SOFTWARE LABS'),
      ]) Card(color: const Color(0xFF111A36), child: ListTile(
        leading: Icon(entry.$1, color: ajCyan), title: Text(entry.$2),
        trailing: const Icon(Icons.chevron_right, color: ajCyan),
        onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => FeatureScreen(title: entry.$2))),
      )),
    ]),
  );
}
