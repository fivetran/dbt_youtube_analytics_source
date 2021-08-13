{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

select *
from {{ var('channel_demographics') }}