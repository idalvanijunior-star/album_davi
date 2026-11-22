-- Cole tudo no SQL Editor do Supabase e clique em Run.

create table if not exists public.fotos (
  id bigint generated always as identity primary key,
  caminho text not null,
  legenda text,
  mes int not null,
  data_foto date not null,
  criado_em timestamptz default now()
);

alter table public.fotos enable row level security;

-- Todo mundo pode ver as fotos
create policy "todos veem" on public.fotos
  for select using (true);

-- Só quem está logado pode adicionar ou apagar
create policy "logados inserem" on public.fotos
  for insert to authenticated with check (true);

create policy "logados apagam" on public.fotos
  for delete to authenticated using (true);

-- Pasta (bucket) das imagens, pública para leitura
insert into storage.buckets (id, name, public)
values ('fotos', 'fotos', true)
on conflict (id) do nothing;

create policy "imagens publicas" on storage.objects
  for select using (bucket_id = 'fotos');

create policy "logados enviam imagens" on storage.objects
  for insert to authenticated with check (bucket_id = 'fotos');

create policy "logados apagam imagens" on storage.objects
  for delete to authenticated using (bucket_id = 'fotos');
