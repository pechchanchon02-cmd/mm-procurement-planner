-- Procurement Planner schema (Supabase) — run once in SQL Editor
create table if not exists jobs (
  job_id text primary key, board text, name text, nifty_status text, tags text,
  so_no text, opened_at date, due_date date, sale_name text, customer text,
  image_url text, synced_at timestamptz default now());

create table if not exists procurement (
  job_id text primary key references jobs(job_id) on delete cascade,
  need_fabric boolean, need_sewing boolean, screen_where text,
  pic text, po_no text, fabric_supplier text, cutsew_shop text, screen_shop text,
  image_url text, note text, internal_due date, tracked boolean default true,
  sale_price numeric, qty numeric, cost_fabric numeric, cost_sewing numeric,
  cost_screen_in numeric, cost_screen_out numeric, cost_shipping numeric, cost_other numeric,
  updated_at timestamptz default now());

create table if not exists milestones (
  id bigint generated always as identity primary key,
  job_id text references jobs(job_id) on delete cascade,
  mkey text, label text, supplier text, plan_date date, actual_date date,
  sort int default 0, note text);
create index if not exists ms_job on milestones(job_id, sort);
create index if not exists ms_plan on milestones(plan_date);

create table if not exists events (
  id bigint generated always as identity primary key,
  job_id text, at timestamptz default now(), who text, field text, old_value text, new_value text);
create index if not exists events_job on events(job_id, at desc);

create table if not exists suppliers (name text primary key, kind text, line_group text);
create table if not exists step_master (
  mkey text primary key, label text, category text, default_supplier text,
  sort int default 0, active boolean default true);

insert into storage.buckets (id,name,public) values ('job-images','job-images',true)
  on conflict (id) do nothing;
drop policy if exists "ji read"  on storage.objects;
drop policy if exists "ji write" on storage.objects;
drop policy if exists "ji upd"   on storage.objects;
create policy "ji read"  on storage.objects for select using (bucket_id='job-images');
create policy "ji write" on storage.objects for insert with check (bucket_id='job-images');
create policy "ji upd"   on storage.objects for update using (bucket_id='job-images');

alter table jobs enable row level security;
alter table procurement enable row level security;
alter table milestones enable row level security;
alter table events enable row level security;
alter table suppliers enable row level security;
alter table step_master enable row level security;
drop policy if exists p_jobs on jobs;
create policy p_jobs on jobs for all using (true) with check (true);
drop policy if exists p_proc on procurement;
create policy p_proc on procurement for all using (true) with check (true);
drop policy if exists p_ms on milestones;
create policy p_ms   on milestones for all using (true) with check (true);
drop policy if exists p_ev on events;
create policy p_ev   on events for all using (true) with check (true);
drop policy if exists p_sup on suppliers;
create policy p_sup  on suppliers for all using (true) with check (true);
drop policy if exists p_sm on step_master;
create policy p_sm   on step_master for all using (true) with check (true);
