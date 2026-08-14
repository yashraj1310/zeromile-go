import 'package:flutter/material.dart';
import '../models/domain_models.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _initData();
  }

  // Theme Mode State
  ThemeMode themeMode = ThemeMode.dark;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Pre-configured Domains
  late List<EventDomain> domains;
  late EventDomain currentDomain;

  // Sub-groups per domain
  late List<SubGroup> subGroups;
  String? activeSubGroupId;
  List<String> joinedSubGroupIds = [];

  // Emergency SOS Events (Handled by SuperAdmin & Leaders, NOT sent to Police)
  List<SosEvent> sosEvents = [];

  // Broadcasts (General & Sub-Group)
  List<BroadcastMessage> broadcasts = [];

  // Police Traffic Advisories
  List<String> policeAdvisories = [
    '🟢 Wardha Road Flyover: Clear for general traffic.',
    '🟡 Shankar Nagar Square: Lead pack approaching in 4 mins. Temporary hold on north-bound lane.',
    '🔴 Law College Square: Diversion in place towards Ram Nagar.',
  ];

  // Route Checkpoints
  List<RouteCheckpoint> checkpoints = [];

  // Group Creation Requests
  List<GroupCreationRequest> groupRequests = [];

  // SuperAdmins Provisioned (Dev Panel)
  Map<String, List<String>> domainSuperAdmins = {};

  // Temporal Simulation Toggle (Force Live Active vs Outside Window)
  bool forceLiveWindow = true;

  void _initData() {
    final now = DateTime.now();

    domains = [
      EventDomain(
        id: 'domain-cycling-2026',
        name: 'Nagpur Cycling Rally 2026',
        slug: 'cycling-2026',
        type: DomainType.cycling,
        status: DomainStatus.liveActive,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now.add(const Duration(hours: 4)),
        routeSummary: '24.5 km • Zero Mile Monument to Deekshabhoomi Loop',
      ),
      EventDomain(
        id: 'domain-marathon-2026',
        name: 'Nagpur City Marathon',
        slug: 'marathon-2026',
        type: DomainType.marathon,
        status: DomainStatus.upcoming,
        startTime: now.add(const Duration(days: 2)),
        endTime: now.add(const Duration(days: 2, hours: 5)),
        routeSummary: '42.2 km Full & 21.1 km Half Marathon • Civil Lines',
      ),
      EventDomain(
        id: 'domain-protest-2026',
        name: 'Citizen Peace & Civic Rally',
        slug: 'peace-rally-2026',
        type: DomainType.protest,
        status: DomainStatus.liveActive,
        startTime: now.subtract(const Duration(minutes: 30)),
        endTime: now.add(const Duration(hours: 2)),
        routeSummary: '8.0 km • Samvidhan Square to RBI Square March',
      ),
      EventDomain(
        id: 'domain-walkathon-2026',
        name: 'Green Nagpur Eco Walkathon',
        slug: 'eco-walk-2026',
        type: DomainType.walkathon,
        status: DomainStatus.concluded,
        startTime: now.subtract(const Duration(days: 1, hours: 4)),
        endTime: now.subtract(const Duration(days: 1)),
        routeSummary: '10.0 km • Futala Lake Promenade Circuit',
      ),
    ];

    currentDomain = domains[0];

    subGroups = [
      const SubGroup(
        id: 'group-general',
        domainId: 'domain-cycling-2026',
        name: 'General Group (Mandatory Domain-Wide)',
        isGeneral: true,
        orgCategory: OrgCategory.grassroots,
        leaderId: 'admin-1',
        leaderName: 'Nagpur Civic Admin',
        leaderPhone: '+91 712-2567000',
        musterPoint: 'Zero Mile Monument, Civil Lines',
        memberCount: 1248,
      ),
      const SubGroup(
        id: 'group-vnit-riders',
        domainId: 'domain-cycling-2026',
        name: 'VNIT Cycling Club',
        isGeneral: false,
        orgCategory: OrgCategory.collegeUnion,
        leaderId: 'user-rajesh',
        leaderName: 'Rajesh Sharma (You / Leader)',
        leaderPhone: '+91 98230-12345',
        musterPoint: 'Ambazari Gate, South Campus',
        memberCount: 38,
      ),
      const SubGroup(
        id: 'group-orange-sprinters',
        domainId: 'domain-cycling-2026',
        name: 'Orange City Sprinters Club',
        isGeneral: false,
        orgCategory: OrgCategory.sportsClub,
        leaderId: 'user-neha',
        leaderName: 'Neha Verma',
        leaderPhone: '+91 98230-67890',
        musterPoint: 'Shankar Nagar Square',
        memberCount: 28,
      ),
      const SubGroup(
        id: 'group-mahadiscom-riders',
        domainId: 'domain-cycling-2026',
        name: 'MSEDCL Employees Contingent',
        isGeneral: false,
        orgCategory: OrgCategory.corporateTeam,
        leaderId: 'user-anil',
        leaderName: 'Anil Kulkarni',
        leaderPhone: '+91 98230-55555',
        musterPoint: 'Katol Road Square',
        memberCount: 45,
      ),
    ];

    joinedSubGroupIds = ['group-vnit-riders', 'group-orange-sprinters'];
    activeSubGroupId = 'group-vnit-riders';

    sosEvents = [
      SosEvent(
        id: 'sos-101',
        domainId: 'domain-cycling-2026',
        senderUserId: 'user-priya',
        senderName: 'Priya Verma',
        senderPhone: '+91 98221-44321',
        activeSubGroupId: 'group-vnit-riders',
        activeSubGroupName: 'VNIT Cycling Club',
        emergencyType: SosEmergencyType.medical,
        latitude: 21.1458,
        longitude: 79.0882,
        status: SosStatus.triggered,
        leaderNotes: 'Heat exhaustion, needs hydration and escort van.',
        createdAt: now.subtract(const Duration(minutes: 6)),
      ),
      SosEvent(
        id: 'sos-102',
        domainId: 'domain-cycling-2026',
        senderUserId: 'user-amit',
        senderName: 'Amit Raut (General User)',
        senderPhone: '+91 98234-99887',
        activeSubGroupId: null,
        activeSubGroupName: 'General Group',
        emergencyType: SosEmergencyType.breakdown,
        latitude: 21.1320,
        longitude: 79.0710,
        status: SosStatus.forwardedToAdmin,
        leaderNotes: 'Broken chain at Law College Square.',
        createdAt: now.subtract(const Duration(minutes: 18)),
      ),
    ];

    broadcasts = [
      BroadcastMessage(
        id: 'bc-1',
        domainId: 'domain-cycling-2026',
        senderName: 'SuperAdmin Command',
        senderRole: 'SUPERADMIN',
        isGeneral: true,
        messageText: '🚨 Flag-off completed at Zero Mile! Lead pack crossing Shankar Nagar. Ride safely on left lanes.',
        createdAt: now.subtract(const Duration(minutes: 25)),
      ),
      BroadcastMessage(
        id: 'bc-2',
        domainId: 'domain-cycling-2026',
        senderName: 'Rajesh Sharma (Leader)',
        senderRole: 'GROUP_LEADER',
        isGeneral: false,
        targetGroupName: 'VNIT Cycling Club',
        messageText: '📣 VNIT Club: Regroup at Water Point #1 (Shankar Nagar) before heading towards Deekshabhoomi.',
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
    ];

    checkpoints = [
      const RouteCheckpoint(
        id: 'cp-1',
        domainId: 'domain-cycling-2026',
        type: CheckpointType.start,
        name: '🚩 Zero Mile Monument (Start Point)',
        latitude: 21.1485,
        longitude: 79.0849,
        sequenceOrder: 1,
      ),
      const RouteCheckpoint(
        id: 'cp-2',
        domainId: 'domain-cycling-2026',
        type: CheckpointType.waterStation,
        name: '💧 Shankar Nagar Water Station (Km 4.5)',
        latitude: 21.1340,
        longitude: 79.0680,
        sequenceOrder: 2,
      ),
      const RouteCheckpoint(
        id: 'cp-3',
        domainId: 'domain-cycling-2026',
        type: CheckpointType.medicalPost,
        name: '🚑 Law College Square Medical Aid Tent (Km 9.2)',
        latitude: 21.1410,
        longitude: 79.0550,
        sequenceOrder: 3,
      ),
      const RouteCheckpoint(
        id: 'cp-4',
        domainId: 'domain-cycling-2026',
        type: CheckpointType.diversion,
        name: '⛔ WHC Road North Bound Traffic Diversion',
        latitude: 21.1290,
        longitude: 79.0610,
        sequenceOrder: 4,
      ),
      const RouteCheckpoint(
        id: 'cp-5',
        domainId: 'domain-cycling-2026',
        type: CheckpointType.finish,
        name: '🏁 Deekshabhoomi Ground Pavilion (Finish Line)',
        latitude: 21.1270,
        longitude: 79.0705,
        sequenceOrder: 5,
      ),
    ];

    groupRequests = [
      GroupCreationRequest(
        id: 'req-1',
        domainId: 'domain-cycling-2026',
        applicantName: 'Anjali Deshmukh',
        applicantPhone: '+91 98223-11223',
        orgName: 'Nagpur Citizen Front Contingent',
        orgCategory: OrgCategory.ngoCivilSociety,
        expectedCount: 75,
        musterPoint: 'Samvidhan Square, Nagpur',
        leaderNotes: 'Civic youth group promoting green mobility and pedestrian safety.',
        status: 'PENDING',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ];

    domainSuperAdmins = {
      'domain-cycling-2026': [
        'Dr. Manoj Tiwari (+91 98220-11111)',
        'Sneha Kulkarni (+91 98220-22222)',
        'Inspector R. Gadge (+91 98220-33333)',
        'Prof. V. Agrawal (+91 98220-44444)',
        'Amitabh Joshi (+91 98220-55555)',
      ],
      'domain-marathon-2026': [
        'Col. S. Deshpande (+91 98221-11111)',
        'Dr. Pooja Rao (+91 98221-22222)',
      ],
      'domain-protest-2026': [
        'Adv. Sanjay Patil (+91 98222-11111)',
      ],
    };
  }

  // Multi-Domain Operations
  void switchDomain(EventDomain domain) {
    currentDomain = domain;
    notifyListeners();
  }

  void toggleTemporalSimulation() {
    forceLiveWindow = !forceLiveWindow;
    notifyListeners();
  }

  bool get isCurrentDomainLive {
    if (!forceLiveWindow) return false;
    return currentDomain.isLiveActive;
  }

  SubGroup? get activeSubGroup {
    if (activeSubGroupId == null) return null;
    try {
      return subGroups.firstWhere((g) => g.id == activeSubGroupId);
    } catch (_) {
      return null;
    }
  }

  void setActiveGroup(String groupId) {
    if (joinedSubGroupIds.contains(groupId)) {
      activeSubGroupId = groupId;
      notifyListeners();
    }
  }

  bool joinSubGroup(String groupId) {
    if (joinedSubGroupIds.length >= 3) return false;
    if (!joinedSubGroupIds.contains(groupId)) {
      joinedSubGroupIds.add(groupId);
      if (activeSubGroupId == null) {
        activeSubGroupId = groupId;
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void leaveSubGroup(String groupId) {
    joinedSubGroupIds.remove(groupId);
    if (activeSubGroupId == groupId) {
      activeSubGroupId = joinedSubGroupIds.isNotEmpty ? joinedSubGroupIds.first : null;
    }
    notifyListeners();
  }

  // Emergency SOS Trigger (Note: SOS is NOT routed to Traffic Police)
  void triggerSos({
    required SosEmergencyType type,
    required double lat,
    required double lng,
    String? note,
  }) {
    final active = activeSubGroup;
    final newSos = SosEvent(
      id: 'sos-${DateTime.now().millisecondsSinceEpoch}',
      domainId: currentDomain.id,
      senderUserId: 'user-current',
      senderName: 'Rajesh Sharma (You)',
      senderPhone: '+91 98230-12345',
      activeSubGroupId: active?.id,
      activeSubGroupName: active?.name ?? 'General Group',
      emergencyType: type,
      latitude: lat,
      longitude: lng,
      status: SosStatus.triggered,
      leaderNotes: note,
      createdAt: DateTime.now(),
    );

    sosEvents.insert(0, newSos);
    notifyListeners();
  }

  void resolveSos(String sosId) {
    final index = sosEvents.indexWhere((s) => s.id == sosId);
    if (index != -1) {
      final old = sosEvents[index];
      sosEvents[index] = SosEvent(
        id: old.id,
        domainId: old.domainId,
        senderUserId: old.senderUserId,
        senderName: old.senderName,
        senderPhone: old.senderPhone,
        activeSubGroupId: old.activeSubGroupId,
        activeSubGroupName: old.activeSubGroupName,
        emergencyType: old.emergencyType,
        latitude: old.latitude,
        longitude: old.longitude,
        status: SosStatus.resolved,
        forwardedByLeaderId: old.forwardedByLeaderId,
        leaderNotes: old.leaderNotes,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  void forwardSosToAdmin(String sosId, String escalationNote) {
    final index = sosEvents.indexWhere((s) => s.id == sosId);
    if (index != -1) {
      final old = sosEvents[index];
      sosEvents[index] = SosEvent(
        id: old.id,
        domainId: old.domainId,
        senderUserId: old.senderUserId,
        senderName: old.senderName,
        senderPhone: old.senderPhone,
        activeSubGroupId: old.activeSubGroupId,
        activeSubGroupName: old.activeSubGroupName,
        emergencyType: old.emergencyType,
        latitude: old.latitude,
        longitude: old.longitude,
        status: SosStatus.forwardedToAdmin,
        forwardedByLeaderId: 'user-rajesh',
        leaderNotes: escalationNote,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  void sendBroadcast({
    required String text,
    required bool isGeneral,
    String? targetGroupName,
    required String senderRole,
  }) {
    final newBc = BroadcastMessage(
      id: 'bc-${DateTime.now().millisecondsSinceEpoch}',
      domainId: currentDomain.id,
      senderName: senderRole == 'SUPERADMIN' ? 'SuperAdmin Command' : 'Rajesh Sharma (Leader)',
      senderRole: senderRole,
      isGeneral: isGeneral,
      targetGroupName: targetGroupName,
      messageText: text,
      createdAt: DateTime.now(),
    );
    broadcasts.insert(0, newBc);
    notifyListeners();
  }

  // Police Traffic Advisories
  void addPoliceAdvisory(String advisory) {
    policeAdvisories.insert(0, advisory);
    notifyListeners();
  }

  void submitGroupRequest(GroupCreationRequest request) {
    groupRequests.insert(0, request);
    notifyListeners();
  }

  void approveGroupRequest(String reqId) {
    final index = groupRequests.indexWhere((r) => r.id == reqId);
    if (index != -1) {
      final req = groupRequests[index];
      final newGroup = SubGroup(
        id: 'group-${DateTime.now().millisecondsSinceEpoch}',
        domainId: req.domainId,
        name: req.orgName,
        orgCategory: req.orgCategory,
        leaderId: 'applicant-${req.id}',
        leaderName: req.applicantName,
        leaderPhone: req.applicantPhone,
        musterPoint: req.musterPoint,
        memberCount: req.expectedCount,
        isApproved: true,
      );
      subGroups.add(newGroup);
      groupRequests.removeAt(index);
      notifyListeners();
    }
  }

  void rejectGroupRequest(String reqId) {
    groupRequests.removeWhere((r) => r.id == reqId);
    notifyListeners();
  }

  void addSuperAdmin(String domainId, String adminDetails) {
    domainSuperAdmins.putIfAbsent(domainId, () => []);
    if (domainSuperAdmins[domainId]!.length < 6) {
      domainSuperAdmins[domainId]!.add(adminDetails);
      notifyListeners();
    }
  }
}
