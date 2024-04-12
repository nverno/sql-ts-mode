selections

selections for your perusal

inserted_at

updated_at

deleted_at

created_at

create or replace function public.do_stuff()
  returns trigger
  language plpgsql
as $a$
begin
  return $a$text$a$;
end;
$a$

create or replace function public.do_stuff()
  returns trigger
  language plpgsql
as $a$
begin
  return $b$text$b$;
end;
$c$;

create or replace function public.do_stuff()
  returns trigger
  language plpgsql
as $a$
begin
  return $b $text$b $;
end;
$a$;
