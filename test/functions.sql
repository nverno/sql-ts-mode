

SELECT MAX(id)
 FROM my_table;



SELECT now();



SELECT
  user_id,
  user_defined_func(
    user_id, 123, other_func(user_id, 321), user_id + 1 > 5
  ) as something,
  regexp_replace(t.username, '^(.)[^@]+', '\1--', 'g') as username,
  created_at
 FROM my_table AS t;



select col_has_check(
  'one'::name,
  'two'::name,
  array['three'::name, 'four'::name],
  'description'
);



SELECT COUNT(DISTINCT uid ORDER BY uid)
 FROM table_a;



SELECT GROUP_CONCAT(uid SEPARATOR ",")
 FROM some_table
 GROUP BY some_field;



SELECT GROUP_CONCAT(DISTINCT uid ORDER BY uid DESC SEPARATOR ",")
 FROM some_table
 GROUP BY some_field;



SELECT GROUP_CONCAT(uid, ",")
 FROM some_table
 GROUP BY some_field;



SELECT *
 FROM foo
 WHERE id = ANY (
   SELECT 1
 )

;



SELECT *
 FROM foo
 WHERE id IN (
   SELECT 1
   FROM bar
 )

;



SELECT *
 FROM foo
 WHERE (
   NOT EXISTS (
     SELECT 1
     FROM bar
     WHERE 0
   ) OR EXISTS (
     SELECT 1
     FROM baz
     WHERE 1
   )
 )

;



create or replace function public.fn()
  returns int
  language sql
  return 1;



create or replace function public.fn(one int, two text)
  returns int
  language sql
  return 1;



create or replace function public.fn()
  returns int
  language sql
  immutable
  parallel safe
  leakproof
  strict
  cost 100
  rows 1
  return 1;



create or replace function public.fn()
  returns int
  as $$select 1$$
  language sql
  volatile
  parallel restricted
  not leakproof
  returns null on null input
  cost 100
  rows 1;



create or replace function public.fn()
  returns int
  language sql
  as 'select 1;';



create or replace function public.fn()
  returns int
  language sql
  as 'create table x (id int) row_format=dynamic';



create or replace function public.fn()
  returns int
  language sql
  begin atomic
    return 1;
  end;



create or replace function public.fn() returns INT language plpgsql
  as $function$
    begin
    return 1;
  end;
    $function$;



create or replace function public.fn()
  returns int
  language plpgsql
  -- TODO(7/29/24): font-locking/indentation
  as $function$
    declare
    one int;
    two text := (select 'hello');
    three text := 'world';
    begin
    return 1;
  end;
    $function$;



create or replace function public.do_stuff()
  returns trigger
  language plpgsql
  as $function$
    begin
    
    -- comment!
    with knn as (
      select
        h.alpha,
        -- TODO factor in distance
        avg(e.beta) as e_beta
       from htable h
       cross join lateral (
         select
           id,
           gamma,
           delta,
           centroid
         from ftable
         limit 3
       ) as e
       group by h.alpha
    )
      update htable set epsilon = epsilon + e_beta
        from knn
        where knn.alpha = htable.alpha;

    return new;

  end;
    $function$

;



create or replace function public.fn(
  IN arg1 text, OUT arg2 int DEFAULT 12, IN OUT arg3 text = 'test'
)
  returns int
  language sql
  return 1;



create or replace function public.do_stuff()
  returns trigger
  language plpgsql
  as $a$
    begin
    return $b$text$b$;
  end;
    $a$
;


create or replace function public.do_stuff()
  returns trigger
  language plpgsql
  as $_$
    begin
    return $.$text$.$;
  end;
    $_$ ;
