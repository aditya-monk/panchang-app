import '../core/constants/panchang_constants.dart';

/// Multilingual localization repository supporting English, Hindi, Gujarati, Marathi, and Bhojpuri.
/// Bhojpuri is implemented as an independent linguistic layer per Section 42.
class AppLocalizations {
  static const List<String> supportedLanguages = ['en', 'hi', 'gu', 'mr', 'bho'];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'gu': 'ગુજરાતી',
    'mr': 'मराठी',
    'bho': 'भोजपुरी',
  };

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Panchang',
      'tab_today': 'Today',
      'tab_calendar': 'Calendar',
      'tab_muhurat': 'Muhurat',
      'tab_ask': 'Ask',
      'astronomical_sunrise': 'Astronomical Sunrise',
      'astronomical_sunset': 'Astronomical Sunset',
      'moonrise': 'Moonrise',
      'moonset': 'Moonset',
      'rahu_kaal': 'Rahu Kaal',
      'yamaganda': 'Yamaganda',
      'gulika': 'Gulika',
      'abhijit_muhurat': 'Abhijit Muhurat',
      'brahma_muhurat': 'Brahma Muhurat',
      'next_ekadashi': 'Next Ekadashi',
      'view_full_panchang': 'View Full Panchang',
      'ask_panchang': 'Ask Panchang',
      'calculated_for': 'Calculated for',
      'event_location': 'Event location',
      'explore_calendar': 'Explore Calendar',
      'find_muhurat': 'Find Muhurat',
      'what_planning': 'What are you planning?',
      'when_need_muhurat': 'When do you need a Muhurat?',
      'popular_occasions': 'Popular Occasions',
      'custom_search': 'Custom Search',
      'why_this_window': 'Why this window?',
      'suitable': 'Suitable',
      'conditional': 'Conditional',
      'not_suitable': 'Not Suitable',
      'share': 'Share',
      'add_reminder': 'Add Reminder',
      'elder_mode': 'Elder / Large Text Mode',
      'read_panchang_aloud': 'Read Today\'s Panchang Aloud',
      'compare_calendars': 'Compare Calendars',
      'standard_panchang': 'Standard Hindu Panchang',
      'vaishnava_profile': 'Vaishnava / ISKCON Profile',
      'gita_press_profile': 'Gita Press Reference',
      'parana': 'Parana',
      'fasting': 'Fasting',
      'day_timeline': 'Day Timeline',
      'now_active': 'Currently Active',
      'year_view': 'Year View',
      'month_view': 'Month View',
      'day_view': 'Day View',
      'select_location': 'Select Location',
      'search_city': 'Search city or region...',
      'legend': 'Legend',
      'legend_ekadashi': 'Ekadashi',
      'legend_purnima': 'Purnima',
      'legend_amavasya': 'Amavasya',
      'legend_festival': 'Festival / Occasion',
      'legend_muhurat': 'Auspicious Muhurat',
      'show_muhurat_overlay': 'Show Muhurat Overlay',
      'today_btn': 'Today',
      'vikram_samvat': 'Vikram Samvat',
      'listening': 'Listening... Speak now',
      'ask_or_type': 'Ask or type here...',
      'quick_questions': 'Quick Questions',
      'speech_not_supported': 'Speech recognition not supported in browser',
      'change_city': 'Change City',
      'all_festivals': 'Festivals & Vrat',
      'settings': 'Settings & Preferences',
      'important_times': 'IMPORTANT TIMES',
      'nakshatra_label': 'Nakshatra',
      'yoga_label': 'Yoga',
      'karana_label': 'Karana',
      'vara_label': 'Weekday',
      'live_badge': 'LIVE',
      'rahu_kaal_active': 'Rahu Kaal is currently active',
      'abhijit_active': 'Abhijit Muhurat is currently active',
      'choghadiya_active': 'Choghadiya is active',
      'avoid_auspicious': '(Avoid auspicious works)',
      'auspicious_midday': '(Auspicious midday)',
      'early_morning': '(Early morning)',
      'standard': 'Standard',
      'vaishnava': 'Vaishnava',
      'gita_press': 'Gita Press',
      'purnima': 'Purnima',
      'amavasya': 'Amavasya',
      'muhurat': 'Muhurat',
      'ekadashis': 'Ekadashis',
      'purnimas': 'Purnimas',
      'amavasyas': 'Amavasyas',
      'sankrantis': 'Sankrantis',
      'parana_label': 'Parana',
      'accessibility_display': 'Accessibility & Display',
      'elder_mode_desc': 'Increases text size by 25%, enlarges touch targets, and enhances contrast.',
      'panchang_tradition': 'Panchang Tradition',
      'calendar_tradition': 'Calendar Tradition',
      'regional_profile': 'Regional Profile',
      'languages': 'Languages',
      'app_ui_language': 'App UI Language',
      'voice_assistant_language': 'Voice Assistant Language',
      'location_management': 'Location Management',
      'current_location': 'Current Location',
      'event_location_muhurat': 'Event Location (For Muhurat)',
      'notifications_reminders': 'Notifications & Reminders',
      'daily_panchang_sunrise': 'Daily Panchang at Sunrise',
      'ekadashi_reminders': 'Ekadashi Reminders',
      'ekadashi_parana_window': 'Ekadashi Parana Window',
      'major_festivals_vrat': 'Major Festivals & Vrat',
      'astronomy_transparency': 'Astronomy Engine & Transparency',
      'select_tradition': 'Select Calendar Tradition',
      'select_region': 'Select Regional Profile',
      'select_ui_lang': 'Select App UI Language',
      'select_voice_lang': 'Select Voice Language',
      'detailed_view': 'Detailed',
      'simple_view': 'Simple',
      'panchang_elements': 'Panchang Elements (पञ्चाङ्ग)',
      'astronomical_timings': 'Astronomical Timings',
      'auspicious_inauspicious': 'Auspicious & Inauspicious Periods',
      'day_choghadiya': 'Day Choghadiya',
      'auspicious': 'Auspicious',
      'inauspicious': 'Inauspicious',
      'ends_at': 'Ends',
      'next_label': 'Next',
      'solar_noon': 'Solar Noon',
      'close': 'Close',
      'calculation_breakdown': 'Calculation Breakdown',
      'fasting_rule_label': 'Fasting Rule',
      'tithi_label': 'Tithi',
      'observances_label': 'Observances',
    },
    'hi': {
      'app_title': 'पंचांग',
      'tab_today': 'आज',
      'tab_calendar': 'कैलेंडर',
      'tab_muhurat': 'मुहूर्त',
      'tab_ask': 'पूछें',
      'astronomical_sunrise': 'खगोलीय सूर्योदय',
      'astronomical_sunset': 'खगोलीय सूर्यास्त',
      'moonrise': 'चंद्रोदय',
      'moonset': 'चंद्रास्त',
      'rahu_kaal': 'राहु काल',
      'yamaganda': 'यमगण्ड',
      'gulika': 'गुलिक काल',
      'abhijit_muhurat': 'अभिजित मुहूर्त',
      'brahma_muhurat': 'ब्रह्म मुहूर्त',
      'next_ekadashi': 'अगली एकादशी',
      'view_full_panchang': 'संपूर्ण पंचांग देखें',
      'ask_panchang': 'पंचांग से पूछें',
      'calculated_for': 'गणना स्थान',
      'event_location': 'आयोजन स्थान',
      'explore_calendar': 'कैलेंडर देखें',
      'find_muhurat': 'मुहूर्त खोजें',
      'what_planning': 'आप क्या योजना बना रहे हैं?',
      'when_need_muhurat': 'आपको कब मुहूर्त चाहिए?',
      'popular_occasions': 'प्रमुख आयोजन',
      'custom_search': 'विस्तृत खोज',
      'why_this_window': 'यह मुहूर्त क्यों उपयुक्त है?',
      'suitable': 'उपयुक्त',
      'conditional': 'सशर्त',
      'not_suitable': 'अनुपयुक्त',
      'share': 'साझा करें',
      'add_reminder': 'स्मरण जोड़ें',
      'elder_mode': 'वरिष्ठ जन (बड़े अक्षर)',
      'read_panchang_aloud': 'आज का पंचांग पढ़कर सुनाओ',
      'compare_calendars': 'कैलेंडर परंपरा तुलना',
      'standard_panchang': 'मानक हिन्दू पंचांग',
      'vaishnava_profile': 'वैष्णव / इस्कॉन परंपरा',
      'gita_press_profile': 'गीताप्रेस संदर्भ',
      'parana': 'पारणा',
      'fasting': 'व्रत / उपवास',
      'day_timeline': 'दिन की समय-रेखा',
      'now_active': 'वर्तमान में सक्रिय',
      'year_view': 'वार्षिक दृश्य',
      'month_view': 'मासिक दृश्य',
      'day_view': 'दैनिक दृश्य',
      'select_location': 'स्थान चुनें',
      'search_city': 'शहर खोजें...',
      'legend': 'संकेत सूची',
      'legend_ekadashi': 'एकादशी',
      'legend_purnima': 'पूर्णिमा',
      'legend_amavasya': 'अमावस्या',
      'legend_festival': 'त्योहार / पर्व',
      'legend_muhurat': 'शुभ मुहूर्त',
      'show_muhurat_overlay': 'मुहूर्त दर्शाएं',
      'today_btn': 'आज',
      'vikram_samvat': 'विक्रम संवत्',
      'listening': 'सुन रहा हूँ... बोलिए',
      'ask_or_type': 'यहाँ पूछें या टाइप करें...',
      'quick_questions': 'त्वरित प्रश्न',
      'speech_not_supported': 'ब्राउज़र में ध्वनि पहचान समर्थित नहीं है',
      'change_city': 'शहर बदलें',
      'all_festivals': 'त्योहार एवं व्रत',
      'settings': 'सेटिंग्स व प्राथमिकताएं',
      'important_times': 'महत्वपूर्ण समय',
      'nakshatra_label': 'नक्षत्र',
      'yoga_label': 'योग',
      'karana_label': 'करण',
      'vara_label': 'वार',
      'live_badge': 'सक्रिय',
      'rahu_kaal_active': 'राहु काल चल रहा है',
      'abhijit_active': 'अभिजित मुहूर्त चल रहा है',
      'choghadiya_active': 'चौघड़िया चल रहा है',
      'avoid_auspicious': '(शुभ कार्य वर्जित)',
      'auspicious_midday': '(शुभ मध्याह्न काल)',
      'early_morning': '(प्रातः ब्रह्म मुहूर्त)',
      'standard': 'मानक',
      'vaishnava': 'वैष्णव',
      'gita_press': 'गीताप्रेस',
      'purnima': 'पूर्णिमा',
      'amavasya': 'अमावस्या',
      'muhurat': 'मुहूर्त',
      'ekadashis': 'एकादशी',
      'purnimas': 'पूर्णिमा',
      'amavasyas': 'अमावस्या',
      'sankrantis': 'संक्रांति',
      'parana_label': 'पारणा',
      'accessibility_display': 'सुगमता एवं प्रदर्शन',
      'elder_mode_desc': 'अक्षर 25% बड़े, बड़े स्पर्श बटन और अधिक स्पष्टता।',
      'panchang_tradition': 'पंचांग परंपरा',
      'calendar_tradition': 'कैलेंडर परंपरा',
      'regional_profile': 'क्षेत्रीय स्वरूप',
      'languages': 'भाषाएं',
      'app_ui_language': 'ऐप भाषा',
      'voice_assistant_language': 'आवाज़ सहायक भाषा',
      'location_management': 'स्थान प्रबंधन',
      'current_location': 'वर्तमान स्थान',
      'event_location_muhurat': 'आयोजन स्थान (मुहूर्त हेतु)',
      'notifications_reminders': 'सूचना एवं स्मरण',
      'daily_panchang_sunrise': 'सूर्योदय पर दैनिक पंचांग',
      'ekadashi_reminders': 'एकादशी स्मरण',
      'ekadashi_parana_window': 'एकादशी पारणा समय',
      'major_festivals_vrat': 'प्रमुख त्योहार एवं व्रत',
      'astronomy_transparency': 'खगोलीय गणना व पारदर्शिता',
      'select_tradition': 'पंचांग परंपरा चुनें',
      'select_region': 'क्षेत्रीय स्वरूप चुनें',
      'select_ui_lang': 'ऐप भाषा चुनें',
      'select_voice_lang': 'आवाज़ भाषा चुनें',
      'detailed_view': 'विस्तृत',
      'simple_view': 'सरल',
      'panchang_elements': 'पञ्चाङ्ग के पाँच अंग',
      'astronomical_timings': 'खगोलीय समय',
      'auspicious_inauspicious': 'शुभ एवं अशुभ समय',
      'day_choghadiya': 'दिन का चौघड़िया',
      'auspicious': 'शुभ',
      'inauspicious': 'अशुभ',
      'ends_at': 'समाप्ति',
      'next_label': 'अगला',
      'solar_noon': 'मध्याह्न काल',
      'close': 'बंद करें',
      'calculation_breakdown': 'गणना विवरण',
      'fasting_rule_label': 'व्रत नियम',
      'tithi_label': 'तिथि',
      'observances_label': 'व्रत एवं पर्व',
    },
    'gu': {
      'app_title': 'પંચાંગ',
      'tab_today': 'આજે',
      'tab_calendar': 'કેલેન્ડર',
      'tab_muhurat': 'મુહૂર્ત',
      'tab_ask': 'પૂછો',
      'astronomical_sunrise': 'ખગોળીય સૂર્યોદય',
      'astronomical_sunset': 'ખગોળીય સૂર્યાસ્ત',
      'moonrise': 'ચંદ્રોદય',
      'moonset': 'ચંદ્રાસ્ત',
      'rahu_kaal': 'રાહુ કાળ',
      'yamaganda': 'યમગંડ',
      'gulika': 'ગુલિક કાળ',
      'abhijit_muhurat': 'અભિજિત મુહૂર્ત',
      'brahma_muhurat': 'બ્રહ્મ મુહૂર્ત',
      'next_ekadashi': 'આગામી એકાદશી',
      'view_full_panchang': 'સંપૂર્ણ પંચાંગ જુઓ',
      'ask_panchang': 'પંચાંગ પૂછો',
      'calculated_for': 'ગણતરી સ્થળ',
      'event_location': 'પ્રસંગ સ્થળ',
      'explore_calendar': 'કેલેન્ડર જુઓ',
      'find_muhurat': 'મુહૂર્ત શોધો',
      'what_planning': 'તમે શું આયોજન કરી રહ્યા છો?',
      'when_need_muhurat': 'તમારે ક્યારે મુહૂર્ત જોઈએ છે?',
      'popular_occasions': 'લોકપ્રિય પ્રસંગો',
      'custom_search': 'કસ્ટમ શોધ',
      'why_this_window': 'આ મુહૂર્ત શા માટે?',
      'suitable': 'યોગ્ય',
      'conditional': 'શરતી',
      'not_suitable': 'અયોગ્ય',
      'share': 'શેર કરો',
      'add_reminder': 'યાદ અપાવો',
      'elder_mode': 'મોટા અક્ષર મોડ',
      'read_panchang_aloud': 'આજનું પંચાંગ બોલીને સંભળાવો',
      'compare_calendars': 'પરંપરા તુલના',
      'standard_panchang': 'પ્રમાણિત હિન્દુ પંચાંગ',
      'vaishnava_profile': 'વૈષ્ણવ / ઇસ્કોન પરંપરા',
      'gita_press_profile': 'ગીતાપ્રેસ સંદર્ભ',
      'parana': 'પારણા',
      'fasting': 'ઉપવાસ',
      'day_timeline': 'દિવસની સમયરેખા',
      'now_active': 'હાલમાં ચાલુ',
      'year_view': 'વાર્ષિક દર્શન',
      'month_view': 'માસિક દર્શન',
      'day_view': 'દૈનિક દર્શન',
      'select_location': 'સ્થળ પસંદ કરો',
      'search_city': 'શહેર શોધો...',
      'legend': 'સંકેત સૂચિ',
      'legend_ekadashi': 'એકાદશી',
      'legend_purnima': 'પૂનમ',
      'legend_amavasya': 'અમાસ',
      'legend_festival': 'તહેવાર / પર્વ',
      'legend_muhurat': 'શુભ મુહૂર્ત',
      'show_muhurat_overlay': 'મુહૂર્ત દર્શાવો',
      'today_btn': 'આજે',
      'vikram_samvat': 'વિક્રમ સંવત',
      'listening': 'સાંભળી રહ્યા છીએ... બોલો',
      'ask_or_type': 'અહીં પૂછો કે ટાઈપ કરો...',
      'quick_questions': 'ઝડપી પ્રશ્નો',
      'speech_not_supported': 'બ્રાઉઝરમાં અવાજ સુવિધા ઉપલબ્ધ નથી',
      'change_city': 'શહેર બદલો',
      'all_festivals': 'તહેવારો અને વ્રત',
      'settings': 'સેટિંગ્સ અને પસંદગીઓ',
      'important_times': 'મહત્વપૂર્ણ સમય',
      'nakshatra_label': 'નક્ષત્ર',
      'yoga_label': 'યોગ',
      'karana_label': 'કરણ',
      'vara_label': 'વાર',
      'live_badge': 'લાઈવ',
      'rahu_kaal_active': 'રાહુ કાળ ચાલુ છે',
      'abhijit_active': 'અભિજિત મુહૂર્ત ચાલુ છે',
      'choghadiya_active': 'ચોઘડિયું ચાલુ છે',
      'avoid_auspicious': '(શુભ કાર્ય વર્જ્ય)',
      'auspicious_midday': '(શુભ બપોર કાળ)',
      'early_morning': '(વહેલી સવાર બ્રહ્મ મુહૂર્ત)',
      'standard': 'પ્રમાણિત',
      'vaishnava': 'વૈષ્ણવ',
      'gita_press': 'ગીતાપ્રેસ',
      'purnima': 'પૂનમ',
      'amavasya': 'અમાસ',
      'muhurat': 'મુહૂર્ત',
      'ekadashis': 'એકાદશી',
      'purnimas': 'પૂનમ',
      'amavasyas': 'અમાસ',
      'sankrantis': 'સંક્રાંતિ',
      'parana_label': 'પારણા',
      'accessibility_display': 'સુગમતા અને ડિસ્પ્લે',
      'elder_mode_desc': 'અક્ષરો ૨૫% મોટા, મોટા બટન અને વધારે સ્પષ્ટતા.',
      'panchang_tradition': 'પંચાંગ પરંપરા',
      'calendar_tradition': 'કેલેન્ડર પરંપરા',
      'regional_profile': 'પ્રાદેશિક પ્રોફાઇલ',
      'languages': 'ભાષાઓ',
      'app_ui_language': 'એપ ભાષા',
      'voice_assistant_language': 'અવાજ સહાયક ભાષા',
      'location_management': 'સ્થળ વ્યવસ્થાપન',
      'current_location': 'વર્તમાન સ્થળ',
      'event_location_muhurat': 'પ્રસંગ સ્થળ (મુહૂર્ત માટે)',
      'notifications_reminders': 'સૂચના અને રિમાઇન્ડર',
      'daily_panchang_sunrise': 'સૂર્યોદયે દૈનિક પંચાંગ',
      'ekadashi_reminders': 'એકાદશી સ્મરણ',
      'ekadashi_parana_window': 'એકાદશી પારણા સમય',
      'major_festivals_vrat': 'મુખ્ય તહેવારો અને વ્રત',
      'astronomy_transparency': 'ખગોળીય ગણતરી અને પારદર્શિતા',
      'select_tradition': 'પંચાંગ પરંપરા પસંદ કરો',
      'select_region': 'પ્રાદેશિક પ્રોફાઇલ પસંદ કરો',
      'select_ui_lang': 'એપ ભાષા પસંદ કરો',
      'select_voice_lang': 'અવાજ ભાષા પસંદ કરો',
      'detailed_view': 'વિગતવાર',
      'simple_view': 'સરળ',
      'panchang_elements': 'પંચાંગના પાંચ અંગ',
      'astronomical_timings': 'ખગોળીય સમય',
      'auspicious_inauspicious': 'શુભ અને અશુભ સમય',
      'day_choghadiya': 'દિવસનું ચોઘડિયું',
      'auspicious': 'શુભ',
      'inauspicious': 'અશુભ',
      'ends_at': 'સમાપ્તિ',
      'next_label': 'આગામી',
      'solar_noon': 'મધ્યાહ્ન સમય',
      'close': 'બંધ કરો',
      'calculation_breakdown': 'ગણતરી વિગતો',
      'fasting_rule_label': 'વ્રત નિયમ',
      'tithi_label': 'તિથિ',
      'observances_label': 'તહેવારો અને વ્રત',
    },
    'mr': {
      'app_title': 'पंचांग',
      'tab_today': 'आज',
      'tab_calendar': 'दिनदर्शिका',
      'tab_muhurat': 'मुहूर्त',
      'tab_ask': 'विचारा',
      'astronomical_sunrise': 'खगोलीय सूर्योदय',
      'astronomical_sunset': 'खगोलीय सूर्यास्त',
      'moonrise': 'चंद्रोदय',
      'moonset': 'चंद्रास्त',
      'rahu_kaal': 'राहु काळ',
      'yamaganda': 'यमगंड',
      'gulika': 'गुलिक काळ',
      'abhijit_muhurat': 'अभिजित मुहूर्त',
      'brahma_muhurat': 'ब्राह्म मुहूर्त',
      'next_ekadashi': 'पुढील एकादशी',
      'view_full_panchang': 'संपूर्ण पंचांग पहा',
      'ask_panchang': 'पंचांग विचारा',
      'calculated_for': 'गणना स्थान',
      'event_location': 'कार्यक्रमाचे ठिकाण',
      'explore_calendar': 'कॅलेंडर पहा',
      'find_muhurat': 'मुहूर्त शोधा',
      'what_planning': 'आपण कशाचे नियोजन करत आहात?',
      'when_need_muhurat': 'आपणास मुहूर्त कधी हवा आहे?',
      'popular_occasions': 'प्रमुख प्रसंग',
      'custom_search': 'तपशीलवार शोध',
      'why_this_window': 'हा मुहूर्त का योग्य आहे?',
      'suitable': 'योग्य',
      'conditional': 'सशर्त',
      'not_suitable': 'अयोग्य',
      'share': 'शेअर करा',
      'add_reminder': 'स्मरणपत्र जोडा',
      'elder_mode': 'मोठा मजकूर मोड',
      'read_panchang_aloud': 'आजचे पंचांग वाचून दाखवा',
      'compare_calendars': 'परंपरा तुलना',
      'standard_panchang': 'प्रमाणित हिंदू पंचांग',
      'vaishnava_profile': 'वैष्णव / इस्कॉन परंपरा',
      'gita_press_profile': 'गीताप्रेस संदर्भ',
      'parana': 'पारणा',
      'fasting': 'उपवास',
      'day_timeline': 'दिवसाची वेळ-रेषा',
      'now_active': 'सध्या सुरू',
      'year_view': 'वार्षिक दृश्य',
      'month_view': 'मासिक दृश्य',
      'day_view': 'दैनिक दृश्य',
      'select_location': 'स्थान निवडा',
      'search_city': 'शहर शोधा...',
      'legend': 'संकेत सूची',
      'legend_ekadashi': 'एकादशी',
      'legend_purnima': 'पौर्णिमा',
      'legend_amavasya': 'अमावास्या',
      'legend_festival': 'सण / उत्सव',
      'legend_muhurat': 'शुभ मुहूर्त',
      'show_muhurat_overlay': 'मुहूर्त दर्शवा',
      'today_btn': 'आज',
      'vikram_samvat': 'विक्रम संवत',
      'listening': 'ऐकत आहे... बोला',
      'ask_or_type': 'येथे विचारा किंवा टाईप करा...',
      'quick_questions': 'जलद प्रश्न',
      'speech_not_supported': 'ब्राउझरमध्ये ध्वनी ओळख समर्थित नाही',
      'change_city': 'शहर बदला',
      'all_festivals': 'सण आणि व्रते',
      'settings': 'सेटिंग्ज आणि प्राधान्ये',
      'important_times': 'महत्त्वाच्या वेळा',
      'nakshatra_label': 'नक्षत्र',
      'yoga_label': 'योग',
      'karana_label': 'करण',
      'vara_label': 'वार',
      'live_badge': 'सुरू',
      'rahu_kaal_active': 'राहु काळ सुरू आहे',
      'abhijit_active': 'अभिजित मुहूर्त सुरू आहे',
      'choghadiya_active': 'चौघडिया सुरू आहे',
      'avoid_auspicious': '(शुभ कार्ये वर्ज्य)',
      'auspicious_midday': '(शुभ दुपारची वेळ)',
      'early_morning': '(पहाटेची ब्राह्म वेळ)',
      'standard': 'प्रमाणित',
      'vaishnava': 'वैष्णव',
      'gita_press': 'गीताप्रेस',
      'purnima': 'पौर्णिमा',
      'amavasya': 'अमावास्या',
      'muhurat': 'मुहूर्त',
      'ekadashis': 'एकादशी',
      'purnimas': 'पौर्णिमा',
      'amavasyas': 'अमावास्या',
      'sankrantis': 'संक्रांती',
      'parana_label': 'पारणा',
      'accessibility_display': 'सुगमता आणि प्रदर्शन',
      'elder_mode_desc': 'मजकूर २५% मोठा, मोठे टच बटण आणि अधिक स्पष्टता.',
      'panchang_tradition': 'पंचांग परंपरा',
      'calendar_tradition': 'कॅलेंडर परंपरा',
      'regional_profile': 'प्रादेशिक स्वरूप',
      'languages': 'भाषा',
      'app_ui_language': 'अ‍ॅप भाषा',
      'voice_assistant_language': 'आवाज सहायक भाषा',
      'location_management': 'स्थान व्यवस्थापन',
      'current_location': 'सध्याचे स्थान',
      'event_location_muhurat': 'कार्यक्रमाचे ठिकाण (मुहूर्तासाठी)',
      'notifications_reminders': 'सूचना आणि स्मरणपत्रे',
      'daily_panchang_sunrise': 'सूर्योदयाला दैनिक पंचांग',
      'ekadashi_reminders': 'एकादशी स्मरणपत्रे',
      'ekadashi_parana_window': 'एकादशी पारणा वेळ',
      'major_festivals_vrat': 'प्रमुख सण आणि व्रते',
      'astronomy_transparency': 'खगोलीय गणना आणि पारदर्शकता',
      'select_tradition': 'पंचांग परंपरा निवडा',
      'select_region': 'प्रादेशिक स्वरूप निवडा',
      'select_ui_lang': 'अ‍ॅप भाषा निवडा',
      'select_voice_lang': 'आवाज भाषा निवडा',
      'detailed_view': 'तपशीलवार',
      'simple_view': 'साधे',
      'panchang_elements': 'पंचांगाचे पाच अंग',
      'astronomical_timings': 'खगोलीय वेळा',
      'auspicious_inauspicious': 'शुभ आणि अशुभ काळ',
      'day_choghadiya': 'दिवसाचे चौघडिया',
      'auspicious': 'शुभ',
      'inauspicious': 'अशुभ',
      'ends_at': 'समाप्ती',
      'next_label': 'पुढील',
      'solar_noon': 'मध्यान्ह काळ',
      'close': 'बंद करा',
      'calculation_breakdown': 'गणना तपशील',
      'fasting_rule_label': 'उपवास नियम',
      'tithi_label': 'तिथी',
      'observances_label': 'उत्सव व व्रते',
    },
    'bho': {
      'app_title': 'पंचांग',
      'tab_today': 'आजु',
      'tab_calendar': 'पतरा / कैलेंडर',
      'tab_muhurat': 'लगन / मुहूर्त',
      'tab_ask': 'पूछीं',
      'astronomical_sunrise': 'खगोलीय सूर्योदय',
      'astronomical_sunset': 'खगोलीय सूर्यास्त',
      'moonrise': 'चंद्रोदय',
      'moonset': 'चंद्रास्त',
      'rahu_kaal': 'राहु काल',
      'yamaganda': 'यमगण्ड',
      'gulika': 'गुलिक काल',
      'abhijit_muhurat': 'अभिजित मुहूर्त',
      'brahma_muhurat': 'ब्रह्म बेरा',
      'next_ekadashi': 'अगिला एकादशी',
      'view_full_panchang': 'पूरा पंचांग देखीं',
      'ask_panchang': 'पंचांग से पूछीं',
      'calculated_for': 'गणना के जगह',
      'event_location': 'नेवता / काज के जगह',
      'explore_calendar': 'पतरा देखीं',
      'find_muhurat': 'मुहूर्त खोजीं',
      'what_planning': 'रउवा का विचार करत बानी?',
      'when_need_muhurat': 'मुहूर्त कवने बेरा चाहीं?',
      'popular_occasions': 'मुख्य काज / संस्कार',
      'custom_search': 'विशेष खोज',
      'why_this_window': 'ई मुहूर्त काहें नीक बा?',
      'suitable': 'बढ़िया / उपयुक्त',
      'conditional': 'विचारणीय',
      'not_suitable': 'अनुपयुक्त',
      'share': 'भेजीं',
      'add_reminder': 'यादगारी लगाईं',
      'elder_mode': 'बड़हन अच्छर (बुजुर्ग मोड)',
      'read_panchang_aloud': 'आजु के पंचांग बाँच के सुनाईं',
      'compare_calendars': 'परंपरा मिलाईं',
      'standard_panchang': 'मानक हिन्दू पंचांग',
      'vaishnava_profile': 'वैष्णव / इस्कॉन मत',
      'gita_press_profile': 'गीताप्रेस पतरा संदर्भ',
      'parana': 'पारना',
      'fasting': 'उपवास / बरत',
      'day_timeline': 'दिन के समय-सारिणी',
      'now_active': 'एह समय चल रहल बा',
      'year_view': 'सालाना पतरा',
      'month_view': 'महीनावार पतरा',
      'day_view': 'दैनिक पतरा',
      'select_location': 'जगह चुनीं',
      'search_city': 'शहर खोजीं...',
      'legend': 'चिह्न सूची',
      'legend_ekadashi': 'एकादशी / ग्यारस',
      'legend_purnima': 'पुनिवा',
      'legend_amavasya': 'अमौसा',
      'legend_festival': 'परब / त्योहार',
      'legend_muhurat': 'शुभ लगन',
      'show_muhurat_overlay': 'मुहूर्त देखाईं',
      'today_btn': 'आजु',
      'vikram_samvat': 'बिक्रम संबत',
      'listening': 'सुनत बानी... बोलीं',
      'ask_or_type': 'इहाँ पूछीं भा टाइप करीं...',
      'quick_questions': 'तुरंत सवाल',
      'speech_not_supported': 'ब्राउजर में बोलल ना चहीं',
      'change_city': 'शहर बदलीं',
      'all_festivals': 'परब आ बरत',
      'settings': 'सेटिंग आ पसंद',
      'important_times': 'जरूरी समय',
      'nakshatra_label': 'नक्षत्र',
      'yoga_label': 'योग',
      'karana_label': 'करण',
      'vara_label': 'वार',
      'live_badge': 'चालू',
      'rahu_kaal_active': 'राहु काल चल रहल बा',
      'abhijit_active': 'अभिजित मुहूर्त चल रहल बा',
      'choghadiya_active': 'चौघड़िया चल रहल बा',
      'avoid_auspicious': '(शुभ काम ना करीं)',
      'auspicious_midday': '(शुभ दुपहरिया)',
      'early_morning': '(भोर के ब्रह्म बेरा)',
      'standard': 'मानक',
      'vaishnava': 'वैष्णव',
      'gita_press': 'गीताप्रेस',
      'purnima': 'पुनिवा',
      'amavasya': 'अमौसा',
      'muhurat': 'मुहूर्त',
      'ekadashis': 'एकादशी',
      'purnimas': 'पुनिवा',
      'amavasyas': 'अमौसा',
      'sankrantis': 'संक्रांति',
      'parana_label': 'पारना',
      'accessibility_display': 'सुगमता आ प्रदर्शन',
      'elder_mode_desc': 'अक्षर २५% बड़हन, बड़हन बटन आ साफ-सुथरा।',
      'panchang_tradition': 'पंचांग परंपरा',
      'calendar_tradition': 'पतरा परंपरा',
      'regional_profile': 'क्षेत्रीय रूप',
      'languages': 'भाषा',
      'app_ui_language': 'ऐप भाषा',
      'voice_assistant_language': 'बोलौआ सहायक भाषा',
      'location_management': 'जगह प्रबंधन',
      'current_location': 'एह समय के जगह',
      'event_location_muhurat': 'काज के जगह (लगन खातिर)',
      'notifications_reminders': 'सूचना आ यादगारी',
      'daily_panchang_sunrise': 'सूर्योदय पर रोज के पंचांग',
      'ekadashi_reminders': 'एकादशी के यादगारी',
      'ekadashi_parana_window': 'एकादशी पारना बेरा',
      'major_festivals_vrat': 'मुख्य परब आ बरत',
      'astronomy_transparency': 'खगोलीय गणना आ पारदर्शिता',
      'select_tradition': 'पतरा परंपरा चुनीं',
      'select_region': 'क्षेत्रीय रूप चुनीं',
      'select_ui_lang': 'ऐप भाषा चुनीं',
      'select_voice_lang': 'बोलौआ भाषा चुनीं',
      'detailed_view': 'विस्तार से',
      'simple_view': 'सोझ',
      'panchang_elements': 'पंचांग के पाँचों अंग',
      'astronomical_timings': 'खगोलीय समय',
      'auspicious_inauspicious': 'शुभ आ अशुभ बेरा',
      'day_choghadiya': 'दिन के चौघड़िया',
      'auspicious': 'शुभ',
      'inauspicious': 'अशुभ',
      'ends_at': 'सकानी',
      'next_label': 'अगिला',
      'solar_noon': 'दुपहरिया',
      'close': 'बंद करीं',
      'calculation_breakdown': 'गणना के ब्योरा',
      'fasting_rule_label': 'बरत नियम',
      'tithi_label': 'तिथि',
      'observances_label': 'परब आ तिहुआर',
    },
  };

  static String tr(String key, [String? langCode]) {
    final lang = langCode ?? 'en';
    final dict = _localizedValues[lang] ?? _localizedValues['en']!;
    return dict[key] ?? _localizedValues['en']![key] ?? key;
  }

  static List<String> getWeekdays([String? langCode]) {
    switch (langCode ?? 'en') {
      case 'hi':
        return ['रवि', 'सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि'];
      case 'gu':
        return ['રવિ', 'સોમ', 'મંગળ', 'બુધ', 'ગુરુ', 'શુક્ર', 'શનિ'];
      case 'mr':
        return ['रवि', 'सोम', 'मंगळ', 'बुध', 'गुरु', 'शुक्र', 'शनિ'];
      case 'bho':
        return ['इतवार', 'सोम', 'मंगर', 'बुध', 'बियफे', 'शुक', 'सनिचर'];
      default:
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    }
  }

  static String getMonthName(int month, [String? langCode]) {
    final mIndex = (month - 1).clamp(0, 11);
    switch (langCode ?? 'en') {
      case 'hi':
      case 'bho':
        const hiMonths = [
          'जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
          'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
        ];
        return hiMonths[mIndex];
      case 'gu':
        const guMonths = [
          'જાન્યુઆરી', 'ફેબ્રુઆરી', 'માર્ચ', 'એપ્રિલ', 'મે', 'જૂન',
          'જુલાઈ', 'ઓગસ્ટ', 'સપ્ટેમ્બર', 'ઓક્ટોબર', 'નવેમ્બર', 'ડિસેમ્બર'
        ];
        return guMonths[mIndex];
      case 'mr':
        const mrMonths = [
          'जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मे', 'जून',
          'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर'
        ];
        return mrMonths[mIndex];
      default:
        const enMonths = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return enMonths[mIndex];
    }
  }

  static String getMonthShortName(int month, [String? langCode]) {
    final mIndex = (month - 1).clamp(0, 11);
    switch (langCode ?? 'en') {
      case 'hi':
      case 'bho':
        const hiMonths = ['जन', 'फर', 'मार्च', 'अप्रै', 'मई', 'जून', 'जुला', 'अग', 'सितं', 'अक्टू', 'नव', 'दिसं'];
        return hiMonths[mIndex];
      case 'gu':
        const guMonths = ['જાન્યુ', 'ફેબ્રુ', 'માર્ચ', 'એપ્રિ', 'મે', 'જૂન', 'જુલા', 'ઓગ', 'સપ્ટે', 'ઓક્ટો', 'નવે', 'ડિસે'];
        return guMonths[mIndex];
      case 'mr':
        const mrMonths = ['जाने', 'फेब्रु', 'मार्च', 'एप्रि', 'મે', 'जून', 'जुलै', 'ऑग', 'सप्टें', 'ऑक्टो', 'नोव्हें', 'डिसें'];
        return mrMonths[mIndex];
      default:
        const enMonths = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        return enMonths[mIndex];
    }
  }

  static String getVaraName(int weekdayIndex, [String? langCode]) {
    final idx = weekdayIndex % 7;
    switch (langCode ?? 'en') {
      case 'hi':
        const v = ['रविवार', 'सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार'];
        return v[idx];
      case 'gu':
        const v = ['રવિવાર', 'સોમવાર', 'મંગળવાર', 'બુધવાર', 'ગુરુવાર', 'શુક્રવાર', 'શનિવાર'];
        return v[idx];
      case 'mr':
        const v = ['रविवार', 'सोमवार', 'मंगळवार', 'बुधવાર', 'गुरुवार', 'शुक्रवार', 'शनिवार'];
        return v[idx];
      case 'bho':
        const v = ['इतवार', 'सोमवार', 'मंगर', 'बुधवार', 'बियफे', 'शुक्रवार', 'सनिचर'];
        return v[idx];
      default:
        const v = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        return v[idx];
    }
  }

  static String getPakshaName(Paksha paksha, [String? langCode]) {
    final isShukla = paksha == Paksha.shukla;
    switch (langCode ?? 'en') {
      case 'hi':
      case 'bho':
      case 'mr':
        return isShukla ? 'शुक्ल पक्ष' : 'कृष्ण पक्ष';
      case 'gu':
        return isShukla ? 'સુદ (શુક્લ પક્ષ)' : 'વદ (કૃષ્ણ પક્ષ)';
      default:
        return isShukla ? 'Shukla Paksha' : 'Krishna Paksha';
    }
  }

  static String getLunarMonthName(String englishMonth, [String? langCode]) {
    final map = {
      'Chaitra': {'hi': 'चैत्र', 'gu': 'ચૈત્ર', 'mr': 'चैत्र', 'bho': 'चैत'},
      'Vaishakha': {'hi': 'वैशाख', 'gu': 'વૈશાખ', 'mr': 'वैशाख', 'bho': 'बैसाख'},
      'Jyeshtha': {'hi': 'ज्येष्ठ', 'gu': 'જેઠ', 'mr': 'ज्येष्ठ', 'bho': 'जेठ'},
      'Ashadha': {'hi': 'आषाढ़', 'gu': 'અષાઢ', 'mr': 'आषाढ', 'bho': 'असाढ़'},
      'Shravana': {'hi': 'श्रावण', 'gu': 'શ્રાવણ', 'mr': 'श्रावण', 'bho': 'सावन'},
      'Bhadrapada': {'hi': 'भाद्रपद', 'gu': 'ભાદરવો', 'mr': 'भाद्रपद', 'bho': 'भादो'},
      'Ashwin': {'hi': 'आश्विन', 'gu': 'આસો', 'mr': 'अश्विन', 'bho': 'आसिन'},
      'Ashwina': {'hi': 'आश्विन', 'gu': 'આસો', 'mr': 'अश्विन', 'bho': 'आसिन'},
      'Kartika': {'hi': 'कार्तिक', 'gu': 'કારતક', 'mr': 'कार्तिक', 'bho': 'कातिक'},
      'Margashirsha': {'hi': 'मार्गशीर्ष (अगहन)', 'gu': 'માગશર', 'mr': 'मार्गशीर्ष', 'bho': 'अगहन'},
      'Pausha': {'hi': 'पौष', 'gu': 'પોષ', 'mr': 'पौष', 'bho': 'पूस'},
      'Magha': {'hi': 'माघ', 'gu': 'મહા', 'mr': 'माघ', 'bho': 'माघ'},
      'Phalguna': {'hi': 'फाल्गुन', 'gu': 'ફાગણ', 'mr': 'फाल्गुन', 'bho': 'फागुन'},
    };
    final entry = map[englishMonth];
    if (entry != null && entry[langCode] != null) {
      return entry[langCode]!;
    }
    return englishMonth;
  }

  static String getTithiName(int tithiNumber, [String? langCode]) {
    final num = tithiNumber.clamp(1, 30);
    if (langCode == 'en' || langCode == null) {
      return PanchangConstants.tithiNames[num - 1];
    }

    if (num == 15) {
      if (langCode == 'gu') return 'પૂનમ';
      if (langCode == 'bho') return 'पुनिवा';
      return 'पूर्णिमा';
    }
    if (num == 30) {
      if (langCode == 'gu') return 'અમાસ';
      if (langCode == 'bho') return 'अमौसा';
      return 'अमावस्या';
    }

    final tithiOffset = (num > 15 ? num - 15 : num);
    const hiTithis = [
      '', 'प्रतिपदा', 'द्वितीया', 'तृतीया', 'चतुर्थी', 'पंचमी',
      'षष्ठी', 'सप्तमी', 'अष्टमी', 'नवमी', 'दशमी',
      'एकादशी', 'द्वादशी', 'त्रयोदशी', 'चतुर्दशी'
    ];
    const guTithis = [
      '', 'પડવો', 'બીજ', 'ત્રીજ', 'ચોથ', 'પાંચમ',
      'છઠ્ઠ', 'સાતમ', 'આઠમ', 'નોમ', 'દસમ',
      'અગિયારસ', 'બારસ', 'તેરસ', 'ચૌદશ'
    ];
    if (langCode == 'gu' && tithiOffset < guTithis.length) {
      return guTithis[tithiOffset];
    }
    if (tithiOffset < hiTithis.length) {
      return hiTithis[tithiOffset];
    }
    return PanchangConstants.tithiNames[num - 1];
  }

  /// Compact 4-5 char Tithi code for monthly calendar cell (Zero Truncation)
  /// e.g. "शु. ५", "कृ. ११", "पूर्णिमा", "અમાસ", "S. 5"
  static String getShortTithi(int tithiNumber, Paksha paksha, [String? langCode]) {
    final num = tithiNumber.clamp(1, 30);
    final isShukla = paksha == Paksha.shukla;

    if (num == 15) {
      switch (langCode ?? 'en') {
        case 'gu': return 'પૂનમ';
        case 'bho': return 'पुनिवा';
        case 'hi':
        case 'mr': return 'पूर्णिमा';
        default: return 'Purnima';
      }
    }
    if (num == 30) {
      switch (langCode ?? 'en') {
        case 'gu': return 'અમાસ';
        case 'bho': return 'अमौसा';
        case 'hi':
        case 'mr': return 'अमावस्या';
        default: return 'Amavasya';
      }
    }

    final tithiOffset = num > 15 ? num - 15 : num;

    switch (langCode ?? 'en') {
      case 'gu':
        final prefix = isShukla ? 'સુદ' : 'વદ';
        return '$prefix $tithiOffset';
      case 'hi':
      case 'mr':
      case 'bho':
        final prefix = isShukla ? 'शु.' : 'कृ.';
        return '$prefix $tithiOffset';
      default:
        final prefix = isShukla ? 'S.' : 'K.';
        return '$prefix $tithiOffset';
    }
  }

  /// Translates common Hindu festival and observance names across languages
  static String localizeFestivalName(String name, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return name;

    final lower = name.toLowerCase();

    final festivals = {
      'hartalika teej': {'hi': 'हरतालिका तीज', 'gu': 'હરતાલિકા ત્રીજ', 'mr': 'हरतालिका', 'bho': 'हरितालिका तीज'},
      'ganesh chaturthi': {'hi': 'गणेश चतुर्थी', 'gu': 'ગણેશ ચતુર્થી', 'mr': 'गणेश चतुर्थी', 'bho': 'गणेश चतुर्थी'},
      'rishi panchami': {'hi': 'ऋषि पंचमी', 'gu': 'ઋષિ પાંચમ', 'mr': 'ऋषी पंचमी', 'bho': 'ऋषि पंचमी'},
      'radha ashtami': {'hi': 'राधा अष्टमी', 'gu': 'રાધા અષ્ટમી', 'mr': 'राधा अष्टमी', 'bho': 'राधा अष्टमी'},
      'anant chaturdashi': {'hi': 'अनंत चतुर्दशी', 'gu': 'અનંત ચતુર્દશી', 'mr': 'अनंत चतुर्दशी', 'bho': 'अनंत चतुर्दशी'},
      'durga ashtami': {'hi': 'दुर्गा अष्टमी', 'gu': 'દુર્ગા અષ્ટમી', 'mr': 'दुर्गाष्टमी', 'bho': 'दुर्गा अष्टमी'},
      'maha navami': {'hi': 'महानवमी', 'gu': 'મહાનવમી', 'mr': 'महानवमी', 'bho': 'महानवमी'},
      'vijayadashami': {'hi': 'विजयदशमी', 'gu': 'વિજયાદશમી', 'mr': 'दसऱ्या/दसरा', 'bho': 'दशहरा'},
      'dussehra': {'hi': 'दशहरा', 'gu': 'દશેરા', 'mr': 'दसरा', 'bho': 'दशहरा'},
      'sharad purnima': {'hi': 'शरद पूर्णिमा', 'gu': 'શરદ પૂનમ', 'mr': 'कोजागरी पौर्णिमा', 'bho': 'शरद पुनिवा'},
      'karwa chauth': {'hi': 'करवा चौथ', 'gu': 'કરવા ચોથ', 'mr': 'करवा चौथ', 'bho': 'करवा चौथ'},
      'ahoi ashtami': {'hi': 'अहोई अष्टमी', 'gu': 'અહોઈ અષ્ટમી', 'mr': 'अहोई अष्टमी', 'bho': 'अहोई आठे'},
      'dhanteras': {'hi': 'धनतेरस', 'gu': 'ધનતેરસ', 'mr': 'धनत्रयोदशी', 'bho': 'धनतेरस'},
      'narak chaturdashi': {'hi': 'नरक चतुर्दशी', 'gu': 'કાળી ચૌદશ', 'mr': 'नरक चतुर्दशी', 'bho': 'नरक चौदस'},
      'diwali': {'hi': 'दीपावली', 'gu': 'દિવાળી', 'mr': 'दिवाळी', 'bho': 'दिवाली'},
      'deepavali': {'hi': 'दीपावली', 'gu': 'દિવાળી', 'mr': 'दिवाळी', 'bho': 'दीपावली'},
      'govardhan puja': {'hi': 'गोवर्धन पूजा', 'gu': 'બેસતું વર્ષ / ગોવર્ધન', 'mr': 'गोवर्धन पूजा', 'bho': 'गोवर्धन पूजा'},
      'bhai dooj': {'hi': 'भाई दूज', 'gu': 'ભાઈબીજ', 'mr': 'भाऊबीज', 'bho': 'भाई दूज'},
      'chhath puja': {'hi': 'छठ पूजा', 'gu': 'છઠ પૂજા', 'mr': 'छठ पूजा', 'bho': 'छठ बरत'},
      'devutthana ekadashi': {'hi': 'देवउठनी एकादशी', 'gu': 'દેવઉઠી અગિયારસ', 'mr': 'प्रबोधिनी एकादशी', 'bho': 'देवउठान एकादशी'},
      'tulsi vivah': {'hi': 'तुलसी विवाह', 'gu': 'તુલસી વિવાહ', 'mr': 'तुलसी विवाह', 'bho': 'तुलसी बियाह'},
      'kartik purnima': {'hi': 'कार्तिक पूर्णिमा', 'gu': 'દેવ દિવાળી', 'mr': 'त्रिपुरी पौर्णिमा', 'bho': 'कातिक पुनिवा'},
      'gita jayanti': {'hi': 'गीता जयंती', 'gu': 'ગીતા જયંતી', 'mr': 'गीता जयंती', 'bho': 'गीता जयंती'},
      'makar sankranti': {'hi': 'मकर संक्रांति', 'gu': 'ઉત્તરાયણ', 'mr': 'मकर संक्रांत', 'bho': 'खिचड़ी / संक्रांति'},
      'vasant panchami': {'hi': 'वसंत पंचमी', 'gu': 'વસંત પંચમી', 'mr': 'वसंत पंचमी', 'bho': 'सरस्वती पूजा'},
      'maha shivratri': {'hi': 'महाशिवरात्रि', 'gu': 'મહાશિવરાત્રી', 'mr': 'महाशिवरात्री', 'bho': 'शिवराति'},
      'holika dahan': {'hi': 'होलिका दहन', 'gu': 'હોળી પ્રગટાવવી', 'mr': 'होलिका दहन', 'bho': 'संवत फूँकल'},
      'holi': {'hi': 'होली', 'gu': 'ધૂળેટી', 'mr': 'धुलિવંદન', 'bho': 'होली'},
      'chaitra navratri': {'hi': 'चैत्र नवरात्रि', 'gu': 'ચૈત્રી નવરાત્રી', 'mr': 'चैत्र नवरात्र', 'bho': 'चैती नवरातर'},
      'rama navami': {'hi': 'राम नवमी', 'gu': 'રામનવમી', 'mr': 'रामनवमी', 'bho': 'रामनवमी'},
      'hanuman jayanti': {'hi': 'हनुमान जयंती', 'gu': 'હનુમાન જયંતિ', 'mr': 'हनुमान जयंती', 'bho': 'हनुमान जयंती'},
      'akshaya tritiya': {'hi': 'अक्षय तृतीया', 'gu': 'અક્ષય તૃતીયા (અખાત્રીજ)', 'mr': 'अक्षय्य तृतीया', 'bho': 'अक्षय तृतीया'},
      'narasimha jayanti': {'hi': 'नृसिंह जयंती', 'gu': 'નૃસિંહ જયંતી', 'mr': 'नृसिंह जयंती', 'bho': 'नरसिंह जयंती'},
      'buddha purnima': {'hi': 'बुद्ध पूर्णिमा', 'gu': 'બુદ્ધ પૂર્ણિમા', 'mr': 'बुद्ध पौर्णिमा', 'bho': 'बुद्ध पुनिवा'},
      'guru purnima': {'hi': 'गुरु पूर्णिमा', 'gu': 'ગુરુ પૂર્ણિમા', 'mr': 'गुरुपौर्णिमा', 'bho': 'गुरु पूर्णिमा'},
      'nag panchami': {'hi': 'नाग पंचमी', 'gu': 'નાગ પાંચમ', 'mr': 'नागपंचमी', 'bho': 'नाग पंचमी'},
      'raksha bandhan': {'hi': 'रक्षाबंधन', 'gu': 'રક્ષાબંધન', 'mr': 'रक्षाबंधन', 'bho': 'राखी'},
      'krishna janmashtami': {'hi': 'श्री कृष्ण जन्माष्टमी', 'gu': 'જન્માષ્ટમી', 'mr': 'गोकुळाष्टमी', 'bho': 'कन्हैया जनम'},
      'janmashtami': {'hi': 'जन्माष्टमी', 'gu': 'જન્માષ્ટમી', 'mr': 'गोकुळाष्टमी', 'bho': 'जन्माष्टमी'},
      'darsha amavasya': {'hi': 'दर्श अमावस्या', 'gu': 'દર્શ અમાસ', 'mr': 'दर्श अमावास्या', 'bho': 'दर्श अमोसा'},
      'somvati amavasya': {'hi': 'सोमवती अमावस्या', 'gu': 'સોમવતી અમાસ', 'mr': 'સોમવતી अमावास्या', 'bho': 'सोमवती अमोसा'},
      'mahalaya amavasya': {'hi': 'सर्वपितृ अमावस्या', 'gu': 'સર્વપિતૃ અમાસ', 'mr': 'सर्वपित्री अमावास्या', 'bho': 'सर्वपितृ अमोसा'},
      'sarva pitru amavasya': {'hi': 'सर्वपितृ अमावस्या', 'gu': 'સર્વપિતૃ અમાસ', 'mr': 'सर्वपित्री अमावास्या', 'bho': 'सर्वपितृ अमोसा'},
      'pradosh': {'hi': 'प्रदोष व्रत', 'gu': 'પ્રદોષ વ્રત', 'mr': 'प्रदोष व्रत', 'bho': 'प्रदोष बरत'},
      'satyanarayan': {'hi': 'सत्यनारायण पूजा / पूर्णिमा व्रत', 'gu': 'સત્યનારાયણ પૂજા / પૂનમ વ્રત', 'mr': 'सत्यनारायण पूजा', 'bho': 'सत्यनारायन पूजा'},
      'sankashti': {'hi': 'संकष्टी चतुर्थी', 'gu': 'સંકષ્ટિ ચતુર્થી', 'mr': 'संकष्टी चतुर्थी', 'bho': 'संकष्टी चतुर्थी'},
      'vinayaka chaturthi': {'hi': 'विनायक चतुर्थी', 'gu': 'વિનાયક ચતુર્થી', 'mr': 'વિનાયક चतुर्थी', 'bho': 'विनायक चतुर्थी'},
      'masik shivratri': {'hi': 'मासिक शिवरात्रि', 'gu': 'માસિક શિવરાત્રી', 'mr': 'मासिक शिवरात्री', 'bho': 'मासिक शिवराति'},
      'skanda sashti': {'hi': 'स्कंद षष्ठी', 'gu': 'સ્કંદ ષષ્ઠી', 'mr': 'स्कंद षष्ठी', 'bho': 'स्कंद षष्ठी'},
      'indira ekadashi': {'hi': 'इन्दिरा एकादशी', 'gu': 'ઇન્દિરા અગિયારસ', 'mr': 'इन्दिरा एकादशी', 'bho': 'इन्दिरा ग्यारस'},
      'papankusha ekadashi': {'hi': 'पापांकुशा एकादशी', 'gu': 'પાપાંકુશા અગિયારસ', 'mr': 'पापांकुशा एकादशी', 'bho': 'पापांकुशा ग्यारस'},
      'rama ekadashi': {'hi': 'रमा एकादशी', 'gu': 'રમા અગિયારસ', 'mr': 'रमा एकादशी', 'bho': 'रमा ग्यारस'},
    };

    for (final key in festivals.keys) {
      if (lower.contains(key)) {
        return festivals[key]![langCode] ?? name;
      }
    }

    final ekadashiWord = langCode == 'gu' ? 'અગિયારસ' : (langCode == 'bho' ? 'ग्यारस' : 'एकादशी');
    final purnimaWord = langCode == 'gu' ? 'પૂનમ' : (langCode == 'bho' ? 'पुनिवा' : 'पूर्णिमा');
    final amavasyaWord = langCode == 'gu' ? 'અમાસ' : (langCode == 'bho' ? 'અમોસા' : 'अमावस्या');
    final vratWord = langCode == 'gu' ? 'વ્રત' : (langCode == 'bho' ? 'बरत' : 'व्रत');

    String translated = name
        .replaceAll(RegExp(r'\bEkadashi\b', caseSensitive: false), ekadashiWord)
        .replaceAll(RegExp(r'\bPurnima\b', caseSensitive: false), purnimaWord)
        .replaceAll(RegExp(r'\bAmavasya\b', caseSensitive: false), amavasyaWord)
        .replaceAll(RegExp(r'\bVrat\b', caseSensitive: false), vratWord);

    return translated;
  }

  static String getNakshatraName(String englishName, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return englishName;

    const map = {
      'Ashwini': {'hi': 'अश्विनी', 'gu': 'અશ્વિની', 'mr': 'अश्विनी', 'bho': 'अश्विनी'},
      'Bharani': {'hi': 'भरणी', 'gu': 'ભરણી', 'mr': 'भरणी', 'bho': 'भरणी'},
      'Krittika': {'hi': 'कृत्तिका', 'gu': 'કૃત્તિકા', 'mr': 'कृत्तिका', 'bho': 'कृत्तिका'},
      'Rohini': {'hi': 'रोहिणी', 'gu': 'રોહિણી', 'mr': 'रोहिणी', 'bho': 'रोहिणी'},
      'Mrigashira': {'hi': 'मृगशिरा', 'gu': 'મૃગશીર્ષ', 'mr': 'मृगशीर्ष', 'bho': 'मृगशिरा'},
      'Ardra': {'hi': 'आर्द्रा', 'gu': 'આર્દ્રા', 'mr': 'आर्द्रा', 'bho': 'आर्द्रा'},
      'Punarvasu': {'hi': 'पुनर्वसु', 'gu': 'પુનર્વસુ', 'mr': 'पुनर्वसु', 'bho': 'पुनर्वसु'},
      'Pushya': {'hi': 'पुष्य', 'gu': 'પુષ્ય', 'mr': 'पुष्य', 'bho': 'पुष्य'},
      'Ashlesha': {'hi': 'आश्लेषा', 'gu': 'આશ્લેષા', 'mr': 'आश्लेषा', 'bho': 'अश्लेषा'},
      'Magha': {'hi': 'मघा', 'gu': 'મઘા', 'mr': 'मघा', 'bho': 'मघा'},
      'Purva Phalguni': {'hi': 'पूर्वा फाल्गुनी', 'gu': 'પૂર્વા ફાલ્ગુની', 'mr': 'पूर्वा फाल्गुनी', 'bho': 'पूर्वा फाल्गुनी'},
      'Uttara Phalguni': {'hi': 'उत्तरा फाल्गुनी', 'gu': 'ઉત્તરા ફાલ્ગુની', 'mr': 'उत्तरा फाल्गुनी', 'bho': 'उत्तरा फाल्गुनी'},
      'Hasta': {'hi': 'हस्त', 'gu': 'હસ્ત', 'mr': 'हस्त', 'bho': 'हस्त'},
      'Chitra': {'hi': 'चित्रा', 'gu': 'ચિત્રા', 'mr': 'चित्रा', 'bho': 'चित्रा'},
      'Swati': {'hi': 'स्वाति', 'gu': 'સ્વાતિ', 'mr': 'स्वाती', 'bho': 'स्वाति'},
      'Vishakha': {'hi': 'विशाखा', 'gu': 'વિશાખા', 'mr': 'विशाखा', 'bho': 'विशाखा'},
      'Anuradha': {'hi': 'अनुराधा', 'gu': 'અનુરાધા', 'mr': 'अनुराधा', 'bho': 'अनुराधा'},
      'Jyeshtha': {'hi': 'ज्येष्ठा', 'gu': 'જ્યેષ્ઠા', 'mr': 'ज्येष्ठा', 'bho': 'जेष्ठा'},
      'Mula': {'hi': 'मूल', 'gu': 'મૂળ', 'mr': 'मूळ', 'bho': 'मूल'},
      'Purva Ashadha': {'hi': 'पूर्वाषाढ़ा', 'gu': 'પૂર્વાષાઢા', 'mr': 'पूर्वाषाढा', 'bho': 'पूर्वाषाढ़ा'},
      'Uttara Ashadha': {'hi': 'उत्तराषाढ़ा', 'gu': 'ઉત્તરાષાઢા', 'mr': 'उत्तराषाढा', 'bho': 'उत्तराषाढ़ा'},
      'Shravana': {'hi': 'श्रवण', 'gu': 'શ્રવણ', 'mr': 'श्रवण', 'bho': 'सोन'},
      'Dhanishta': {'hi': 'धनिष्ठा', 'gu': 'ધનિષ્ઠા', 'mr': 'धनिष्ठा', 'bho': 'धनिष्ठा'},
      'Shatabhisha': {'hi': 'शतभिषा', 'gu': 'શતભિષા', 'mr': 'शततारका', 'bho': 'शतभिषा'},
      'Purva Bhadrapada': {'hi': 'पूर्वाभाद्रपद', 'gu': 'પૂર્વા ભાદ્રપદ', 'mr': 'पूर्वाभाद्रपदा', 'bho': 'पूर्वाभाद्रपद'},
      'Uttara Bhadrapada': {'hi': 'उत्तराभाद्रपद', 'gu': 'ઉત્તરા ભાદ્રપદ', 'mr': 'उत्तराभाद्रपदा', 'bho': 'उत्तराभाद्रपद'},
      'Revati': {'hi': 'रेवती', 'gu': 'રેવતી', 'mr': 'रेवती', 'bho': 'रेवती'},
    };

    final entry = map[englishName];
    if (entry != null && entry[langCode] != null) {
      return entry[langCode]!;
    }
    return englishName;
  }

  static String getYogaName(String englishName, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return englishName;

    const map = {
      'Vishkambha': {'hi': 'विष्कम्भ', 'gu': 'વિષ્કંભ', 'mr': 'विष्कंभ', 'bho': 'विष्कम्भ'},
      'Priti': {'hi': 'प्रीति', 'gu': 'પ્રીતિ', 'mr': 'प्रीती', 'bho': 'प्रीति'},
      'Ayushman': {'hi': 'आयुष्मान्', 'gu': 'આયુષ્માન', 'mr': 'आयुष्मान', 'bho': 'आयुष्मान'},
      'Saubhagya': {'hi': 'सौभाग्य', 'gu': 'સૌભાગ્ય', 'mr': 'सौभाग्य', 'bho': 'सौभाग्य'},
      'Shobhana': {'hi': 'शोभन', 'gu': 'શોભન', 'mr': 'शोभन', 'bho': 'शोभन'},
      'Atiganda': {'hi': 'अतिगण्ड', 'gu': 'અતિગંડ', 'mr': 'अतिगंड', 'bho': 'अतिगण्ड'},
      'Sukarma': {'hi': 'सुकर्मा', 'gu': 'સુકર્મા', 'mr': 'सुकर्मा', 'bho': 'सुकर्मा'},
      'Dhriti': {'hi': 'धृति', 'gu': 'ધૃતિ', 'mr': 'धृती', 'bho': 'धृति'},
      'Shula': {'hi': 'शूल', 'gu': 'શૂલ', 'mr': 'शूल', 'bho': 'शूल'},
      'Ganda': {'hi': 'गण्ड', 'gu': 'ગંડ', 'mr': 'गंड', 'bho': 'गण्ड'},
      'Vriddhi': {'hi': 'वृद्धि', 'gu': 'વૃદ્ધિ', 'mr': 'वृद्धी', 'bho': 'वृद्धि'},
      'Dhruva': {'hi': 'ध्रुव', 'gu': 'ધ્રુવ', 'mr': 'ध्रुव', 'bho': 'ध्रुव'},
      'Vyaghata': {'hi': 'व्याघात', 'gu': 'વ્યાઘાત', 'mr': 'व्याघात', 'bho': 'व्याघात'},
      'Harshana': {'hi': 'हर्षण', 'gu': 'હર્ષણ', 'mr': 'हर्षण', 'bho': 'हर्षण'},
      'Vajra': {'hi': 'वज्र', 'gu': 'વજ્ર', 'mr': 'वज्र', 'bho': 'वज्र'},
      'Siddhi': {'hi': 'सिद्धि', 'gu': 'સિદ્ધિ', 'mr': 'सिद्धी', 'bho': 'सिद्धि'},
      'Vyatipata': {'hi': 'व्यतीपात', 'gu': 'વ્યતીપાત', 'mr': 'व्यतीपात', 'bho': 'व्यतीपात'},
      'Variyan': {'hi': 'वरीयान्', 'gu': 'વરીયાન', 'mr': 'वरीयान', 'bho': 'वरीयान'},
      'Parigha': {'hi': 'परिघ', 'gu': 'પરિઘ', 'mr': 'परिघ', 'bho': 'परिघ'},
      'Shiva': {'hi': 'शिव', 'gu': 'શિવ', 'mr': 'शिव', 'bho': 'शिव'},
      'Siddha': {'hi': 'सिद्ध', 'gu': 'સિદ્ધ', 'mr': 'सिद्ध', 'bho': 'सिद्ध'},
      'Sadhya': {'hi': 'साध्य', 'gu': 'સાધ્ય', 'mr': 'साध्य', 'bho': 'साध्य'},
      'Shubha': {'hi': 'शुभ', 'gu': 'શુભ', 'mr': 'शुभ', 'bho': 'शुभ'},
      'Shukla': {'hi': 'शुक्ल', 'gu': 'શુક્લ', 'mr': 'शुक्ल', 'bho': 'शुक्ल'},
      'Brahma': {'hi': 'ब्रह्म', 'gu': 'બ્રહ્મ', 'mr': 'ब्रह्म', 'bho': 'ब्रह्म'},
      'Indra': {'hi': 'इन्द्र', 'gu': 'ઇન્દ્ર', 'mr': 'इंद्र', 'bho': 'इन्द्र'},
      'Vaidhriti': {'hi': 'वैधृति', 'gu': 'વૈધૃતિ', 'mr': 'वैधृती', 'bho': 'वैधृति'},
    };

    final entry = map[englishName];
    if (entry != null && entry[langCode] != null) {
      return entry[langCode]!;
    }
    return englishName;
  }

  static String getKaranaName(String englishName, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return englishName;

    const map = {
      'Bava': {'hi': 'बव', 'gu': 'બવ', 'mr': 'बव', 'bho': 'बव'},
      'Balava': {'hi': 'बालव', 'gu': 'બાલવ', 'mr': 'बालव', 'bho': 'बालव'},
      'Kaulava': {'hi': 'कौलव', 'gu': 'કૌલવ', 'mr': 'कौलव', 'bho': 'कौलव'},
      'Taitila': {'hi': 'तैतिल', 'gu': 'તૈતિલ', 'mr': 'तैतिल', 'bho': 'तैतिल'},
      'Gara': {'hi': 'गर', 'gu': 'ગર', 'mr': 'गर', 'bho': 'गर'},
      'Vanija': {'hi': 'वणिज', 'gu': 'વણિજ', 'mr': 'वणिज', 'bho': 'वणिज'},
      'Vishti': {'hi': 'विष्टि (भद्रा)', 'gu': 'વિષ્ટિ (ભદ્રા)', 'mr': 'विष्टी (भद्रा)', 'bho': 'विष्टि (भद्रा)'},
      'Shakuni': {'hi': 'शकुनि', 'gu': 'શકુનિ', 'mr': 'शकुनी', 'bho': 'शकुनि'},
      'Chatushpada': {'hi': 'चतुष्पद', 'gu': 'ચતુષ્પદ', 'mr': 'चतुष्पाद', 'bho': 'चतुष्पद'},
      'Naga': {'hi': 'नाग', 'gu': 'નાગ', 'mr': 'नाग', 'bho': 'नाग'},
      'Kintughna': {'hi': 'किस्तुघ्न', 'gu': 'કિંસ્તુઘ્ન', 'mr': 'किस्तुघ्न', 'bho': 'किस्तुघ्न'},
    };

    final entry = map[englishName];
    if (entry != null && entry[langCode] != null) {
      return entry[langCode]!;
    }
    return englishName;
  }

  static String getChoghadiyaName(String englishName, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return englishName;

    const map = {
      'Amrit': {'hi': 'अमृत', 'gu': 'અમૃત', 'mr': 'अमृत', 'bho': 'अमृत'},
      'Shubh': {'hi': 'शुभ', 'gu': 'શુભ', 'mr': 'शुभ', 'bho': 'शुभ'},
      'Labh': {'hi': 'लाभ', 'gu': 'લાભ', 'mr': 'लाभ', 'bho': 'लाभ'},
      'Char': {'hi': 'चर', 'gu': 'ચર', 'mr': 'चर', 'bho': 'चर'},
      'Rog': {'hi': 'रोग', 'gu': 'રોગ', 'mr': 'रोग', 'bho': 'रोग'},
      'Kaal': {'hi': 'काल', 'gu': 'કાળ', 'mr': 'काळ', 'bho': 'काल'},
      'Udveg': {'hi': 'उद्वेग', 'gu': 'ઉદ્વેગ', 'mr': 'उद्वेग', 'bho': 'उद्वेग'},
    };

    final entry = map[englishName];
    if (entry != null && entry[langCode] != null) {
      return entry[langCode]!;
    }
    return englishName;
  }

  static String localizeFastingRule(String rule, [String? langCode]) {
    if (langCode == 'en' || langCode == null) return rule;

    final lower = rule.toLowerCase();
    if (lower.contains('waterless') || lower.contains('nirjala')) {
      switch (langCode) {
        case 'hi': return 'निर्जला अथवा फलाहार व्रत';
        case 'gu': return 'નિર્જળા અથવા ફળાહાર ઉપવાસ';
        case 'mr': return 'निर्जला किंवा फलाहार उपवास';
        case 'bho': return 'निर्जला चाहे फलाहार बरत';
      }
    }
    if (lower.contains('fruit') || lower.contains('phalahar')) {
      switch (langCode) {
        case 'hi': return 'फलाहार व्रत मान्य';
        case 'gu': return 'ફળાહાર ઉપવાસ માન્ય';
        case 'mr': return 'फलाहार उपवास';
        case 'bho': return 'फलाहार बरत';
      }
    }
    if (lower.contains('fasting') || lower.contains('fast')) {
      switch (langCode) {
        case 'hi': return 'एकादशी उपवास एवं जप-ध्यान';
        case 'gu': return 'એકાદશી ઉપવાસ અને ધ્યાન';
        case 'mr': return 'एकादशी उपवास व नामस्मरण';
        case 'bho': return 'एकादशी बरत आ हरि-कीर्तन';
      }
    }
    return rule;
  }

  static String getTraditionName(CalendarTradition tradition, [String? langCode]) {
    switch (tradition) {
      case CalendarTradition.standardHindu:
        return tr('standard_panchang', langCode);
      case CalendarTradition.vaishnavaIskcon:
        return tr('vaishnava_profile', langCode);
      case CalendarTradition.gitaPressReference:
        return tr('gita_press_profile', langCode);
    }
  }
}

