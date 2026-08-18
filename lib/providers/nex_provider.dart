import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/supabase_service.dart';

class NexProvider extends ChangeNotifier {
  final SupabaseService? _supabaseService;
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  NexProvider({SupabaseService? supabaseService})
      : _supabaseService = supabaseService {
    _loadHistory();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  Future<void> _loadHistory() async {
    if (_supabaseService == null) return;
    try {
      final rows = await _supabaseService.loadChatMessages();
      for (final row in rows) {
        _messages.add(ChatMessage(
          id: row['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          text: row['text'] as String? ?? '',
          isUser: row['is_user'] as bool? ?? true,
          timestamp: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
        ));
      }
      if (_messages.isNotEmpty) notifyListeners();
    } catch (_) {
      // Chat works locally even if DB load fails
    }
  }

  static const List<String> suggestedPrompts = [
    'Find me new contracts in IT services',
    'Help me write a capability statement',
    'Analyze my win rate trends',
    'What set-asides am I eligible for?',
    'Draft a proposal executive summary',
    'Review compliance requirements for a bid',
  ];

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final trimmed = text.trim();
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isTyping = true;
    notifyListeners();

    _supabaseService?.saveChatMessage(text: trimmed, isUser: true);
    _generateResponse(trimmed);
  }

  Future<void> _generateResponse(String userText) async {
    final lower = userText.toLowerCase();

    // Simulate thinking delay
    await Future.delayed(const Duration(milliseconds: 1200));

    String response;

    if (lower.contains('contract') && (lower.contains('find') || lower.contains('search') || lower.contains('new'))) {
      response = '''I found **12 new contracts** matching your profile this week:

• **USAF IT Modernization** — \$4.2M, Due: Aug 15
• **VA Health Records System** — \$2.8M, Due: Aug 22
• **DHS Cybersecurity Assessment** — \$1.5M, Due: Sep 1
• **DOD Cloud Migration** — \$6.1M, Due: Sep 10

Plus 8 more. Want me to filter by agency, set-aside, or value range? You can also go to the **Contracts tab** to browse and save opportunities.''';
    } else if (lower.contains('capability') || lower.contains('statement')) {
      response = '''I can help you build a strong **Capability Statement**. Here's what I'll need:

1. **Company overview** — your core competencies
2. **Past performance** — 3-5 relevant contracts
3. **Differentiators** — what sets you apart
4. **Certifications** — NAICS codes, set-asides, clearances

Would you like me to start with a template, or should I work from your existing company info? You can also use the **Capability Statement tool** on the Dashboard.''';
    } else if (lower.contains('win rate') || lower.contains('analytics') || lower.contains('trend')) {
      response = '''Here's your **performance snapshot**:

📊 **Win Rate:** 34% (up 6% from last quarter)
📋 **Bids Submitted:** 28 this quarter
✅ **Contracts Won:** 9
💰 **Total Value Won:** \$12.4M

**Top performing areas:**
• IT Services — 52% win rate
• Cybersecurity — 41% win rate
• Cloud Solutions — 38% win rate

Want me to break this down by agency or time period?''';
    } else if (lower.contains('set-aside') || lower.contains('eligible') || lower.contains('small business')) {
      response = '''Based on your company profile, you may qualify for these **set-asides**:

✅ **Small Business** — Primary qualification
✅ **8(a) Business Development** — If SBA certified
⚠️ **HUBZone** — Requires principal office in HUBZone area
⚠️ **SDVOSB** — Requires veteran ownership documentation
❌ **WOSB** — Requires 51%+ women ownership

**Tip:** Having at least 2 set-aside certifications significantly increases your contract pipeline. Want me to help you start the certification process for any of these?''';
    } else if (lower.contains('proposal') || lower.contains('executive summary') || lower.contains('draft')) {
      response = '''I'll draft an **Executive Summary** for you. To create a strong one, I'll tailor it with:

**Structure I'll follow:**
1. **Opening hook** — Why your firm is the right choice
2. **Understanding of requirements** — Show you "get it"
3. **Technical approach** — High-level solution overview
4. **Past performance** — Relevant contract examples
5. **Key differentiators** — What sets you apart

Which contract or solicitation should I draft this for? Share the solicitation number or a brief description and I'll get started.''';
    } else if (lower.contains('compliance') || lower.contains('review') || lower.contains('requirement')) {
      response = '''I can run a **compliance review** on any bid package. Here's what I check:

📋 **Document completeness** — All required forms & attachments
📐 **Format compliance** — Page limits, fonts, margins
🔒 **Security requirements** — Clearance levels, CMMC
📊 **Technical requirements** — Section L/M alignment
💰 **Pricing structure** — Rate validation & cost realism

Share your solicitation details and I'll generate a compliance checklist. You can also use the **Compliance Checker tool** on the Dashboard for automated scanning.''';
    } else if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey') || lower.contains('help')) {
      response = '''Hey there! 👋 I'm **Nex**, your AI procurement assistant. I can help you with:

🔍 **Find contracts** — Search opportunities matching your profile
📝 **Write proposals** — Draft executive summaries and technical volumes
📊 **Analyze performance** — Win rates, trends, and insights
✅ **Check compliance** — Review bid packages for completeness
🏢 **Capability statements** — Build professional cap statements
💡 **Strategy** — Set-aside eligibility, pricing, and teaming

What would you like to work on?''';
    } else if (lower.contains('price') || lower.contains('pricing') || lower.contains('cost') || lower.contains('rate')) {
      response = '''I can help with **pricing strategy**. Here are a few approaches:

💰 **Competitive Analysis** — I'll benchmark your rates against market data
📊 **Price-to-Win** — Model what the government expects to pay
🧮 **Cost Buildup** — Labor categories, overhead, G&A, profit margin
📈 **Rate Comparison** — Compare your rates vs. GSA Schedule rates

**Quick tip:** Government evaluators typically look for rates that are fair and reasonable — not necessarily the lowest. A strong technical score often outweighs a 5-10% price difference.

Which approach would you like to explore?''';
    } else if (lower.contains('team') || lower.contains('partner') || lower.contains('subcontract')) {
      response = '''**Teaming & Partnerships** can dramatically increase your win rate. Here's how I can help:

🤝 **Find teaming partners** — Match with complementary firms
📋 **Teaming agreements** — Draft template TAs
🏗️ **Mentor-Protégé** — Explore SBA programs
📊 **Past performance gaps** — Identify areas where a partner fills gaps

**Current market insight:** Prime contractors in IT services are actively seeking small business partners to meet subcontracting plan requirements.

Want me to search for potential teaming partners in your NAICS codes?''';
    } else {
      response = '''Great question! Let me help you with that.

Based on what you're asking about, I'd recommend starting with one of these approaches:

1. **Search for relevant contracts** in the Contracts tab
2. **Use a specialized tool** from the Dashboard (like Bid Writer, Compliance Checker, or Market Intel)
3. **Ask me something specific** — I work best with focused procurement questions

Here are some things I'm great at:
• Finding and filtering contract opportunities
• Drafting proposal sections and capability statements
• Analyzing win rates and market trends
• Reviewing compliance requirements

What would you like to dive into?''';
    }

    final botMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(botMsg);
    _isTyping = false;
    notifyListeners();

    _supabaseService?.saveChatMessage(text: response, isUser: false);
  }

  void clearChat() {
    _messages.clear();
    _isTyping = false;
    notifyListeners();
    _supabaseService?.clearChatMessages();
  }
}
