import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  void _addGreeting() {
    String userName = '';
    try {
      final email = Supabase.instance.client.auth.currentUser?.email ?? '';
      final name = email.split('@').first;
      if (name.isNotEmpty) userName = name[0].toUpperCase() + name.substring(1);
    } catch (_) {}

    final greeting = '''Hey${userName.isNotEmpty ? ', $userName' : ''}! 👋 I'm **Nex**, your AI procurement assistant.

Here's what I can help you with today:

🔍 **Find contracts** — Search new opportunities matching your profile
📝 **Write proposals** — Draft executive summaries and technical volumes
📊 **Analyze performance** — Win rates, trends, and pipeline insights
✅ **Check compliance** — Review bid packages for missing requirements
🏢 **Capability statements** — Build professional cap statements
💡 **Strategy** — Set-aside eligibility, pricing, and teaming advice

Tap a suggestion below or just ask me anything!''';

    _messages.add(ChatMessage(
      id: 'greeting',
      text: greeting,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  Future<void> _loadHistory() async {
    if (_supabaseService != null) {
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
      } catch (_) {
        // Chat works locally even if DB load fails
      }
    }
    // Show greeting when opening for the first time (no history)
    if (_messages.isEmpty) {
      _addGreeting();
    }
    notifyListeners();
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
    } else if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey') || lower.contains('help') || lower.contains('what can you do') || lower.contains('what do you do')) {
      response = '''Hey there! 👋 I'm **Nex**, your AI procurement assistant. I can help you with:

🔍 **Find contracts** — Search opportunities matching your profile
📝 **Write proposals** — Draft executive summaries and technical volumes
📊 **Analyze performance** — Win rates, trends, and insights
✅ **Check compliance** — Review bid packages for completeness
🏢 **Capability statements** — Build professional cap statements
💡 **Strategy** — Set-aside eligibility, pricing, and teaming

What would you like to work on?''';
    } else if (lower.contains('naics') || lower.contains('code') || lower.contains('category')) {
      response = '''**NAICS codes** are the foundation of your procurement strategy. Here's what I can do:

📋 **NAICS lookup** — Find the right codes for your services
🎯 **Primary vs. secondary** — Prioritize codes that match your strongest work
📊 **Competition analysis** — See how many firms compete in each code
💰 **Contract volume** — Which NAICS codes have the most federal spending

**Common IT & Services NAICS codes:**
• **541511** — Custom Computer Programming Services
• **541512** — Computer Systems Design
• **541519** — Other Computer-Related Services
• **541990** — All Other Professional & Technical Services
• **518210** — Data Processing & Hosting

Which NAICS codes are you currently registered under? I can help optimize your profile.''';
    } else if (lower.contains('deadline') || lower.contains('due') || lower.contains('urgent') || lower.contains('upcoming')) {
      response = '''Here are your **upcoming bid deadlines** this month:

🔴 **URGENT — Due in 3 days:**
• VA Health Records System — \$2.8M (Due Aug 21)

🟡 **Due this week:**
• DHS Network Security Assessment — \$890K (Due Aug 23)
• GSA Facilities Management Support — \$1.2M (Due Aug 25)

🟢 **Due next 2 weeks:**
• USAF IT Modernization — \$4.2M (Due Aug 29)
• DOD Cloud Infrastructure — \$6.1M (Due Sep 2)
• HHS Digital Transformation — \$3.3M (Due Sep 5)

**Tip:** I recommend starting the VA Health Records bid today — 3 days is tight for a \$2.8M opportunity.

Want me to help prioritize which ones to pursue?''';
    } else if (lower.contains('agency') || lower.contains('department') || lower.contains('federal') || lower.contains('government')) {
      response = '''I can help you target the right **federal agencies** for your business. Here's a snapshot:

🏛️ **Top agencies by IT spending:**
• **DOD** — \$42B/year (largest buyer)
• **HHS** — \$11B/year (health IT focus)
• **DHS** — \$8B/year (cybersecurity heavy)
• **VA** — \$6B/year (healthcare systems)
• **GSA** — \$5B/year (enterprise services)

📊 **Your best agency matches** (based on profile):
1. **DHS** — Strong match for your cybersecurity work
2. **VA** — Good fit for healthcare IT services
3. **GSA** — Schedule vehicles available

**Pro tip:** DHS and VA tend to favor small businesses with past performance. Do you have any past performance with these agencies?''';
    } else if (lower.contains('price') || lower.contains('pricing') || lower.contains('cost') || lower.contains('rate') || lower.contains('labor') || lower.contains('billing')) {
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
    } else if (lower.contains('certif') || lower.contains('sba') || lower.contains('8a') || lower.contains('hubzone') || lower.contains('wosb') || lower.contains('sdvosb')) {
      response = '''**SBA Certifications** can unlock billions in set-aside contracts. Here's a breakdown:

✅ **Small Business** — Auto-qualified if under size standards for your NAICS
📋 **8(a) Business Development** — 9-year program, sole-source up to \$4.5M
🗺️ **HUBZone** — Principal office + 35% employees in HUBZone area
⚔️ **SDVOSB** — 51%+ veteran-owned, self-certified or VA-verified
👩 **WOSB** — 51%+ women-owned, unlocks \$4B+ annually in set-asides
🌍 **EDWOSB** — Economically disadvantaged WOSB, even more opportunities

**Application timelines:**
• 8(a): 6-12 months to certify
• HUBZone: 90 days
• WOSB/EDWOSB: 30-60 days (SBA.gov)
• SDVOSB: 30 days (VA VSIP portal)

Which certification are you most interested in pursuing? I can walk you through the requirements.''';
    } else {
      // Context-aware fallback — extract key words to make it feel intelligent
      final words = lower.split(' ').where((w) => w.length > 4).take(3).join(', ');
      response = '''I want to make sure I give you the most useful answer on **${words.isNotEmpty ? words : 'this topic'}**.

Here's how I can help right now:

📋 **Tell me more** — What specifically are you trying to accomplish? (e.g., "find contracts in cybersecurity" or "write an executive summary for solicitation W15QKN-24-R-0012")

🔍 **Search contracts** — Head to the **Contracts tab** to browse live opportunities
🛠️ **Use a tool** — The **Dashboard** has specialized tools for bid writing, compliance, and market research
💬 **Ask Nex directly** — Try a more specific question and I'll get you a precise answer

**Some things I answer really well:**
• "Find me set-aside contracts in [NAICS code]"
• "What's my win rate for [agency]?"
• "Help me draft a technical approach for [requirement]"
• "Check compliance for [solicitation details]"

What would you like to focus on?''';
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
