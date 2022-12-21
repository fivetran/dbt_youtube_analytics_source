{% macro get_video_metadata_columns() %}

{% set columns = [
    {"name": "_fivetran_batch", "datatype": dbt.type_int()},
    {"name": "_fivetran_index", "datatype": dbt.type_int()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "channel_title", "datatype": dbt.type_string()},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "published_at", "datatype": dbt.type_timestamp()},
    {"name": "thumbnails", "datatype": dbt.type_string()},
    {"name": "title", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}