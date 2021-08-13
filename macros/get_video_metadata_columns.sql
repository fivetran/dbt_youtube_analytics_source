{% macro get_video_metadata_columns() %}

{% set columns = [
    {"name": "_fivetran_batch", "datatype": dbt_utils.type_int()},
    {"name": "_fivetran_index", "datatype": dbt_utils.type_int()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "channel_title", "datatype": dbt_utils.type_string()},
    {"name": "description", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string()},
    {"name": "published_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "thumbnails", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}