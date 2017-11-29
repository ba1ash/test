create table users(id bigserial, group_id bigint);
insert into users(group_id) values (4),(4),(1), (1), (1), (2), (1), (3), (3), (1), (1), (3), (4);

/* number of elements, groups selection */
WITH secondary_table AS(
  SELECT ROW_NUMBER() OVER (ORDER BY id) - ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY id) as diff,
         id,
         group_id
  FROM users
  ORDER BY id
)
SELECT group_id, array_agg(id) AS elements, COUNT(*) AS number_of_elements FROM secondary_table GROUP BY group_id, diff;

/* min value */
WITH find_mins_in_the_groups AS(
  SELECT group_id,
      (CASE WHEN lag(group_id) OVER w != group_id THEN id
            WHEN lag(group_id) OVER w IS NULL THEN id
       ELSE null END) AS min
  FROM users
  WINDOW w as (order by id)
  ORDER BY id
)
SELECT group_id, min AS min_id FROM find_mins_in_the_groups WHERE min IS NOT NULL;
