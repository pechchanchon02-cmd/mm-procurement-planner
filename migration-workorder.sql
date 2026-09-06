-- Work Order module (run once in Supabase SQL Editor)
create table if not exists patterns (
  pattern_key text primary key,
  name text, sku_ref text, fabric_default text,
  sizes jsonb, active boolean default true, sort int default 0
);
create table if not exists work_orders (
  job_id text primary key references jobs(job_id) on delete cascade,
  pattern_key text, pattern_name text,
  sizes jsonb,                -- [{size,chest_in,len_in,qty}]
  qty_total numeric,
  fabric_type text, fabric_color text, fabric_folds text, fabric_kg text,
  label_type text, screen_at text, screen_method text, pack_method text,
  lot_no text, sewing_details text, notes text,
  extra_rows jsonb, images jsonb,
  d_fabric_in date, d_sew_done date, d_deliver date,
  created_by text, updated_at timestamptz default now()
);
alter table patterns enable row level security;
alter table work_orders enable row level security;
drop policy if exists p_pat on patterns;
create policy p_pat on patterns for all using (true) with check (true);
drop policy if exists p_wo on work_orders;
create policy p_wo on work_orders for all using (true) with check (true);

insert into patterns(pattern_key,name,sku_ref,fabric_default,sort,sizes) values
('basic','Signature Basic tee (MM08)','2510GMT117','Cotton100% semi 32',10,
 '[{"size":"S","chest_in":32,"chest_cm":81,"len_in":25,"len_cm":63.5},
   {"size":"M","chest_in":36,"chest_cm":91,"len_in":27,"len_cm":68.5},
   {"size":"L","chest_in":40,"chest_cm":101,"len_in":29,"len_cm":73.5},
   {"size":"XL","chest_in":44,"chest_cm":111,"len_in":30,"len_cm":76},
   {"size":"XXL","chest_in":48,"chest_cm":121,"len_in":31,"len_cm":78.5},
   {"size":"3XL","chest_in":50,"chest_cm":127,"len_in":32,"len_cm":81.5},
   {"size":"4XL","chest_in":52,"chest_cm":132,"len_in":33,"len_cm":84}]'),
('oversize','Oversize Drop Shoulder (MM05)','2508GMT100','Cotton100% comb 20',20,
 '[{"size":"M","chest_in":40,"chest_cm":101.5,"len_in":27,"len_cm":68.5},
   {"size":"L","chest_in":44,"chest_cm":112,"len_in":28,"len_cm":71},
   {"size":"XL","chest_in":48,"chest_cm":122,"len_in":29,"len_cm":74},
   {"size":"2XL","chest_in":52,"chest_cm":132,"len_in":30,"len_cm":76}]'),
('boxy','Boxy ไหล่ตก ครอป','2511GMT129','Cotton100% comb 20',30,
 '[{"size":"S","chest_in":42,"chest_cm":106.5,"len_in":25,"len_cm":63.5},
   {"size":"M","chest_in":46,"chest_cm":117,"len_in":25.5,"len_cm":65},
   {"size":"L","chest_in":50,"chest_cm":127,"len_in":26,"len_cm":66},
   {"size":"XL","chest_in":54,"chest_cm":137,"len_in":27,"len_cm":68.5}]'),
('babytee','Baby tee (MM04)','2508GMT099','Cotton100% comb 40 interlock',40,
 '[{"size":"S","chest_in":28,"chest_cm":71,"len_in":19,"len_cm":48.2},
   {"size":"M","chest_in":31,"chest_cm":79,"len_in":19.5,"len_cm":49.5},
   {"size":"L","chest_in":34,"chest_cm":86.5,"len_in":20,"len_cm":50.7},
   {"size":"XL","chest_in":37,"chest_cm":94,"len_in":20.5,"len_cm":52}]')
on conflict (pattern_key) do nothing;
