import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/voice/voice_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final VoiceResponse? response;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.response,
  });
}

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputCtrl = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  late AnimationController _pulseCtrl;

  String _voiceLang = LocalStorageService.voiceLanguage;
  late LocationInfo _location;

  @override
  void initState() {
    super.initState();
    _location = LocationService.currentLocation;
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Initial greeting
    _messages.add(
      ChatMessage(
        text: _getGreetingForLang(_voiceLang),
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  String _getGreetingForLang(String lang) {
    switch (lang) {
      case 'hi':
        return 'नमस्ते! आप बोलकर या लिखकर पंचांग, सूर्योदय, एकादशी या मुहूर्त के बारे में पूछ सकते हैं।';
      case 'gu':
        return 'નમસ્તે! તમે બોલીને કે લખીને પંચાંગ, સૂર્યોદય, એકાદશી કે શુભ મુહૂર્ત વિશે પૂછી શકો છો.';
      case 'mr':
        return 'नमस्कार! आपण बोलून किंवा लिहून पंचांग, सूर्योदय, एकादशी किंवा शुभ मुहूर्ताबद्दल विचारू शकता.';
      case 'bho':
        return 'प्रणाम! का बा? रउवा बोल के चाहे लिख के आजु के पंचांग, एकादशी, सूर्योदय भा लगन-मुहूर्त पूछ सकत बानी।';
      default:
        return 'Namaste! Ask any question about Panchang, sunrise, Ekadashi, or auspicious Muhurat by typing or speaking.';
    }
  }

  void _handleSend(String query) {
    if (query.trim().isEmpty) return;
    _inputCtrl.clear();

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
    });

    // Process using offline Voice/NLP pipeline
    final response = VoiceService.processVoiceQuery(
      query: query,
      defaultLocation: _location,
      voiceLanguageCode: _voiceLang,
      tradition: LocalStorageService.selectedTradition,
    );

    setState(() {
      _messages.add(ChatMessage(
        text: response.spokenText,
        isUser: false,
        response: response,
      ));
    });
  }

  void _toggleMic() {
    if (_isListening) {
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      // Simulate speech recognition capture of quick phrases for seamless demonstration
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (!mounted || !_isListening) return;
        setState(() => _isListening = false);
        // Default sample query matching voice language
        String sampleQuery;
        switch (_voiceLang) {
          case 'hi':
            sampleQuery = 'अगली एकादशी कब है?';
            break;
          case 'gu':
            sampleQuery = 'આવતા મહિને અમદાવાદમાં ગૃહ પ્રવેશનું મુહૂર્ત ક્યારે છે?';
            break;
          case 'bho':
            sampleQuery = 'अगिला एकादशी कब बा?';
            break;
          case 'mr':
            sampleQuery = 'उद्या सूर्योदय किती वाजता आहे?';
            break;
          default:
            sampleQuery = 'When is Griha Pravesh Muhurat in Ahmedabad next month?';
        }
        _handleSend(sampleQuery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎙️ Ask Panchang'),
        actions: [
          // Voice Language Selector (Section 41)
          DropdownButton<String>(
            value: _voiceLang,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.record_voice_over, size: 18, color: AppTheme.saffronPrimary),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('Voice: English')),
              DropdownMenuItem(value: 'hi', child: Text('Voice: हिन्दी')),
              DropdownMenuItem(value: 'gu', child: Text('Voice: ગુજરાતી')),
              DropdownMenuItem(value: 'mr', child: Text('Voice: मराठी')),
              DropdownMenuItem(value: 'bho', child: Text('Voice: भोजपुरी')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _voiceLang = val;
                  LocalStorageService.voiceLanguage = val;
                });
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Quick Questions Carousel (Section 65)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.cardBackground,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('Today\'s Panchang'),
                  _buildQuickChip('Sunrise Time'),
                  _buildQuickChip('Sunset Time'),
                  _buildQuickChip('Next Ekadashi'),
                  _buildQuickChip('Today\'s Rahu Kaal'),
                  _buildQuickChip('Griha Pravesh Muhurat'),
                  _buildQuickChip('Vehicle Muhurat this weekend'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (ctx, idx) {
                final msg = _messages[idx];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Listening Indicator if active
          if (_isListening)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppTheme.saffronPrimary.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseCtrl.value * 0.3),
                        child: const Icon(Icons.mic, color: AppTheme.saffronPrimary, size: 28),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Listening... Speak now',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.saffronPrimary),
                  ),
                ],
              ),
            ),

          // Input Bar with Mic & Send buttons
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.stop_circle : Icons.mic,
                    color: _isListening ? AppTheme.notSuitableRed : AppTheme.saffronPrimary,
                    size: 28,
                  ),
                  onPressed: _toggleMic,
                ),
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    decoration: InputDecoration(
                      hintText: 'Ask or type here...',
                      filled: true,
                      fillColor: AppTheme.borderSubtle.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _handleSend,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.saffronPrimary),
                  onPressed: () => _handleSend(_inputCtrl.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        onPressed: () => _handleSend(text),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.saffronPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderSubtle),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text('🪔 ', style: TextStyle(fontSize: 16)),
                Text('Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.deepMaroon)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: const TextStyle(fontSize: 14, height: 1.4, color: AppTheme.deepText),
            ),
            if (msg.response != null && msg.response!.displayText.isNotEmpty) ...[
              const Divider(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  msg.response!.displayText,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.deepText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
