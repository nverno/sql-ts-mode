

SELECT
  "user"->>'login' as login,
  "user"->'address' ->> 'city',
  "user"->'address' ->> 'state' as userstate,
  "user" #> 'items',
  "user" #>> 'more_items' AS more
 FROM users;
