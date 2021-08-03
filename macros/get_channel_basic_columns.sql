{% macro get_channel_basic_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "annotation_click_through_rate", "datatype": dbt_utils.type_float()},
    {"name": "annotation_clickable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "annotation_clicks", "datatype": dbt_utils.type_int()},
    {"name": "annotation_closable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "annotation_close_rate", "datatype": dbt_utils.type_float()},
    {"name": "annotation_closes", "datatype": dbt_utils.type_int()},
    {"name": "annotation_impressions", "datatype": dbt_utils.type_int()},
    {"name": "average_view_duration_percentage", "datatype": dbt_utils.type_float()},
    {"name": "average_view_duration_seconds", "datatype": dbt_utils.type_float()},
    {"name": "card_click_rate", "datatype": dbt_utils.type_float()},
    {"name": "card_clicks", "datatype": dbt_utils.type_int()},
    {"name": "card_impressions", "datatype": dbt_utils.type_int()},
    {"name": "card_teaser_click_rate", "datatype": dbt_utils.type_float()},
    {"name": "card_teaser_clicks", "datatype": dbt_utils.type_int()},
    {"name": "card_teaser_impressions", "datatype": dbt_utils.type_int()},
    {"name": "channel_id", "datatype": dbt_utils.type_string()},
    {"name": "comments", "datatype": dbt_utils.type_int()},
    {"name": "country_code", "datatype": dbt_utils.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "dislikes", "datatype": dbt_utils.type_int()},
    {"name": "likes", "datatype": dbt_utils.type_int()},
    {"name": "live_or_on_demand", "datatype": dbt_utils.type_string()},
    {"name": "red_views", "datatype": dbt_utils.type_int()},
    {"name": "red_watch_time_minutes", "datatype": dbt_utils.type_float()},
    {"name": "shares", "datatype": dbt_utils.type_int()},
    {"name": "subscribed_status", "datatype": dbt_utils.type_string()},
    {"name": "subscribers_gained", "datatype": dbt_utils.type_int()},
    {"name": "subscribers_lost", "datatype": dbt_utils.type_int()},
    {"name": "video_id", "datatype": dbt_utils.type_string()},
    {"name": "videos_added_to_playlists", "datatype": dbt_utils.type_int()},
    {"name": "videos_removed_from_playlists", "datatype": dbt_utils.type_int()},
    {"name": "views", "datatype": dbt_utils.type_int()},
    {"name": "watch_time_minutes", "datatype": dbt_utils.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}
