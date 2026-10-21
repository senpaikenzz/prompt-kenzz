-- Jalankan di Supabase SQL Editor
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 email text, role text not null default 'member' check(role in ('member','owner')),
 created_at timestamptz not null default now()
);
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,email,role) values(new.id,new.email,'member') on conflict(id) do nothing;
 return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
create table if not exists public.prompts (
 id uuid primary key default gen_random_uuid(), title text not null, category text not null,
 subcategory text, description text, content text not null, tags text[] not null default '{}',
 image_url text, status text not null default 'published' check(status in ('draft','published')),
 created_by uuid references auth.users(id), created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
alter table public.prompts enable row level security;
create or replace function public.is_owner() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.profiles where id=auth.uid() and role='owner');
$$;
drop policy if exists "profiles readable by self" on public.profiles;
create policy "profiles readable by self" on public.profiles for select to authenticated using(id=auth.uid());
drop policy if exists "published prompts are public" on public.prompts;
create policy "published prompts are public" on public.prompts for select to anon,authenticated using(status='published' or public.is_owner());
drop policy if exists "only owner inserts prompts" on public.prompts;
create policy "only owner inserts prompts" on public.prompts for insert to authenticated with check(public.is_owner() and created_by=auth.uid());
drop policy if exists "only owner updates prompts" on public.prompts;
create policy "only owner updates prompts" on public.prompts for update to authenticated using(public.is_owner()) with check(public.is_owner());
drop policy if exists "only owner deletes prompts" on public.prompts;
create policy "only owner deletes prompts" on public.prompts for delete to authenticated using(public.is_owner());
-- Setelah membuat akun Owner di Supabase Authentication, ganti UUID di bawah:
-- update public.profiles set role='owner' where id='UUID-AKUN-OWNER';
