// ═══════════════════════════════════════════════════════════════
// SCREEN LOCK REGISTRY
// ═══════════════════════════════════════════════════════════════
// Rules:
//   locked      → Screen is final. Do NOT edit its file.
//                 Commit prefix when locking: 🔒 lock:
//   inProgress  → Actively being worked on.
//   todo        → Not started yet.
//
// To lock a screen:
//   1. Change its value below to ScreenStatus.locked
//   2. Commit: 🔒 lock: <screen_key>
//   3. Never touch that screen file again without first
//      changing it back to inProgress in a separate commit.
// ═══════════════════════════════════════════════════════════════

enum ScreenStatus { locked, inProgress, todo }

const Map<String, ScreenStatus> screenRegistry = {

  // ── T1  AUTH ─────────────────────────────────────────────────
  't1/auth/splash':            ScreenStatus.locked,
  't1/auth/onboarding':        ScreenStatus.locked,
  't1/auth/login':             ScreenStatus.locked,
  't1/auth/signup':            ScreenStatus.locked,
  't1/auth/forgot_password':   ScreenStatus.locked,
  't1/auth/health_goals':      ScreenStatus.locked,
  't1/auth/verify_phone':      ScreenStatus.locked,

  // ── T1  MAIN SCREENS ─────────────────────────────────────────
  't1/dashboard':              ScreenStatus.locked,
  't1/today_meals':            ScreenStatus.locked,
  't1/hydration':              ScreenStatus.locked,
  't1/diet_plan':              ScreenStatus.locked,
  't1/meal_planner':           ScreenStatus.locked,
  't1/inventory':              ScreenStatus.locked,
  't1/progress':               ScreenStatus.locked,
  't1/activity_sync':          ScreenStatus.locked,
  't1/nutrition':              ScreenStatus.locked,
  't1/shopping_list':          ScreenStatus.locked,
  't1/ocr_scanner':            ScreenStatus.locked,

  // ── T2  AUTH ─────────────────────────────────────────────────
  't2/auth/splash':            ScreenStatus.locked,
  't2/auth/onboarding':        ScreenStatus.locked,
  't2/auth/login':             ScreenStatus.locked,
  't2/auth/signup':            ScreenStatus.locked,

  // ── T2  MAIN SCREENS ─────────────────────────────────────────
  't2/dashboard':              ScreenStatus.locked,
  't2/meal_planner':           ScreenStatus.locked,
  't2/diet_plan':              ScreenStatus.locked,
  't2/diet_plan_detail':       ScreenStatus.locked,
  't2/inventory':              ScreenStatus.locked,
  't2/ocr':                    ScreenStatus.locked,
  't2/water':                  ScreenStatus.locked,
  't2/recipe':                 ScreenStatus.inProgress,
  't2/compensation':           ScreenStatus.locked,
  't2/voice':                  ScreenStatus.inProgress,
  't2/vendor':                 ScreenStatus.locked,
  't2/fitband':                ScreenStatus.locked,
  't2/preferences':            ScreenStatus.locked,
};
