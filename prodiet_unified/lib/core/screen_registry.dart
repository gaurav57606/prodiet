/// ═══════════════════════════════════════════════════════════
/// SCREEN LOCK REGISTRY
/// ═══════════════════════════════════════════════════════════
/// Rules:
///   LOCKED     → Screen is final. Do NOT edit the file.
///                Commit message prefix when locking: 🔒 lock:
///   IN_PROGRESS → Actively being worked on.
///   TODO        → Not started yet.
///
/// To lock a screen:
///   1. Change its value below to ScreenStatus.locked
///   2. Commit with message: 🔒 lock: <screen_key>
///   3. Never edit that screen file again without first
///      explicitly unlocking it in a separate commit.
/// ═══════════════════════════════════════════════════════════

enum ScreenStatus { locked, inProgress, todo }

const Map<String, ScreenStatus> screenRegistry = {

  // ── T1  AUTH ───────────────────────────────────────────────
  't1/auth/splash':            ScreenStatus.todo,
  't1/auth/onboarding':        ScreenStatus.todo,
  't1/auth/login':             ScreenStatus.todo,
  't1/auth/signup':            ScreenStatus.todo,
  't1/auth/forgot_password':   ScreenStatus.todo,
  't1/auth/health_goals':      ScreenStatus.todo,
  't1/auth/verify_phone':      ScreenStatus.todo,

  // ── T1  MAIN SCREENS ───────────────────────────────────────
  't1/dashboard':              ScreenStatus.todo,
  't1/today_meals':            ScreenStatus.todo,
  't1/hydration':              ScreenStatus.todo,
  't1/diet_plan':              ScreenStatus.todo,
  't1/meal_planner':           ScreenStatus.todo,
  't1/inventory':              ScreenStatus.todo,
  't1/progress':               ScreenStatus.todo,
  't1/activity_sync':          ScreenStatus.todo,
  't1/nutrition':              ScreenStatus.todo,
  't1/shopping_list':          ScreenStatus.todo,
  't1/ocr_scanner':            ScreenStatus.todo,

  // ── T2  AUTH ───────────────────────────────────────────────
  't2/auth/splash':            ScreenStatus.todo,
  't2/auth/onboarding':        ScreenStatus.todo,
  't2/auth/login':             ScreenStatus.todo,
  't2/auth/signup':            ScreenStatus.todo,

  // ── T2  MAIN SCREENS ───────────────────────────────────────
  't2/dashboard':              ScreenStatus.todo,
  't2/meal_planner':           ScreenStatus.todo,
  't2/diet_plan':              ScreenStatus.todo,
  't2/diet_plan_detail':       ScreenStatus.todo,
  't2/inventory':              ScreenStatus.todo,
  't2/ocr':                    ScreenStatus.todo,
  't2/water':                  ScreenStatus.todo,
  't2/recipe':                 ScreenStatus.todo,
  't2/compensation':           ScreenStatus.todo,
  't2/voice':                  ScreenStatus.todo,
  't2/vendor':                 ScreenStatus.todo,
  't2/fitband':                ScreenStatus.todo,
  't2/preferences':            ScreenStatus.todo,
};
