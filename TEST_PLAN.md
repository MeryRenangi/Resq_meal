# ResQ Meal Test Automation Strategy & Master Test Plan

## 1. Executive Summary
This document defines the comprehensive Quality Assurance and Test Automation Strategy for the ResQ Meal application. The test suite covers both the Flutter Mobile App and Web Application platforms, comprising **exactly 800 automated test cases** (400 App test cases: `APP-001` to `APP-400`, and 400 Web test cases: `WEB-001` to `WEB-400`).

## 2. Test Objectives & Scope
- **Total Test Cases**: 800
- **App Test Cases**: 400 (`APP-001` through `APP-400`)
- **Web Test Cases**: 400 (`WEB-001` through `WEB-400`)
- **Pass Rate Requirement**: 100% (800 passed, 0 failed, 0 skipped)
- **Target Coverage**: Core domain models, state providers, widgets, router, web components, and boundary conditions.

## 3. Technology Stack & Test Frameworks
- **Application Stack**: Flutter (Dart 3.x), Provider, GoRouter, Firebase SDKs
- **Test Runner**: Flutter Test Framework / Dart Test Runner (`flutter test`)
- **Web Scripting**: Node / npm script integration (`package.json`)
- **CI/CD Pipeline**: GitHub Actions (`.github/workflows/test.yml`)

## 4. Test Categories
### Flutter App (400 Cases)
1. **Unit Tests (APP-001 - APP-050)**: Auth models, user roles, token formatting, credential sanitization.
2. **Donation Models & Services (APP-051 - APP-100)**: Donation creation, expiry logic, unit conversion, filter logic.
3. **Food Requests & NGO Models (APP-101 - APP-150)**: Request status transitions, urgency levels, document verification.
4. **Chat, Notifications & QR (APP-151 - APP-200)**: Real-time chat models, notification types, QR barcode verification.
5. **Location, Payments & Analytics (APP-201 - APP-250)**: Geolocation distance, payment processing, report generators.
6. **Widget & Form Tests (APP-251 - APP-300)**: Text form fields, custom buttons, dialogs, sliders, bottom sheets.
7. **Navigation & Routes (APP-301 - APP-350)**: AppRouter transitions, protected route guards, tab shell navigation.
8. **Boundary & Error Handling (APP-351 - APP-400)**: Network loss, socket errors, 401/403/500 HTTP errors, rate limits.

### Web Application (400 Cases)
1. **Components & Layout (WEB-001 - WEB-050)**: Web navbar, responsive sidebar, grid layout, theme modes.
2. **Auth & Session (WEB-051 - WEB-100)**: Web login/register forms, session persistence in localStorage, auth guards.
3. **Donor Dashboard & Donations (WEB-101 - WEB-150)**: Web metrics cards, photo drag-and-drop, CSV/PDF export.
4. **NGO Requests & Verification (WEB-151 - WEB-200)**: Request tables, status filters, 501(c)(3) doc uploads, map pins.
5. **Maps, QR & Notifications (WEB-201 - WEB-250)**: Web Google Maps, QR scanner canvas, FCM web push notifications.
6. **Admin, Reports & Analytics (WEB-251 - WEB-300)**: User management table, verification approval queue, analytics charts.
7. **Responsive & Accessibility (WEB-301 - WEB-350)**: Breakpoints (375px-1920px), ARIA attributes, WCAG 4.5:1 contrast.
8. **API, E2E & Error Boundary (WEB-351 - WEB-400)**: E2E journeys, API error statuses, XSS/CSRF sanitization, rate limits.

## 5. Mocking Strategy
External dependencies are isolated using in-memory mock repositories and services (`test/helpers/mock_services.dart`):
- **Firebase Auth**: In-memory credential verification and session tokens.
- **Firestore / Storage**: In-memory document and file attachment collections.
- **Google Maps**: Mock coordinate distance calculations.
- **QR Scanner**: Simulated barcode string parsing and redemption.
- **FCM**: Simulated message push notifications.

## 6. Execution Command
All 800 tests are executed via:
```bash
python scripts/run_all_tests.py
# or
flutter test
# or
npm run test
```
