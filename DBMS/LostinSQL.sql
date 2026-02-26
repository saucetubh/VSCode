select
  staff_name,
  (
    select
      party_status
    from
      evacuation_groups eg
    where
      eg.pod_group = c.pod_group
  ) as party_status
from
  crew c 
where party_status != 'boarded';

/* both these queries are same, the first one is using subquery and the second one is using join. 
Join is more efficient than subquery so we should prefer join over subquery when possible */

select staff_name, party_status from crew c join evacuation_groups eg on c.pod_group = eg.pod_group where party_status != 'boarded';