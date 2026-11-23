-- Bodeli dashboard - corrected storage rules.
-- Replace your-admin@email.com (one place, line 6) with the admin email, then Run all.
-- Anyone with the website link can read the master file (open for all); only the admin can upload.

create or replace function public.bd_is_admin() returns boolean
language sql stable as $$
  select lower(trim(coalesce(auth.jwt() ->> 'email', ''))) = lower(trim('your-admin@email.com'))
$$;

insert into storage.buckets (id, name, public) values ('ledger', 'ledger', false)
on conflict (id) do nothing;

drop policy if exists "ledger_read_signed_in" on storage.objects;
drop policy if exists "ledger_admin_insert" on storage.objects;
drop policy if exists "ledger_admin_update" on storage.objects;
drop policy if exists "ledger_admin_delete" on storage.objects;

create policy "ledger_read_signed_in" on storage.objects
  for select to anon, authenticated using (bucket_id = 'ledger');
create policy "ledger_admin_insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'ledger' and public.bd_is_admin());
create policy "ledger_admin_update" on storage.objects
  for update to authenticated using (bucket_id = 'ledger' and public.bd_is_admin())
  with check (bucket_id = 'ledger' and public.bd_is_admin());
create policy "ledger_admin_delete" on storage.objects
  for delete to authenticated using (bucket_id = 'ledger' and public.bd_is_admin());

-- Check: the logins in this project (the admin email must match one of these).
select email from auth.users order by email;
