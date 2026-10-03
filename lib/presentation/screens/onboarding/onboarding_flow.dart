import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/cities.dart';
import '../../../domain/models/location_info.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageCtrl = PageController();
  int _currentStep = 0;

  String _selectedLang = 'en';
  CalendarTradition _selectedTradition = CalendarTradition.standardHindu;
  RegionalProfile _selectedRegion = RegionalProfile.gujarat;
  LocationInfo _selectedLocation = LocationInfo.vadodara;

  void _nextPage() {
    if (_currentStep < 5) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save all preferences
      LocalStorageService.appLanguage = _selectedLang;
      LocalStorageService.selectedTradition = _selectedTradition;
      LocalStorageService.selectedRegion = _selectedRegion;
      LocationService.setCurrentLocation(_selectedLocation);
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: List.generate(6, (idx) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: idx <= _currentStep
                            ? AppTheme.saffronPrimary
                            : AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildWelcomeScreen(),
                  _buildLanguageScreen(),
                  _buildTraditionScreen(),
                  _buildRegionalScreen(),
                  _buildLocationScreen(),
                  _buildNotificationScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Welcome Screen
  Widget _buildWelcomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🪔', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          const Text(
            'Your Panchang, wherever life takes you.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.deepText),
          ),
          const SizedBox(height: 12),
          const Text(
            'Panchang • Festivals • Ekadashi • Muhurat • Voice Assistant',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.subtleText),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _nextPage,
              child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          TextButton(
            onPressed: () {
              LocationService.setCurrentLocation(LocationInfo.vadodara);
              _nextPage();
            },
            child: const Text('Continue without location', style: TextStyle(color: AppTheme.subtleText)),
          ),
        ],
      ),
    );
  }

  // 2. Language Screen
  Widget _buildLanguageScreen() {
    final langs = [
      {'code': 'en', 'title': 'English', 'sub': 'English'},
      {'code': 'hi', 'title': 'हिन्दी', 'sub': 'Hindi'},
      {'code': 'gu', 'title': 'ગુજરાતી', 'sub': 'Gujarati'},
      {'code': 'mr', 'title': 'मराठी', 'sub': 'Marathi'},
      {'code': 'bho', 'title': 'भोजपुरी', 'sub': 'Bhojpuri'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Language', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('You can change this later from settings.', style: TextStyle(color: AppTheme.subtleText)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: langs.map((l) {
                final isSelected = _selectedLang == l['code'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle),
                    ),
                    tileColor: isSelected ? AppTheme.saffronPrimary.withOpacity(0.08) : null,
                    title: Text(l['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(l['sub']!),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.saffronPrimary) : null,
                    onTap: () {
                      setState(() => _selectedLang = l['code']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  // 3. Tradition Screen
  Widget _buildTraditionScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Panchang Tradition', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Which Panchang tradition do you follow?', style: TextStyle(color: AppTheme.subtleText)),
          const SizedBox(height: 20),
          _buildTraditionTile(
            title: 'Standard Hindu Panchang',
            desc: 'Daily Tithi, Nakshatra, Vrat, Festivals, Muhurat and related timings based on Smarta principles.',
            value: CalendarTradition.standardHindu,
          ),
          _buildTraditionTile(
            title: 'Vaishnava / ISKCON Tradition',
            desc: 'Strict Shuddha Ekadashi, fasting/Parana rules, Mahadvadashis and Vaishnava observances.',
            value: CalendarTradition.vaishnavaIskcon,
          ),
          _buildTraditionTile(
            title: 'Gita Press Reference',
            desc: 'A Gita Press-style reference calendar profile for religious dates and observances.',
            value: CalendarTradition.gitaPressReference,
          ),
          const Spacer(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildTraditionTile({
    required String title,
    required String desc,
    required CalendarTradition value,
  }) {
    final isSelected = _selectedTradition == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle),
        ),
        tileColor: isSelected ? AppTheme.saffronPrimary.withOpacity(0.08) : null,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.saffronPrimary) : null,
        onTap: () => setState(() => _selectedTradition = value),
      ),
    );
  }

  // 4. Regional Screen
  Widget _buildRegionalScreen() {
    final regions = [
      {'val': RegionalProfile.gujarat, 'name': 'Gujarat'},
      {'val': RegionalProfile.maharashtra, 'name': 'Maharashtra'},
      {'val': RegionalProfile.northIndia, 'name': 'North India'},
      {'val': RegionalProfile.uttarPradesh, 'name': 'Uttar Pradesh'},
      {'val': RegionalProfile.bihar, 'name': 'Bihar'},
      {'val': RegionalProfile.rajasthan, 'name': 'Rajasthan'},
      {'val': RegionalProfile.bengal, 'name': 'Bengal'},
      {'val': RegionalProfile.tamilNadu, 'name': 'Tamil Nadu'},
      {'val': RegionalProfile.karnataka, 'name': 'Karnataka'},
      {'val': RegionalProfile.andhraTelangana, 'name': 'Andhra / Telangana'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Regional Tradition', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Determines regional festival and month traditions.', style: TextStyle(color: AppTheme.subtleText)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: regions.map((r) {
                final isSelected = _selectedRegion == r['val'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle),
                    ),
                    tileColor: isSelected ? AppTheme.saffronPrimary.withOpacity(0.08) : null,
                    title: Text(r['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.saffronPrimary) : null,
                    onTap: () => setState(() => _selectedRegion = r['val'] as RegionalProfile),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  // 5. Location Screen
  Widget _buildLocationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Location', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text(
            'Your location is used to calculate local Panchang and Muhurat timings. We never send your location to any server.',
            style: TextStyle(color: AppTheme.subtleText),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.my_location, color: AppTheme.saffronPrimary),
            title: const Text('Use Current Location (GPS)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Auto-detects coordinates offline'),
            onTap: () {
              setState(() => _selectedLocation = LocationInfo.vadodara);
              _nextPage();
            },
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Quick Select City:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildCityChip(LocationInfo.vadodara),
              _buildCityChip(LocationInfo.ahmedabad),
              _buildCityChip(LocationInfo.varanasi),
              _buildCityChip(CityDatabase.findByName('Mumbai')!),
              _buildCityChip(CityDatabase.findByName('Delhi')!),
            ],
          ),
          const Spacer(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildCityChip(LocationInfo city) {
    final isSelected = _selectedLocation.name == city.name;
    return ChoiceChip(
      label: Text(city.displayName),
      selected: isSelected,
      selectedColor: AppTheme.saffronPrimary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.deepText),
      onSelected: (val) {
        if (val) setState(() => _selectedLocation = city);
      },
    );
  }

  // 6. Notifications Screen
  Widget _buildNotificationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Choose which auspicious reminders you want to receive.', style: TextStyle(color: AppTheme.subtleText)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  value: LocalStorageService.notifyDailyPanchang,
                  title: const Text('Daily Panchang'),
                  subtitle: const Text('Receive today\'s tithi & timings at sunrise'),
                  activeColor: AppTheme.saffronPrimary,
                  onChanged: (v) => setState(() => LocalStorageService.notifyDailyPanchang = v),
                ),
                SwitchListTile(
                  value: LocalStorageService.notifyEkadashi,
                  title: const Text('Ekadashi Reminders'),
                  subtitle: const Text('Alert the evening before fasting days'),
                  activeColor: AppTheme.saffronPrimary,
                  onChanged: (v) => setState(() => LocalStorageService.notifyEkadashi = v),
                ),
                SwitchListTile(
                  value: LocalStorageService.notifyEkadashiParana,
                  title: const Text('Ekadashi Parana (Fast Breaking)'),
                  subtitle: const Text('Exact morning fast breaking window'),
                  activeColor: AppTheme.saffronPrimary,
                  onChanged: (v) => setState(() => LocalStorageService.notifyEkadashiParana = v),
                ),
                SwitchListTile(
                  value: LocalStorageService.notifyFestivals,
                  title: const Text('Major Festivals & Vrat'),
                  subtitle: const Text('Diwali, Holi, Navratri, Shivaratri, etc.'),
                  activeColor: AppTheme.saffronPrimary,
                  onChanged: (v) => setState(() => LocalStorageService.notifyFestivals = v),
                ),
                SwitchListTile(
                  value: LocalStorageService.notifyMuhurat,
                  title: const Text('Saved Muhurat Reminders'),
                  subtitle: const Text('Alert 30 minutes before your planned Muhurat'),
                  activeColor: AppTheme.saffronPrimary,
                  onChanged: (v) => setState(() => LocalStorageService.notifyMuhurat = v),
                ),
              ],
            ),
          ),
          _buildNextButton(label: 'Finish Setup'),
        ],
      ),
    );
  }

  Widget _buildNextButton({String label = 'Continue'}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.saffronPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _nextPage,
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
