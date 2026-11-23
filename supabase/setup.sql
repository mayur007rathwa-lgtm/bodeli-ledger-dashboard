-- Bodeli Division Ledger Dashboard - Supabase setup.
-- 1) Replace ADMIN_EMAIL_HERE (4 places) with the Division admin's login email.
-- 2) Paste everything in Supabase > SQL Editor > New query, and press Run.

-- Private storage bucket for the master file.
insert into storage.buckets (id, name, public)
values ('ledger', 'ledger', false)
on conflict (id) do nothing;

-- Everyone who signs in (admin and viewer logins) can read the master file.
create policy "ledger_read_signed_in" on storage.objects
  for select to authenticated
  using (bucket_id = 'ledger');

-- Only the Division admin can upload, replace and delete it.
create policy "ledger_admin_insert" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'ledger' and (auth.jwt() ->> 'email') = 'ADMIN_EMAIL_HERE');

create policy "ledger_admin_update" on storage.objects
  for update to authenticated
  using (bucket_id = 'ledger' and (auth.jwt() ->> 'email') = 'ADMIN_EMAIL_HERE')
  with check (bucket_id = 'ledger' and (auth.jwt() ->> 'email') = 'ADMIN_EMAIL_HERE');

create policy "ledger_admin_delete" on storage.objects
  for delete to authenticated
  using (bucket_id = 'ledger' and (auth.jwt() ->> 'email') = 'ADMIN_EMAIL_HERE');
