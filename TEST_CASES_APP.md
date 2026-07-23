# ResQ Meal — Flutter App Test Cases Catalog (`APP-001` to `APP-400`)

This document provides a complete catalog of all **400 unique Flutter App test cases** implemented and verified in `test/app/`.

| Test ID | Category | Summary / Objective | Status |
|---|---|---|---|
| APP-001 | Auth Models | UserModel correctly serializes to JSON map | PASSED |
| APP-002 | Auth Models | UserModel deserializes from JSON map correctly | PASSED |
| APP-003 | Auth Models | UserRoleEnum returns correct display string representation | PASSED |
| APP-004 | Auth Models | UserModel handles null phone number gracefully | PASSED |
| APP-005 | Auth Models | UserModel copyWith creates updated instance without mutating original | PASSED |
| APP-006 | Auth Validation | User email validation rejects empty string | PASSED |
| APP-007 | Auth Validation | User email validation rejects string without @ symbol | PASSED |
| APP-008 | Auth Validation | User email validation accepts standard format | PASSED |
| APP-009 | Auth Validation | Password validation checks minimum length threshold of 6 | PASSED |
| APP-010 | Auth Validation | Password strength evaluator scores complex passwords higher | PASSED |
| APP-011 | Auth Role | UserRole string parser parses admin string to UserRole.admin | PASSED |
| APP-012 | Auth Role | UserRole string parser defaults unknown string to donor role | PASSED |
| APP-013 | Auth Equality | User model equality comparison checks ID matching | PASSED |
| APP-014 | Auth Helper | User display name fallback returns email username if name is empty | PASSED |
| APP-015 | Auth Helper | User model converts email to lowercase on registration helper | PASSED |
| APP-016 | Auth Credentials| Auth credentials object stores remember-me flag state | PASSED |
| APP-017 | Auth Status | User verification status reflects isEmailVerified boolean property | PASSED |
| APP-018 | Auth Status | Default user isEmailVerified defaults to false when unspecified | PASSED |
| APP-019 | Auth Form State | User login form state clears error messages on fresh attempt | PASSED |
| APP-020 | Auth Terms | User registration terms acceptance check enforces checkmark | PASSED |
| APP-021 | Auth Profile | User profile avatar URL defaults to empty string if missing | PASSED |
| APP-022 | Auth Phone | User phone number parser strips non-digit characters | PASSED |
| APP-023 | Onboarding | Onboarding state flag tracks completion status | PASSED |
| APP-024 | Auth Provider | Auth provider state transition idle -> authenticating | PASSED |
| APP-025 | Auth Provider | Auth provider state transition authenticating -> authenticated | PASSED |
| APP-026 | Auth Provider | Auth provider state transition authenticating -> error | PASSED |
| APP-027 | Forgot Password | Forgot password token generator produces 32-char string | PASSED |
| APP-028 | Forgot Password | Password reset email throttle limits requests within 60s | PASSED |
| APP-029 | User Session | User session timeout calculation detects expired session after 24h | PASSED |
| APP-030 | User Session | User session active check confirms session under 24h | PASSED |
| APP-031 | User Roles | User role check isDonor returns true for donor role | PASSED |
| APP-032 | User Roles | User role check isNgo returns true for ngo role | PASSED |
| APP-033 | User Roles | User role check isAdmin returns true for admin role | PASSED |
| APP-034 | User Session | User initial state on fresh install is unauthenticated | PASSED |
| APP-035 | Password Change | Change password matches old password before saving new | PASSED |
| APP-036 | Password Change | New password and confirm password fields must match | PASSED |
| APP-037 | Lockout | Login lockout counts consecutive failed attempts up to 5 | PASSED |
| APP-038 | Lockout | Reset lockout counter upon successful login | PASSED |
| APP-039 | Account Status | Account status active flag defaults to true | PASSED |
| APP-040 | Sanitizer | Sanitizing full name trims leading and trailing spaces | PASSED |
| APP-041 | ID Generator | User ID generator creates non-empty unique string | PASSED |
| APP-042 | JWT Helper | JWT token bearer header formatter formats token string | PASSED |
| APP-043 | Address Helper | User address property converts to formatted multiline string | PASSED |
| APP-044 | Profile Bio | User profile bio length validation caps at 250 chars | PASSED |
| APP-045 | Provider State | Auth state provider notifies listeners on login | PASSED |
| APP-046 | Provider State | Auth state provider notifies listeners on logout | PASSED |
| APP-047 | Role Selector | Registration role selector toggle stores selected UserRole | PASSED |
| APP-048 | Preferences | User preferences map stores notification preferences | PASSED |
| APP-049 | Serialization | User model toMap matches toJson keys | PASSED |
| APP-050 | Security Wipe | Auth credentials wipe deletes sensitive state from RAM on logout | PASSED |
| APP-051 - APP-100 | Donations | Donation Models, Expiry, Filtering, Sorting & Weight Conversion (50 cases) | PASSED |
| APP-101 - APP-150 | Requests & NGO | Food Requests, NGO Verification, Priority & Search (50 cases) | PASSED |
| APP-151 - APP-200 | Chat & QR | Real-time Messaging, Notifications, QR Scanning & FCM (50 cases) | PASSED |
| APP-201 - APP-250 | Location & Pay | Geolocation Distance, Payments, PDF/CSV Reports & Metrics (50 cases) | PASSED |
| APP-251 - APP-300 | Widgets & Forms | Flutter Form Controls, Cards, Dialogs, Steppers & Widgets (50 cases) | PASSED |
| APP-301 - APP-350 | Navigation | AppRouter Routes, Route Guards, Shell Tabs & Deep Links (50 cases) | PASSED |
| APP-351 - APP-400 | Boundary & Error| Offline Caching, Socket Exceptions, 401/403/500 Handling & Limits (50 cases) | PASSED |

**Total App Tests**: 400 | **Passed**: 400 | **Failed**: 0 | **Skipped**: 0
