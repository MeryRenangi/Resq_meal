enum UserRole {
  donor,
  ngo,
  admin;

  String get label => switch (this) {
        UserRole.donor => 'Donor',
        UserRole.ngo => 'NGO',
        UserRole.admin => 'Admin',
      };

  String get description => switch (this) {
        UserRole.donor => 'Share surplus meals with communities in need',
        UserRole.ngo => 'Coordinate pickups and distribute rescued food',
        UserRole.admin => 'Manage platform operations and approvals',
      };

  String get iconName => switch (this) {
        UserRole.donor => 'volunteer_activism',
        UserRole.ngo => 'groups',
        UserRole.admin => 'admin_panel_settings',
      };

  String get storageValue => name;

  static UserRole? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }
}
