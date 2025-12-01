export 'dashboard_settings.dart';

class User {
  final int userId;
  final String username;
  final String? farsifirstname;
  final String? farsilastname;
  final String? email;
  final String role;
  final int? groupId;
  final String? groupName;
  final bool isActive;
  final String? directAdmin;
  final int? directAdminid;
  final String? contractArrivalTime;
  final String? contractLeaveTime;
  final int? minMonthlyHours;
  final List<Project>? projects;

  User({
    required this.userId,
    required this.username,
    this.farsifirstname,
    this.farsilastname,
    this.email,
    required this.role,
    this.groupId,
    this.groupName,
    this.isActive = true,
    this.directAdmin,
    this.directAdminid,
    this.contractArrivalTime,
    this.contractLeaveTime,
    this.minMonthlyHours,
    this.projects,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['personalid'] as int? ?? 0,
      username: (json['username'] ?? json['id']) as String? ?? '',
      farsifirstname: json['farsifirstname'] as String?,
      farsilastname: json['farsilastname'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'user',
      groupId: json['groupid'] as int?,
      groupName: json['groupname'] as String?,
      isActive: json['IsActive'] as bool? ?? true,
      directAdmin: json['directAdmin'] as String?,
      directAdminid: json['directAdminid'] as int?,
      contractArrivalTime: json['ContractArrivalTime'] as String?,
      contractLeaveTime: json['ContractLeaveTime'] as String?,
      minMonthlyHours: json['MinMonthlyHours'] as int?,
      projects: json['Projects'] != null
          ? (json['Projects'] as List).map((p) => Project.fromJson(p)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalid': userId,
      'id': username,
      'farsifirstname': farsifirstname,
      'farsilastname': farsilastname,
      'email': email,
      'role': role,
      'groupid': groupId,
      'IsActive': isActive,
    };
  }

  String get fullName {
    if (farsifirstname != null && farsilastname != null) {
      return '$farsifirstname $farsilastname';
    }
    return username;
  }

  String get roleDisplay {
    switch (role) {
      case 'admin':
        return 'ادمین';
      case 'general_manager':
        return 'مدیر کل';
      case 'finance_manager':
        return 'مدیر مالی';
      case 'group_manager':
        return 'مدیر گروه';
      case 'user':
        return 'کاربر';
      default:
        return role;
    }
  }
}

class Project {
  final int id;
  final String projectName;
  final bool isActive;
  final List<User>? users;

  Project({
    required this.id,
    required this.projectName,
    this.isActive = true,
    this.users,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int? ?? 0,
      projectName: json['projectName'] as String? ?? '',
      isActive: json['IsActive'] as bool? ?? 
                (json['isActive'] as bool? ?? true),
      users: json['Users'] != null
          ? (json['Users'] as List).map((u) => User.fromJson(u)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
      'IsActive': isActive,
    };
  }
}

class Group {
  final int groupId;
  final String groupName;
  final int? managerId;
  final String? managerName;
  final String? managerUsername;
  final List<User>? members;

  Group({
    required this.groupId,
    required this.groupName,
    this.managerId,
    this.managerName,
    this.managerUsername,
    this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['id'] as int? ?? 0,
      groupName: json['groupname'] as String? ?? '',
      managerId: json['managerID'] as int?,
      managerName: json['managerName'] as String?,
      managerUsername: json['managerUsername'] as String?,
      members: json['Members'] != null
          ? (json['Members'] as List).map((m) => User.fromJson(m)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': groupId,
      'groupname': groupName,
      'managerID': managerId,
    };
  }
}

class MonthlyReport {
  final int reportId;
  final int userId;
  final String? username;
  final String? farsifirstname;
  final String? farsilastname;
  final int year;
  final int month;
  final int jalaliYear;
  final int jalaliMonth;
  final int totalHours;
  final int gymCost;
  final String status;
  final int? groupId;
  final String? generalManagerStatus;
  final String? managerComment;
  final String? financeComment;
  final DateTime? submittedAt;
  final DateTime? approvedAt;

  MonthlyReport({
    required this.reportId,
    required this.userId,
    this.username,
    this.farsifirstname,
    this.farsilastname,
    required this.year,
    required this.month,
    required this.jalaliYear,
    required this.jalaliMonth,
    required this.totalHours,
    required this.gymCost,
    required this.status,
    this.groupId,
    this.generalManagerStatus,
    this.managerComment,
    this.financeComment,
    this.submittedAt,
    this.approvedAt,
  });

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      reportId: json['ReportId'] as int,
      userId: json['UserId'] as int,
      username: json['username'] as String?,
      farsifirstname: json['farsifirstname'] as String?,
      farsilastname: json['farsilastname'] as String?,
      year: json['Year'] as int,
      month: json['Month'] as int,
      jalaliYear: json['JalaliYear'] as int,
      jalaliMonth: json['JalaliMonth'] as int,
      totalHours: json['TotalHours'] as int,
      gymCost: json['GymCost'] as int,
      status: json['Status'] as String,
      groupId: json['GroupId'] as int?,
      generalManagerStatus: json['GeneralManagerStatus'] as String?,
      managerComment: json['ManagerComment'] as String?,
      financeComment: json['FinanceComment'] as String?,
      submittedAt: json['SubmittedAt'] != null
          ? DateTime.parse(json['SubmittedAt'])
          : null,
      approvedAt: json['ApprovedAt'] != null
          ? DateTime.parse(json['ApprovedAt'])
          : null,
    );
  }

  String get userFullName {
    if (farsifirstname != null && farsilastname != null) {
      return '$farsifirstname $farsilastname';
    }
    return username ?? 'نامشخص';
  }

  String get statusDisplay {
    switch (status) {
      case 'draft':
        return 'پیش‌نویس';
      case 'submitted_to_group_manager':
        return 'ارسال به مدیر گروه';
      case 'submitted_to_general_manager':
        return 'ارسال به مدیر کل';
      case 'submitted_to_finance':
        return 'ارسال به مالی';
      case 'approved':
        return 'تایید شده';
      default:
        return status;
    }
  }
}

class SystemStatistics {
  final int totalUsers;
  final int totalProjects;
  final int totalGroups;
  final int pendingReports;
  final int approvedReports;
  final List<RoleCount> usersByRole;
  final int recentActivityCount;

  SystemStatistics({
    required this.totalUsers,
    required this.totalProjects,
    required this.totalGroups,
    required this.pendingReports,
    required this.approvedReports,
    required this.usersByRole,
    required this.recentActivityCount,
  });

  factory SystemStatistics.fromJson(Map<String, dynamic> json) {
    return SystemStatistics(
      totalUsers: json['totalUsers'],
      totalProjects: json['totalProjects'],
      totalGroups: json['totalGroups'],
      pendingReports: json['pendingReports'],
      approvedReports: json['approvedReports'],
      usersByRole: (json['usersByRole'] as List)
          .map((r) => RoleCount.fromJson(r))
          .toList(),
      recentActivityCount: json['recentActivityCount'],
    );
  }
}

class RoleCount {
  final String role;
  final int count;

  RoleCount({required this.role, required this.count});

  factory RoleCount.fromJson(Map<String, dynamic> json) {
    return RoleCount(
      role: json['Role'] ?? json['role'],
      count: json['count'],
    );
  }
}

class ContractHours {
  final int userId;
  final String? username;
  final String? contractArrivalTime;
  final String contractLeaveTime;
  final int minMonthlyHours;

  ContractHours({
    required this.userId,
    this.username,
    this.contractArrivalTime,
    required this.contractLeaveTime,
    required this.minMonthlyHours,
  });

  factory ContractHours.fromJson(Map<String, dynamic> json) {
    return ContractHours(
      userId: json['UserId'],
      username: json['Username'],
      contractArrivalTime: json['ContractArrivalTime'],
      contractLeaveTime: json['ContractLeaveTime'],
      minMonthlyHours: json['MinMonthlyHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ContractArrivalTime': contractArrivalTime,
      'ContractLeaveTime': contractLeaveTime,
      'MinMonthlyHours': minMonthlyHours,
    };
  }
}