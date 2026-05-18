# RLS SECURITY REPORT

ProDiet Unified employs a **Zero-Trust** database access model using PostgreSQL Row Level Security.

## 1. Global Policies
All tables have RLS enabled. By default, all access is denied unless explicitly permitted by a policy.

## 2. Table-Specific Policies

### `users` table
- **SELECT**: Allowed only for the owning user (`auth.uid() = id`).
- **UPDATE**: Allowed only for the owning user.
- **INSERT/DELETE**: Denied. Handled via Auth triggers or admin bypass.

### `meals` / `water_logs` / `user_devices`
- **SELECT**: Restricted to the owner (`auth.uid() = user_id`).
- **INSERT**: Enforced via `with check (auth.uid() = user_id)`. Users cannot insert records for other users.
- **UPDATE**: Restricted to the owner.
- **DELETE**: Restricted to the owner.

## 3. Storage Security
- **OCR Bucket**: RLS policy ensures users can only upload to and read from their own folder (`/ocr/{auth.uid()}/*`).
- **Profile Bucket**: Read access is public (cached via CDN), but write access is restricted to the owning user.

## 4. Security Audit Recommendations
1. Periodically check for any table without `enable row level security`.
2. Review policies if any "Collaborative" or "Shared" features are added.
3. Ensure Service Role keys are NEVER used in the Flutter application.
