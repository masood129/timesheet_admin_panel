class User {
  final int userId;
  final String username;
  final String role;
  final int? groupId;
  final String? groupName;
  final String? contractArrivalTime;
  final String? contractLeaveTime;
  final int? minMonthlyHours;
  final List<Project>? projects;

  User({
    required this.userId,
    required this.username,
    required this.role,
    this.groupId,
    this.groupName,
    this.contractArrivalTime,
    this.contractLeaveTime,
    this.minMonthlyHours,
    this.projects,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UserId'] ?? json['userId'],
      username: json['Username'] ?? json['username'],
      role: json['Role'] ?? json['role'],
      groupId: json['GroupId'],
      groupName: json['GroupName'],
      contractArrivalTime: json['ContractArrivalTime'],
      contractLeaveTime: json['ContractLeaveTime'],
      minMonthlyHours: json['MinMonthlyHours'],
      projects: json['Projects'] != null
          ? (json['Projects'] as List).map((p) => Project.fromJson(p)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'Username': username,
      'Role': role,
      'GroupId': groupId,
    };
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
  final int securityLevel;
  final List<User>? users;

  Project({
    required this.id,
    required this.projectName,
    required this.securityLevel,
    this.users,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['Id'] ?? json['id'],
      projectName: json['ProjectName'] ?? json['projectName'],
      securityLevel: json['securityLevel'] ?? 1,
      users: json['Users'] != null
          ? (json['Users'] as List).map((u) => User.fromJson(u)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ProjectName': projectName,
      'securityLevel': securityLevel,
    };
  }
}

class Group {
  final int groupId;
  final String groupName;
  final int? managerId;
  final String? managerName;
  final List<User>? members;

  Group({
    required this.groupId,
    required this.groupName,
    this.managerId,
    this.managerName,
    this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['GroupId'] ?? json['groupId'],
      groupName: json['GroupName'] ?? json['groupName'],
      managerId: json['ManagerId'],
      managerName: json['ManagerName'],
      members: json['Members'] != null
          ? (json['Members'] as List).map((m) => User.fromJson(m)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GroupId': groupId,
      'GroupName': groupName,
      'ManagerId': managerId,
    };
  }
}

class MonthlyReport {
  final int reportId;
  final int userId;
  final String? username;
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
      reportId: json['ReportId'],
      userId: json['UserId'],
      username: json['Username'],
      year: json['Year'],
      month: json['Month'],
      jalaliYear: json['JalaliYear'],
      jalaliMonth: json['JalaliMonth'],
      totalHours: json['TotalHours'],
      gymCost: json['GymCost'],
      status: json['Status'],
      groupId: json['GroupId'],
      generalManagerStatus: json['GeneralManagerStatus'],
      managerComment: json['ManagerComment'],
      financeComment: json['FinanceComment'],
      submittedAt: json['SubmittedAt'] != null
          ? DateTime.parse(json['SubmittedAt'])
          : null,
      approvedAt: json['ApprovedAt'] != null
          ? DateTime.parse(json['ApprovedAt'])
          : null,
    );
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
