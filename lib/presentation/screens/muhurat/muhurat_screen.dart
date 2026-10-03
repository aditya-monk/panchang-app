import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/cities.dart';
import '../../../data/muhurat_rules.dart';
import '../../../domain/models/location_info.dart';
import '../../../domain/models/muhurat_window.dart';
import '../../../services/location/location_service.dart';
import '../../../services/muhurat/muhurat_service.dart';
import '../../../services/nlp/nlp_query_parser.dart';
import '../../../services/notifications/notification_service.dart';
import '../../../services/storage/local_storage_service.dart';

class MuhuratScreen extends StatefulWidget {
  const MuhuratScreen({super.key});

  @override
  State<MuhuratScreen> createState() => _MuhuratScreenState();
}

class _MuhuratScreenState extends State<MuhuratScreen> {
  final TextEditingController _queryCtrl = TextEditingController();
  late LocationInfo _eventLocation;
  String _selectedOccasionId = 'griha_pravesh';
  MuhuratSearchResult? _currentResult;

  @override
  void initState() {
    super.initState();
    // Event location overrides current location per Section 45
    _eventLocation = LocationService.activeMuhuratLocation;
    _runSearch();
  }

  void _runSearch({String? overrideOccasion}) {
    final occasion = overrideOccasion ?? _selectedOccasionId;
    final now = DateTime.now();
    final start = now;
    final end = now.add(const Duration(days: 45));

    final res = MuhuratService.findMuhurat(
      occasionId: occasion,
      location: _eventLocation,
      startDate: start,
      endDate: end,
      tradition: LocalStorageService.selectedTradition,
    );

    setState(() {
      _selectedOccasionId = occasion;
      _currentResult = res;
    });
  }

  void _handleNlpSearch(String query) {
    if (query.trim().isEmpty) return;

    final parsed = NlpQueryParser.parse(
      query: query,
      defaultLocation: _eventLocation,
      defaultTradition: LocalStorageService.selectedTradition,
    );

    final res = MuhuratService.findMuhurat(
      occasionId: parsed.occasionId ?? 'general_auspicious',
      location: parsed.location,
      startDate: parsed.startDate,
      endDate: parsed.endDate,
      tradition: parsed.tradition,
      preferredWeekdays: parsed.preferredWeekdays,
      earliestHour: parsed.earliestHour,
      latestHour: parsed.latestHour,
    );

    setState(() {
      _eventLocation = parsed.location;
      _selectedOccasionId = parsed.occasionId ?? 'general_auspicious';
      _currentResult = res;
    });
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        List<LocationInfo> filtered = CityDatabase.cities;
        return StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Location (Overrides Current Location)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search city (Ahmedabad, Varanasi, etc.)...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.saffronPrimary),
                    filled: true,
                    fillColor: AppTheme.borderSubtle.withOpacity(0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) {
                    setModalState(() {
                      filtered = CityDatabase.search(val);
                    });
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final city = filtered[idx];
                      return ListTile(
                        leading: const Icon(Icons.location_on, color: AppTheme.saffronPrimary),
                        title: Text(city.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${city.coordinatesString} | IST'),
                        onTap: () {
                          LocationService.setEventLocation(city);
                          setState(() {
                            _eventLocation = city;
                            _runSearch();
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWindowDetail(MuhuratWindow window) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(
              window.status == MuhuratStatus.suitable ? '🟢' : '🟡',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${window.occasionTitle} Muhurat',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${window.formattedDate} · ${window.formattedTiming}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.deepMaroon),
              ),
              Text(
                '📍 Event Location: ${window.location.displayName}',
                style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
              ),
              const Divider(height: 20),

              const Text(
                'Why this window?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.deepText),
              ),
              const SizedBox(height: 6),
              Text(window.simpleExplanation, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),

              ...window.conditionsSatisfied.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✓ ', style: TextStyle(color: AppTheme.suitableGreen, fontWeight: FontWeight.bold)),
                        Expanded(child: Text(c, style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                  )),

              const Divider(height: 20),
              const Text(
                'Calculation Breakdown',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.deepMaroon),
              ),
              const SizedBox(height: 6),
              ...window.detailedExplanation.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.subtleText),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 11, color: AppTheme.deepText),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.alarm_add, size: 18),
            label: const Text('Add Reminder'),
            onPressed: () {
              NotificationService.scheduleMuhuratReminder(
                occasionTitle: window.occasionTitle,
                windowStart: window.start,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder set for ${window.formattedTiming}')),
              );
              Navigator.pop(ctx);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.saffronPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🪔 Muhurat Finder'),
        actions: [
          InkWell(
            onTap: _showLocationPicker,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppTheme.saffronPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppTheme.saffronPrimary),
                  const SizedBox(width: 4),
                  Text(
                    _eventLocation.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.saffronPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Natural Language Search Card (Section 24)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'When do you need a Muhurat?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.deepText),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _queryCtrl,
                  decoration: InputDecoration(
                    hintText: '"Griha Pravesh in Ahmedabad next month"',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: AppTheme.saffronPrimary),
                      onPressed: () => _handleNlpSearch(_queryCtrl.text),
                    ),
                    filled: true,
                    fillColor: AppTheme.borderSubtle.withOpacity(0.2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onSubmitted: _handleNlpSearch,
                ),
                const SizedBox(height: 8),
                // Example chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQueryChip('Griha Pravesh next month'),
                      _buildQueryChip('Vehicle this weekend'),
                      _buildQueryChip('Marriage in Udaipur 2027'),
                      _buildQueryChip('Mundan next year'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Event Location Confirmation Banner (Section 27 & 45)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.saffronPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.pin_drop, size: 18, color: AppTheme.saffronPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '📍 Event location: ${_eventLocation.displayName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.deepMaroon),
                  ),
                ),
                TextButton(
                  onPressed: _showLocationPicker,
                  child: const Text('Change', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Popular Occasions (Section 23 & 51)
          const Text(
            'Popular Occasions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepText),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MuhuratRuleDatabase.allRules.map((rule) {
                final isSelected = rule.id == _selectedOccasionId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${rule.icon} ${rule.title}'),
                    selected: isSelected,
                    selectedColor: AppTheme.saffronPrimary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.deepText,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) _runSearch(overrideOccasion: rule.id);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Muhurat Results Header (Section 28)
          if (_currentResult != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_currentResult!.occasionTitle} Windows',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepText),
                    ),
                    Text(
                      '${_currentResult!.windows.length} suitable windows found',
                      style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // No Results Graceful Fallback (Section 34)
            if (!_currentResult!.hasResults) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No suitable Muhurat found',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.notSuitableRed),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'We couldn\'t find a matching window in ${_eventLocation.name} during this period.',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    const Text('Suggestions to find a window:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    ..._currentResult!.suggestionsIfEmpty.map((s) => Text('• $s', style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ] else ...[
              // Results Windows List
              ..._currentResult!.windows.map((w) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _showWindowDetail(w),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: w.status == MuhuratStatus.suitable
                                  ? const Color(0xFFF0FDF4)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              w.status == MuhuratStatus.suitable ? '🟢' : '🟡',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  w.formattedDate,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  w.formattedTiming,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.deepMaroon,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Duration: ${w.duration.inMinutes} mins',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.subtleText),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildQueryChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          _queryCtrl.text = text;
          _handleNlpSearch(text);
        },
      ),
    );
  }
}
