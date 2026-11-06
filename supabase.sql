-- Pegar y ejecutar en Supabase > SQL Editor
create table if not exists docs(
  path text primary key,
  col text not null,
  data jsonb not null default '{}',
  updated_at timestamptz default now()
);
create index if not exists docs_col on docs(col);
alter table docs enable row level security;

create policy "leer" on docs for select to authenticated using (true);
create policy "crear" on docs for insert to authenticated
  with check (col not in ('votes','profs') or path = col||'/'||auth.uid()::text);
create policy "editar" on docs for update to authenticated
  using (col not in ('votes','profs') or path = col||'/'||auth.uid()::text)
  with check (col not in ('votes','profs') or path = col||'/'||auth.uid()::text);
create policy "borrar" on docs for delete to authenticated
  using (col not in ('votes','profs') or path = col||'/'||auth.uid()::text);

alter publication supabase_realtime add table docs;
