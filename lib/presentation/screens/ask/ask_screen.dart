import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/voice/speech_recognition_service.dart';
import '../../../services/voice/voice_service.dart';
import '../settings/settings_screen.dart';

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

    // Initial greeting matching voice assistant language
    _messages.add(
      ChatMessage(
        text: _getGreetingForLang(_voiceLang),
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    SpeechRecognitionService.stopListening();
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
      SpeechRecognitionService.stopListening();
      setState(() => _isListening = false);
    } else {
      final success = SpeechRecognitionService.startListening(
        langCode: _voiceLang,
        onResult: (text, isFinal) {
          if (!mounted) return;
          setState(() {
            _inputCtrl.text = text;
          });
          if (isFinal) {
            setState(() => _isListening = false);
            _handleSend(text);
          }
        },
        onError: (err) {
          if (!mounted) return;
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech error: $err. You can type your query directly.'),
              backgroundColor: AppTheme.notSuitableRed,
              duration: const Duration(seconds: 4),
            ),
          );
        },
        onEnd: () {
          if (!mounted) return;
          if (_isListening) {
            setState(() => _isListening = false);
            if (_inputCtrl.text.trim().isNotEmpty) {
              _handleSend(_inputCtrl.text.trim());
            }
          }
        },
      );

      if (success) {
        setState(() => _isListening = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone access is not supported or was blocked. Please type your query.'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  List<String> _getQuickQueriesForLang(String lang) {
    switch (lang) {
      case 'hi':
        return [
          'आज का पंचांग',
          'सूर्योदय का समय',
          'अगली एकादशी कब है?',
          'आज का राहु काल',
          'गाड़ी खरीदने का मुहूर्त',
          'गृह प्रवेश का मुहूर्त',
          'विवाह मुहूर्त कब है?',
        ];
      case 'gu':
        return [
          'આજનું પંચાંગ',
          'સૂર્યોદય સમય',
          'આગામી એકાદશી ક્યારે છે?',
          'આજનો રાહુ કાળ',
          'વાહન ખરીદવાનું મુહૂર્ત',
          'ગૃહ પ્રવેશનું મુહૂર્ત',
          'લગ્ન મુહૂર્ત ક્યારે છે?',
        ];
      case 'mr':
        return [
          'आजचे पंचांग',
          'सूर्योदय वेळ',
          'पुढील एकादशी कधी आहे?',
          'आजचा राहु काळ',
          'वाहन खरेदी मुहूर्त',
          'गृह प्रवेश मुहूर्त',
          'विवाह मुहूर्त कधी आहे?',
        ];
      case 'bho':
        return [
          'आजु के पंचांग',
          'सूर्योदय के समय',
          'अगिला एकादशी कब बा?',
          'आजु के राहु काल',
          'गाड़ी खरीदे के मुहूर्त',
          'गृह प्रवेश के मुहूर्त',
          'लगन कवने बेरा बा?',
        ];
      default:
        return [
          'Today\'s Panchang',
          'Sunrise Time',
          'Next Ekadashi',
          'Today\'s Rahu Kaal',
          'Vehicle Purchase Muhurat',
          'Griha Pravesh Muhurat',
          'Marriage Muhurat',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiLang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;
    final quickQueries = _getQuickQueriesForLang(uiLang);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🎙️ ${AppLocalizations.tr('ask_panchang', uiLang)}',
          style: TextStyle(
            fontSize: isElder ? 20 : 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Voice Assistant Language Selector (Section 41)
          DropdownButton<String>(
            value: _voiceLang,
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.record_voice_over, size: isElder ? 22 : 18, color: AppTheme.saffronPrimary),
            items: [
              DropdownMenuItem(value: 'en', child: Text('Voice: English', style: TextStyle(fontSize: isElder ? 14 : 12.5))),
              DropdownMenuItem(value: 'hi', child: Text('Voice: हिन्दी', style: TextStyle(fontSize: isElder ? 14 : 12.5))),
              DropdownMenuItem(value: 'gu', child: Text('Voice: ગુજરાતી', style: TextStyle(fontSize: isElder ? 14 : 12.5))),
              DropdownMenuItem(value: 'mr', child: Text('Voice: मराठी', style: TextStyle(fontSize: isElder ? 14 : 12.5))),
              DropdownMenuItem(value: 'bho', child: Text('Voice: भोजपुरी', style: TextStyle(fontSize: isElder ? 14 : 12.5))),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _voiceLang = val;
                  LocalStorageService.voiceLanguage = val;
                  if (_messages.length == 1 && !_messages[0].isUser) {
                    _messages[0] = ChatMessage(
                      text: _getGreetingForLang(_voiceLang),
                      isUser: false,
                    );
                  }
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, size: isElder ? 26 : 22),
            tooltip: AppLocalizations.tr('settings', uiLang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) {
                setState(() {
                  _location = LocationService.currentLocation;
                  _voiceLang = LocalStorageService.voiceLanguage;
                  if (_messages.length == 1 && !_messages[0].isUser) {
                    _messages[0] = ChatMessage(
                      text: _getGreetingForLang(_voiceLang),
                      isUser: false,
                    );
                  }
                });
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            children: [
              // Quick Questions Carousel (Section 65)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: isElder ? 10 : 8),
                color: AppTheme.cardBackground,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: quickQueries.map((q) => _buildQuickChip(q, isElder)).toList(),
                  ),
                ),
              ),
              const Divider(height: 1),

              // Messages List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(isElder ? 18 : 16),
                  itemCount: _messages.length,
                  itemBuilder: (ctx, idx) {
                    final msg = _messages[idx];
                    return _buildMessageBubble(msg, isElder, uiLang);
                  },
                ),
              ),

              // Listening Indicator if active
              if (_isListening)
                Container(
                  padding: EdgeInsets.all(isElder ? 16 : 12),
                  color: AppTheme.saffronPrimary.withOpacity(0.12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseCtrl.value * 0.35),
                            child: Icon(Icons.mic, color: AppTheme.saffronPrimary, size: isElder ? 34 : 28),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.tr('listening', uiLang),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isElder ? 17 : 14.5,
                          color: AppTheme.saffronPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Input Bar with Mic & Send buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isElder ? 14 : 10),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: _isListening ? 'Stop' : 'Speak',
                      icon: Icon(
                        _isListening ? Icons.stop_circle : Icons.mic,
                        color: _isListening ? AppTheme.notSuitableRed : AppTheme.saffronPrimary,
                        size: isElder ? 32 : 28,
                      ),
                      onPressed: _toggleMic,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputCtrl,
                        style: TextStyle(fontSize: isElder ? 17 : 14.5),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.tr('ask_or_type', uiLang),
                          hintStyle: TextStyle(fontSize: isElder ? 16 : 14),
                          filled: true,
                          fillColor: AppTheme.borderSubtle.withOpacity(0.3),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isElder ? 14 : 10),
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
                      icon: Icon(Icons.send, color: AppTheme.saffronPrimary, size: isElder ? 28 : 24),
                      onPressed: () => _handleSend(_inputCtrl.text),
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

  Widget _buildQuickChip(String text, bool isElder) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          text,
          style: TextStyle(
            fontSize: isElder ? 14.5 : 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: isElder ? 10 : 6, vertical: isElder ? 6 : 2),
        onPressed: () => _handleSend(text),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isElder, String uiLang) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 40),
          padding: EdgeInsets.symmetric(horizontal: isElder ? 18 : 16, vertical: isElder ? 12 : 10),
          decoration: BoxDecoration(
            color: AppTheme.saffronPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            msg.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: isElder ? 17 : 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        padding: EdgeInsets.all(isElder ? 16 : 14),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('🪔 ', style: TextStyle(fontSize: isElder ? 19 : 16)),
                Text(
                  AppLocalizations.tr('ask_panchang', uiLang),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isElder ? 15.5 : 13,
                    color: AppTheme.deepMaroon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: isElder ? 17 : 14.5,
                height: 1.4,
                color: AppTheme.deepText,
              ),
            ),
            if (msg.response != null && msg.response!.displayText.isNotEmpty) ...[
              const Divider(height: 16),
              Container(
                padding: EdgeInsets.all(isElder ? 12 : 10),
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  msg.response!.displayText,
                  style: TextStyle(
                    fontSize: isElder ? 14.5 : 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

