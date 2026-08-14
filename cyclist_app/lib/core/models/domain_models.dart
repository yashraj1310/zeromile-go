enum DomainType {
  cycling,
  marathon,
  protest,
  walkathon,
  parade,
}

enum DomainStatus {
  upcoming,
  liveActive,
  concluded,
  archived,
}

enum OrgCategory {
  collegeUnion,
  ngoCivilSociety,
  laborUnion,
  corporateTeam,
  residentWelfareAssoc,
  sportsClub,
  schoolContingent,
  grassroots,
}

enum SosEmergencyType {
  medical,
  breakdown,
  threat,
}

enum SosStatus {
  triggered,
  forwardedToAdmin,
  resolved,
}

enum CheckpointType {
  start,
  waterStation,
  medicalPost,
  diversion,
  finish,
}

class EventDomain {
  final String id;
  final String name;
  final String slug;
  final DomainType type;
  final DomainStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final String routeSummary;

  const EventDomain({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.routeSummary,
  });

  bool get isLiveActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
}

class SubGroup {
  final String id;
  final String domainId;
  final String name;
  final bool isGeneral;
  final OrgCategory orgCategory;
  final String leaderId;
  final String leaderName;
  final String leaderPhone;
  final String musterPoint;
  final int memberCount;
  final bool isApproved;

  const SubGroup({
    required this.id,
    required this.domainId,
    required this.name,
    this.isGeneral = false,
    required this.orgCategory,
    required this.leaderId,
    required this.leaderName,
    required this.leaderPhone,
    required this.musterPoint,
    required this.memberCount,
    this.isApproved = true,
  });
}

class SosEvent {
  final String id;
  final String domainId;
  final String senderUserId;
  final String senderName;
  final String senderPhone;
  final String? activeSubGroupId;
  final String? activeSubGroupName;
  final SosEmergencyType emergencyType;
  final double latitude;
  final double longitude;
  final SosStatus status;
  final String? forwardedByLeaderId;
  final String? leaderNotes;
  final DateTime createdAt;

  const SosEvent({
    required this.id,
    required this.domainId,
    required this.senderUserId,
    required this.senderName,
    required this.senderPhone,
    this.activeSubGroupId,
    this.activeSubGroupName,
    required this.emergencyType,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.forwardedByLeaderId,
    this.leaderNotes,
    required this.createdAt,
  });
}

class BroadcastMessage {
  final String id;
  final String domainId;
  final String senderName;
  final String senderRole; // 'SUPERADMIN' or 'GROUP_LEADER'
  final bool isGeneral;
  final String? targetGroupName;
  final String messageText;
  final DateTime createdAt;

  const BroadcastMessage({
    required this.id,
    required this.domainId,
    required this.senderName,
    required this.senderRole,
    required this.isGeneral,
    this.targetGroupName,
    required this.messageText,
    required this.createdAt,
  });
}

class RouteCheckpoint {
  final String id;
  final String domainId;
  final CheckpointType type;
  final String name;
  final double latitude;
  final double longitude;
  final int sequenceOrder;

  const RouteCheckpoint({
    required this.id,
    required this.domainId,
    required this.type,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sequenceOrder,
  });
}

class GroupCreationRequest {
  final String id;
  final String domainId;
  final String applicantName;
  final String applicantPhone;
  final String orgName;
  final OrgCategory orgCategory;
  final int expectedCount;
  final String musterPoint;
  final String? leaderNotes;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final DateTime createdAt;

  const GroupCreationRequest({
    required this.id,
    required this.domainId,
    required this.applicantName,
    required this.applicantPhone,
    required this.orgName,
    required this.orgCategory,
    required this.expectedCount,
    required this.musterPoint,
    this.leaderNotes,
    this.status = 'PENDING',
    required this.createdAt,
  });
}
