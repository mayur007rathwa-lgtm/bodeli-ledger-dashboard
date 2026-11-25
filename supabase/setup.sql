-- Bodeli dashboard - storage rules (safe to run again).
-- Replace your-admin@email.com (one place, line 8) with the admin email, then Run all.
-- Anyone with the website link can read the master file; ONLY the admin email can upload.

-- Which login is the admin (small/capital letters and spaces ignored).
create or replace function public.bd_is_admin() returns boolean
language sql stable as $$
  select lower(trim(coalesce(auth.jwt() ->> 'email', ''))) = lower(trim('your-admin@email.com'))
$$;
grant execute on function public.bd_is_admin() to anon, authenticated;

insert into storage.buckets (id, name, public) values ('ledger', 'ledger', false)
on conflict (id) do nothing;

-- Remove EVERY old rule on storage files (including any added by hand), then add only ours.
do $$
declare r record;
begin
  for r in select policyname from pg_policies where schemaname = 'storage' and tablename = 'objects' loop
    execute format('drop policy if exists %I on storage.objects', r.policyname);
  end loop;
end $$;

create policy "ledger_read_all" on storage.objects
  for select to anon, authenticated using (bucket_id = 'ledger');
create policy "ledger_admin_insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'ledger' and public.bd_is_admin());
create policy "ledger_admin_update" on storage.objects
  for update to authenticated using (bucket_id = 'ledger' and public.bd_is_admin())
  with check (bucket_id = 'ledger' and public.bd_is_admin());
create policy "ledger_admin_delete" on storage.objects
  for delete to authenticated using (bucket_id = 'ledger' and public.bd_is_admin());

-- Check: there must be exactly these 4 rules now.
select policyname, cmd from pg_policies where schemaname = 'storage' and tablename = 'objects' order by policyname;
