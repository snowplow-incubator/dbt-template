{#
Copyright (c) 2023-present Snowplow Analytics Ltd. All rights reserved.
This program is licensed to you under the Snowplow Personal and Academic License Version 1.0,
and you may not use this file except in compliance with the Snowplow Personal and Academic License Version 1.0.
You may obtain a copy of the Snowplow Personal and Academic License Version 1.0 at https://docs.snowplow.io/personal-and-academic-license-1.0/
#}

{{
  config(
    sort='collector_tstamp',
    dist='event_id',
    tags=["this_run"]
  )
}}

{# Setting sdes or contexts for Postgres / Redshift. Dbt passes variables by reference so need to use copy to avoid altering the list multiple times #}
{% set contexts = var('snowplow__entities_or_sdes', []).copy() %}

{% set base_events_query = snowplow_utils.base_create_snowplow_events_this_run(
                              sessions_this_run_table='<YOUR PACKAGE NAME>_base_sessions_this_run',
                              session_identifiers=var('snowplow__session_identifiers'),
                              session_sql=var('snowplow__session_sql', none),
                              session_timestamp=var('snowplow__session_timestamp', 'collector_tstamp'),
                              derived_tstamp_partitioned=var('snowplow__derived_tstamp_partitioned', true),
                              days_late_allowed=var('snowplow__days_late_allowed', 3),
                              max_session_days=var('snowplow__max_session_days', 3),
                              app_ids=var('snowplow__app_id', []),
                              snowplow_events_database=var('snowplow__database', target.database) if target.type not in ['databricks', 'spark'] else var('snowplow__databricks_catalog', 'hive_metastore') if target.type in ['databricks'] else var('snowplow__atomic_schema', 'atomic'),
                              snowplow_events_schema=var('snowplow__atomic_schema', 'atomic'),
                              snowplow_events_table=var('snowplow__events_table', 'events'),
                              entities_or_sdes=contexts,
                              custom_sql=var('snowplow__custom_sql', none)
                              ) %}

with base_query as (
  {{ base_events_query }}
)

select
  *

from base_query
