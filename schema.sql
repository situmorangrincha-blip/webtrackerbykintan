-- LANU Content Tracker — jalankan sekali di Supabase > SQL Editor > New query > Run

create table if not exists public.posts (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.app_config (
  key text primary key,
  value text not null
);

-- Kunci semua tabel: tidak ada policy = tidak bisa diakses langsung lewat API.
alter table public.posts enable row level security;
alter table public.app_config enable row level security;

-- Password (ganti di sini kalau mau ubah)
insert into public.app_config (key, value) values ('password', 'theojames')
on conflict (key) do update set value = excluded.value;

-- Semua akses lewat fungsi di bawah, password dicek di server.
create or replace function public.check_pw(pw text) returns boolean
language sql security definer set search_path = public as $$
  select exists (select 1 from app_config where key = 'password' and value = pw);
$$;

create or replace function public.get_posts(pw text) returns jsonb
language plpgsql security definer set search_path = public as $$
begin
  if not check_pw(pw) then raise exception 'unauthorized'; end if;
  return coalesce((select jsonb_agg(data order by data->>'date') from posts), '[]'::jsonb);
end $$;

create or replace function public.upsert_post(pw text, p jsonb) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not check_pw(pw) then raise exception 'unauthorized'; end if;
  insert into posts (id, data, updated_at) values (p->>'id', p, now())
  on conflict (id) do update set data = excluded.data, updated_at = now();
end $$;

create or replace function public.delete_post(pw text, pid text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not check_pw(pw) then raise exception 'unauthorized'; end if;
  delete from posts where id = pid;
end $$;

grant execute on function public.check_pw(text), public.get_posts(text),
  public.upsert_post(text, jsonb), public.delete_post(text, text) to anon;
