import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/user_profile.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/voice/tts_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  final TextEditingController _phoneCtrl = TextEditingController(text: '+91 ');
  int _currentStep = 0; // 0: Language, 1: Elder Mode, 2: Tour, 3: Sign In

  // State
  String _selectedLang = LocalStorageService.appLanguage;
  bool _elderMode = LocalStorageService.elderMode;
  int _tourIndex = 0;
  bool _isPlayingVoice = false;
  bool _isSigningIn = false;
  Timer? _voiceTimer;

  @override
  void dispose() {
    _voiceTimer?.cancel();
    TtsService.stop();
    _phoneCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _voiceTimer?.cancel();
    TtsService.stop();
    setState(() => _currentStep = step);
    _pageCtrl.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );

    if (step == 2) {
      // Start tour voice guide automatically
      _playTourVoice(_tourIndex);
    }
  }

  void _finish() {
    _voiceTimer?.cancel();
    TtsService.stop();
    LocalStorageService.appLanguage = _selectedLang;
    LocalStorageService.voiceLanguage = _selectedLang;
    LocalStorageService.elderMode = _elderMode;
    LocalStorageService.isOnboardingComplete = true;
    widget.onComplete();
  }

  void _playTourVoice(int index) {
    final tourData = _getTourData(_selectedLang);
    final textToSpeak = tourData[index]['speech'] ?? tourData[index]['desc']!;
    setState(() => _isPlayingVoice = true);
    TtsService.speak(text: textToSpeak, langCode: _selectedLang);

    // Reset indicator after a few seconds
    _voiceTimer?.cancel();
    _voiceTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _isPlayingVoice = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Bar (3 Steps: Language, View Mode, App Tour)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _buildStepIndicator(0, '1. भाषा'),
                  const SizedBox(width: 8),
                  _buildStepIndicator(1, '2. दृश्य'),
                  const SizedBox(width: 8),
                  _buildStepIndicator(2, '3. परिचय'),
                  // const SizedBox(width: 6),
                  // _buildStepIndicator(3, '4. साइन इन'), // Commented out until Firebase setup
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLanguageStep(),
                  _buildElderModeStep(),
                  _buildTourStep(),
                  // _buildSignInStep(), // Commented out until Firebase setup
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isDone || isActive ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.saffronPrimary : AppTheme.subtleText,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // STEP 1: Language Selection
  // -------------------------------------------------------------
  Widget _buildLanguageStep() {
    final langs = [
      {'code': 'hi', 'native': 'हिन्दी', 'sub': 'Hindi', 'greeting': 'नमस्ते! अपनी भाषा चुनें'},
      {'code': 'en', 'native': 'English', 'sub': 'English', 'greeting': 'Welcome! Select your language'},
      {'code': 'gu', 'native': 'ગુજરાતી', 'sub': 'Gujarati', 'greeting': 'નમસ્તે! તમારી ભાષા પસંદ કરો'},
      {'code': 'mr', 'native': 'मराठी', 'sub': 'Marathi', 'greeting': 'नमस्कार! आपली भाषा निवडा'},
      {'code': 'bho', 'native': 'भोजपुरी', 'sub': 'Bhojpuri', 'greeting': 'प्रणाम! आपन भाषा चुनीं'},
    ];

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🪔', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          const Text(
            'अपनी पसंदीदा भाषा चुनें\nChoose Your Language',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepText),
          ),
          const SizedBox(height: 6),
          const Text(
            'पंचांग, त्योहार और आवाज़ की सुविधा इस भाषा में मिलेगी।\nYou can also change this anytime later.',
            style: TextStyle(fontSize: 13, color: AppTheme.subtleText),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: langs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final l = langs[idx];
                final isSelected = _selectedLang == l['code'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedLang = l['code']!;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.saffronPrimary.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.saffronPrimary : const Color(0xFFF3EBE1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              l['native']!.substring(0, 1),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.deepText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l['native']!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepText),
                              ),
                              Text(
                                '${l['sub']} • ${l['greeting']}',
                                style: TextStyle(fontSize: 12.5, color: AppTheme.subtleText),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppTheme.saffronPrimary, size: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
              ),
              onPressed: () => _goToStep(1),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('आगे बढ़ें • Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // STEP 2: Elder / Senior Citizen Mode Prompt in Simple Words
  // -------------------------------------------------------------
  Widget _buildElderModeStep() {
    final texts = _getElderTexts(_selectedLang);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goToStep(0),
              ),
              const SizedBox(width: 6),
              const Text('👓', style: TextStyle(fontSize: 30)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            texts['question']!,
            style: TextStyle(
              fontSize: _elderMode ? 23 : 21,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            texts['desc']!,
            style: TextStyle(
              fontSize: _elderMode ? 15 : 13.5,
              color: AppTheme.subtleText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Choice Cards
          InkWell(
            onTap: () {
              setState(() {
                _elderMode = true;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _elderMode ? AppTheme.saffronPrimary.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _elderMode ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                  width: _elderMode ? 2.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _elderMode ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _elderMode ? AppTheme.saffronPrimary : AppTheme.subtleText,
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts['yes_title']!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _elderMode ? AppTheme.saffronPrimary : AppTheme.deepText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          texts['yes_sub']!,
                          style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          InkWell(
            onTap: () {
              setState(() {
                _elderMode = false;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: !_elderMode ? AppTheme.saffronPrimary.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !_elderMode ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                  width: !_elderMode ? 2.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    !_elderMode ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: !_elderMode ? AppTheme.saffronPrimary : AppTheme.subtleText,
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts['no_title']!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: !_elderMode ? AppTheme.saffronPrimary : AppTheme.deepText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          texts['no_sub']!,
                          style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Live Text Preview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBE1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      texts['preview_label']!,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.deepText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  texts['sample_panchang']!,
                  style: TextStyle(
                    fontSize: _elderMode ? 17 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _goToStep(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(texts['btn_continue']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // STEP 3: Interactive App Tour with Native Voice Guide
  // -------------------------------------------------------------
  Widget _buildTourStep() {
    final tourData = _getTourData(_selectedLang);
    final currentItem = tourData[_tourIndex];
    final isLast = _tourIndex == tourData.length - 1;

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goToStep(1),
              ),
              TextButton(
                onPressed: _finish,
                child: Text(
                  _selectedLang == 'hi' ? 'छोड़ें (Skip)' : 'Skip',
                  style: const TextStyle(color: AppTheme.subtleText, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            _getTourHeader(_selectedLang),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepText),
          ),
          const SizedBox(height: 4),
          Text(
            _getTourSubHeader(_selectedLang),
            style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
          ),

          const SizedBox(height: 20),

          // Main Tour Card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppTheme.saffronPrimary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(currentItem['icon']!, style: const TextStyle(fontSize: 38)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentItem['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _elderMode ? 22 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentItem['desc']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _elderMode ? 17 : 14.5,
                      color: AppTheme.subtleText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Voice Play Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.saffronPrimary,
                      side: const BorderSide(color: AppTheme.saffronPrimary),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: Icon(_isPlayingVoice ? Icons.volume_up : Icons.play_arrow, size: 20),
                    label: Text(
                      _isPlayingVoice
                          ? (_selectedLang == 'hi' ? 'आवाज़ बज रही है...' : 'Speaking...')
                          : (_selectedLang == 'hi' ? '🔊 आवाज़ सुनें (Listen)' : '🔊 Listen Voice Guide'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _playTourVoice(_tourIndex),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tour Progress Dots & Nav Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(tourData.length, (idx) {
              return Container(
                width: _tourIndex == idx ? 22 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _tourIndex == idx ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              if (_tourIndex > 0)
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() => _tourIndex--);
                      _playTourVoice(_tourIndex);
                    },
                    child: Text(_selectedLang == 'hi' ? 'पिछला' : 'Back'),
                  ),
                ),
              if (_tourIndex > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.saffronPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (isLast) {
                      _finish();
                    } else {
                      setState(() => _tourIndex++);
                      _playTourVoice(_tourIndex);
                    }
                  },
                  child: Text(
                    isLast
                        ? (_selectedLang == 'hi' ? 'ऐप शुरू करें • Start App' : 'Start App')
                        : (_selectedLang == 'hi' ? 'अगला (Next)' : 'Next'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Multilingual Data Dictionaries
  // -------------------------------------------------------------
  Map<String, String> _getElderTexts(String lang) {
    switch (lang) {
      case 'gu':
        return {
          'question': 'શું તમે વાંચવા માટે મોટા અક્ષરો અને સરળ દૃશ્ય (વરિષ્ઠ મોડ) રાખવા માંગો છો?',
          'desc': 'આ વડીલો માટે અને સરળતાથી વાંચવા માટે ફોન્ટ મોટા અને સ્પષ્ટ રાખશે.',
          'yes_title': 'હા, મોટા અક્ષર રાખો (વરિષ્ઠ મોડ)',
          'yes_sub': 'મોટો ફોન્ટ, સ્પષ્ટ સમય અને સરળ વાંચન',
          'no_title': 'ના, સામાન્ય માપ બરાબર છે',
          'no_sub': 'માનક ફોન્ટ અને સંપૂર્ણ સ્ક્રીન દૃશ્ય',
          'preview_label': 'અક્ષર માપનું ઉદાહરણ (Live Preview):',
          'sample_panchang': 'આસો સુદ પડવો • સૂર્યોદય: ૦૬:૨૮ • શુભ ચોઘડિયા',
          'btn_continue': 'આગળ વધો',
        };
      case 'mr':
        return {
          'question': 'तुम्हाला वाचण्यासाठी मोठी अक्षरे आणि सोपे दृश्य (ज्येष्ठ नागरिक मोड) हवे आहे का?',
          'desc': 'हे ज्येष्ठ नागरिकांसाठी आणि वाचण्यास सोपे जाण्यासाठी अक्षरे मोठी ठेवेल.',
          'yes_title': 'होय, मोठी अक्षरे ठेवा (ज्येष्ठ नागरिक मोड)',
          'yes_sub': 'मोठे फॉन्ट, ठळक वेळ आणि वाचण्यास सोपे',
          'no_title': 'नाही, सामान्य आकार ठीक आहे',
          'no_sub': 'प्रमाणित फॉन्ट आणि संपूर्ण स्क्रीन दृश्य',
          'preview_label': 'अक्षरांचा नमुना (Live Preview):',
          'sample_panchang': 'आश्विन शुक्ल प्रतिपदा • सूर्योदय: ०६:२८ • शुभ चौघडिया',
          'btn_continue': 'पुढे जा',
        };
      case 'bho':
        return {
          'question': 'का रउआ पढ़े खातिर बड़हन अक्षर आ सीधा दृश्य (बुजुर्ग मोड) चाहत बानी?',
          'desc': 'ई बुजुर्ग लोग खातिर आ आसानी से पढ़े खातिर अक्षर बड़ आ साफ क दी।',
          'yes_title': 'हँ, बड़हन अक्षर राखीं (बुजुर्ग मोड)',
          'yes_sub': 'बड़हन फॉन्ट, साफ समय आ पढ़े में सुगम',
          'no_title': 'ना, सामान्य आकार ठीक बा',
          'no_sub': 'मानक फॉन्ट आ साधारण दृश्य',
          'preview_label': 'अक्षर के नमूना (Live Preview):',
          'sample_panchang': 'क्वार सुदी पड़वा • सूर्योदय: ०६:२८ • शुभ चौघड़िया',
          'btn_continue': 'आगे बढ़ीं',
        };
      case 'en':
        return {
          'question': 'Would you like larger, easy-to-read text (Senior / Elder Mode)?',
          'desc': 'Enlarges fonts and provides higher contrast for comfortable reading by family elders.',
          'yes_title': 'Yes, use Large Text (Senior Mode)',
          'yes_sub': 'Bigger fonts, clear auspicious timings, easier to read',
          'no_title': 'No, standard view is fine',
          'no_sub': 'Standard layout and font sizing',
          'preview_label': 'Text size preview (Live Preview):',
          'sample_panchang': 'Ashwin Shukla Pratipada • Sunrise: 06:28 AM • Shubh Choghadiya',
          'btn_continue': 'Continue',
        };
      case 'hi':
      default:
        return {
          'question': 'क्या आप पढ़ने के लिए बड़े अक्षर और सरल दृश्य (वरिष्ठ जन मोड) चाहते हैं?',
          'desc': 'यह बुजुर्गों और परिवार के सदस्यों के लिए फॉन्ट को बड़ा और पढ़ने में बहुत आसान बना देता है।',
          'yes_title': 'हाँ, बड़े अक्षर रखें (वरिष्ठ जन मोड)',
          'yes_sub': 'बड़ा फॉन्ट, स्पष्ट समय और पढ़ने में सुगम',
          'no_title': 'नहीं, सामान्य दृश्य ठीक है',
          'no_sub': 'मानक फॉन्ट और सामान्य दृश्य',
          'preview_label': 'अक्षरों का नमूना (Live Preview):',
          'sample_panchang': 'आश्विन शुक्ल प्रतिपदा • सूर्योदय: ०६:२८ • शुभ चौघड़िया',
          'btn_continue': 'आगे बढ़ें',
        };
    }
  }

  String _getTourHeader(String lang) {
    switch (lang) {
      case 'gu':
        return 'એપ પરિચય (Tour)';
      case 'mr':
        return 'अ‍ॅप परिचय (Tour)';
      case 'bho':
        return 'ऐप परिचय (Tour)';
      case 'en':
        return 'App Walkthrough';
      default:
        return 'ऐप का परिचय (Tour)';
    }
  }

  String _getTourSubHeader(String lang) {
    switch (lang) {
      case 'gu':
        return 'આ પંચાંગની મુખ્ય ૪ વિશેષતાઓ જાણી લો';
      case 'mr':
        return 'या पंचांगची ४ मुख्य वैशिष्ट्ये समजून घ्या';
      case 'bho':
        return 'एह पंचांग के मुख्य ४ गो सुविधा जान लीं';
      case 'en':
        return 'Discover the 4 core sections of your Panchang';
      default:
        return 'इस पंचांग की मुख्य ४ सुविधाओं को समझें';
    }
  }

  List<Map<String, String>> _getTourData(String lang) {
    switch (lang) {
      case 'gu':
        return [
          {
            'icon': '☀️',
            'title': '૧. આજનું પંચાંગ (Today)',
            'desc': 'અહીં તમને આજના દિવસની તિથિ, નક્ષત્ર, સૂર્યોદય, સૂર્યાસ્ત, રાહુ કાળ અને શુભ ચોઘડિયાનો સમય જોવા મળશે.',
            'speech': 'અહીં તમને આજના દિવસની તિથિ, સૂર્યોદય, સૂર્યાસ્ત અને શુભ ચોઘડિયાનો સમય જોવા મળશે.',
          },
          {
            'icon': '📅',
            'title': '૨. કેલેન્ડર (Calendar)',
            'desc': 'અહીં તમે આખા મહિનાનું પંચાંગ, એકાદશી, પૂનમ, અમાસ અને બધા હિન્દુ તહેવારોની સચોટ યાદી જોઈ શકો છો.',
            'speech': 'અહીં તમે આખા મહિનાનું પંચાંગ અને એકાદશી-તહેવારોની યાદી જોઈ શકો છો.',
          },
          {
            'icon': '✨',
            'title': '૩. શુભ મુહૂર્ત (Muhurat)',
            'desc': 'ગૃહ પ્રવેશ, લગ્ન, વાહન ખરીદી અને મિલકત ખરીદવાના શુભ મુહૂર્ત અને ચોઘડિયા સમય અહીં શોધો.',
            'speech': 'ગૃહ પ્રવેશ, લગ્ન અને વાહન ખરીદીના શુભ મુહૂર્ત અહીં શોધો.',
          },
          {
            'icon': '🎙️',
            'title': '૪. પૂછો સહાયક (Ask)',
            'desc': 'અહીં તમે બોલીને કે લખીને પંચાંગને લગતો કોઈપણ પ્રશ્ન પૂછી શકો છો અને તુરંત સચોટ ઉત્તર મેળવો.',
            'speech': 'અહીં તમે બોલીને કે લખીને પંચાંગ વિશે કોઈપણ પ્રશ્ન પૂછી શકો છો.',
          },
        ];
      case 'mr':
        return [
          {
            'icon': '☀️',
            'title': '१. आजचे पंचांग (Today)',
            'desc': 'येथे तुम्हाला आजची तिथी, नक्षत्र, सूर्योदय, सूर्यास्त, राहू काळ आणि शुभ चौघडिया वेळ दिसेल.',
            'speech': 'येथे तुम्हाला आजची तिथी, सूर्योदय, सूर्यास्त आणि शुभ चौघडिया वेळ दिसेल.',
          },
          {
            'icon': '📅',
            'title': '२. कॅलेंडर (Calendar)',
            'desc': 'येथे तुम्ही संपूर्ण महिन्याचे पंचांग, एकादशी, पौर्णिमा, अमावस्या आणि सणांची यादी पाहू शकता.',
            'speech': 'येथे तुम्ही संपूर्ण महिन्याचे पंचांग आणि एकादशी-सणांची यादी पाहू शकता.',
          },
          {
            'icon': '✨',
            'title': '३. शुभ मुहूर्त (Muhurat)',
            'desc': 'गृह प्रवेश, विवाह, वाहन खरेदी आणि मालमत्ता खरेदीचे शुभ मुहूर्त येथे शोधा.',
            'speech': 'गृह प्रवेश, विवाह आणि वाहन खरेदीचे शुभ मुहूर्त येथे शोधा.',
          },
          {
            'icon': '🎙️',
            'title': '४. विचारा (Ask)',
            'desc': 'येथे तुम्ही बोलून किंवा लिहून पंचांगाशी संबंधित कोणताही प्रश्न विचारू शकता.',
            'speech': 'येथे तुम्ही बोलून किंवा लिहून पंचांगाशी संबंधित प्रश्न विचारू शकता.',
          },
        ];
      case 'bho':
        return [
          {
            'icon': '☀️',
            'title': '१. आजु के पंचांग (Today)',
            'desc': 'इहाँ रउआ आजु के तिथि, नक्षत्र, सूर्योदय, सूर्यास्त, राहु काल आ शुभ चौघड़िया समय देखब।',
            'speech': 'इहाँ रउआ आजु के तिथि, सूर्योदय, सूर्यास्त आ शुभ चौघड़िया समय देखब।',
          },
          {
            'icon': '📅',
            'title': '२. कैलेंडर (Calendar)',
            'desc': 'इहाँ पूरा महीना के पंचांग, एकादशी, पूरनमासी, अमवस्या आ सगरी तिहुआर के लिस्ट मिल जाई।',
            'speech': 'इहाँ पूरा महीना के पंचांग आ एकादशी तिहुआर के लिस्ट देख सकत बानी।',
          },
          {
            'icon': '✨',
            'title': '३. शुभ मुहूर्त (Muhurat)',
            'desc': 'गृह प्रवेश, बियाह, गाड़ी कीने आ जमीन-मकान कीने के शुभ लगन-मुहूर्त इहाँ खोजीं।',
            'speech': 'गृह प्रवेश, बियाह आ गाड़ी कीने के शुभ मुहूर्त इहाँ खोजीं।',
          },
          {
            'icon': '🎙️',
            'title': '४. पूछल जाय (Ask)',
            'desc': 'इहाँ रउआ मुँह से बोल के भा लिख के पंचांग से कवनो सवाल पूछ सकत बानी।',
            'speech': 'इहाँ रउआ मुँह से बोल के भा लिख के पंचांग से कवनो सवाल पूछ सकत बानी।',
          },
        ];
      case 'en':
        return [
          {
            'icon': '☀️',
            'title': '1. Today\'s Panchang',
            'desc': 'View daily Tithi, Nakshatra, Sunrise, Sunset, Rahu Kaal, and live Choghadiya windows.',
            'speech': 'Here you can view today\'s Tithi, Sunrise, Sunset, and auspicious Choghadiya timings.',
          },
          {
            'icon': '📅',
            'title': '2. Monthly Calendar',
            'desc': 'Explore full month calendar views, Ekadashi, Purnima, Amavasya, and authentic festival dates.',
            'speech': 'Explore the full month calendar with Ekadashi, Purnima, and Hindu festivals.',
          },
          {
            'icon': '✨',
            'title': '3. Auspicious Muhurat',
            'desc': 'Find personalized windows for Griha Pravesh, Marriage, Vehicle Purchase, and property registrations.',
            'speech': 'Find auspicious Muhurat timings for house warming, marriage, and vehicle purchase.',
          },
          {
            'icon': '🎙️',
            'title': '4. Voice Assistant',
            'desc': 'Ask questions in your mother tongue using speech or text, and get instant verified answers.',
            'speech': 'Ask any question to the Panchang using voice or typing and receive instant answers.',
          },
        ];
      case 'hi':
      default:
        return [
          {
            'icon': '☀️',
            'title': '१. आज का पंचांग (Today)',
            'desc': 'यहाँ आपको आज की तिथि, नक्षत्र, सूर्योदय, सूर्यास्त, राहु काल और शुभ चौघड़िया समय दिखेगा।',
            'speech': 'यहाँ आपको आज की तिथि, सूर्योदय, सूर्यास्त और शुभ चौघड़िया समय दिखेगा।',
          },
          {
            'icon': '📅',
            'title': '२. मासिक कैलेंडर (Calendar)',
            'desc': 'यहाँ आप पूरे महीने का पंचांग, एकादशी, पूर्णिमा, अमावस्या और सभी हिंदू त्योहारों की सूची देख सकते हैं।',
            'speech': 'यहाँ आप पूरे महीने का पंचांग और एकादशी-त्योहारों की सूची देख सकते हैं।',
          },
          {
            'icon': '✨',
            'title': '३. शुभ मुहूर्त (Muhurat)',
            'desc': 'गृह प्रवेश, विवाह, वाहन खरीद और संपत्ति के शुभ मुहूर्त और चौघड़िया समय यहाँ खोजें।',
            'speech': 'गृह प्रवेश, विवाह और वाहन खरीद के शुभ मुहूर्त यहाँ खोजें।',
          },
          {
            'icon': '🎙️',
            'title': '४. बोलकर पूछें (Ask)',
            'desc': 'यहाँ आप बोलकर या लिखकर पंचांग से कोई भी सवाल पूछ सकते हैं और तुरंत सही उत्तर पा सकते हैं।',
            'speech': 'यहाँ आप बोलकर या लिखकर पंचांग से कोई भी सवाल पूछ सकते हैं।',
          },
        ];
    }
  }

  /*
  // -------------------------------------------------------------
  // STEP 4: Sign In / Account Setup (Preserved - ready for Firebase)
  // -------------------------------------------------------------
  Future<void> _handleSignIn(Future<UserProfile> Function() authAction) async {
    setState(() => _isSigningIn = true);
    try {
      final profile = await authAction();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              profile.isAdmin
                  ? '👑 स्वागत है व्यवस्थापक (Admin)! व्यवस्थापक नियंत्रण अनलॉक हो गया।'
                  : '✅ स्वागत है ${profile.name}! आपका खाता सफलतापूर्वक जुड़ गया।',
            ),
            backgroundColor: profile.isAdmin ? AppTheme.maroonSecondary : AppTheme.suitableGreen,
            duration: const Duration(seconds: 4),
          ),
        );
        _finish();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('साइन इन त्रुटि: $e'),
            backgroundColor: AppTheme.notSuitableRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  Widget _buildSignInStep() {
    final location = LocationService.currentLocation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goToStep(2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.saffronPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✨ ', style: TextStyle(fontSize: 12)),
                    Text(
                      'हरे कृष्ण!',
                      style: TextStyle(
                        color: AppTheme.saffronPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            'साइन इन / खाता बनाएं\nSign In / Register',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'अपने दैनिक पंचांग, शुभ मुहूर्त और सूचनाएं सुरक्षित रखने के लिए खाता जोड़ें।',
            style: TextStyle(fontSize: 13, color: AppTheme.subtleText),
          ),
          const SizedBox(height: 20),

          // Auto-detected location badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBE1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.saffronPrimary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'स्वतः पहचाना गया स्थान (Auto-detected)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.subtleText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${location.name}, ${location.state} (${location.country})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: AppTheme.suitableGreen, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Optional Phone Number Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.phone, color: AppTheme.saffronPrimary, size: 20),
                labelText: 'मोबाइल नंबर (वैकल्पिक / Optional)',
                labelStyle: TextStyle(fontSize: 13, color: AppTheme.subtleText),
                hintText: '+91 98765 43210',
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Google Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1F1F1F),
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFDADCE0)),
                ),
              ),
              onPressed: _isSigningIn
                  ? null
                  : () => _handleSignIn(
                        () => AuthService.signInWithGoogle(
                          phoneNumber: _phoneCtrl.text.trim().length > 5
                              ? _phoneCtrl.text.trim()
                              : null,
                        ),
                      ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4285F4),
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Google से आगे बढ़ें (Continue with Google)',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Apple Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _isSigningIn
                  ? null
                  : () => _handleSignIn(
                        () => AuthService.signInWithApple(
                          phoneNumber: _phoneCtrl.text.trim().length > 5
                              ? _phoneCtrl.text.trim()
                              : null,
                        ),
                      ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple, color: Colors.white, size: 22),
                  SizedBox(width: 12),
                  Text(
                    'Apple ID से जारी रखें (Sign in with Apple)',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stay logged in trust note
          const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 14, color: AppTheme.subtleText),
                SizedBox(width: 6),
                Text(
                  'आप हमेशा लॉग इन रहेंगे • सुरक्षित और स्वचालित',
                  style: TextStyle(fontSize: 12, color: AppTheme.subtleText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Skip to Guest option
          Center(
            child: TextButton(
              onPressed: _isSigningIn ? null : _finish,
              child: const Text(
                'अतिथि के रूप में जारी रखें • बाद में करें (Skip & Get Started)',
                style: TextStyle(
                  color: AppTheme.saffronPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  */
}
