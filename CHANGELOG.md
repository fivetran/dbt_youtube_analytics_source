# dbt_youtube_analytics_source v0.5.0

## Feature Updates
- Introduced the ability to union multiple schemas or databases. For more information on how to leverage this feature, refer to the [README](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/README.md#unioning-multiple-youtube-analytics-connections).

## Breaking Changes:
- Following the unioning functionality, we have added a new field `source_relation` which identifies the source of each record.

## Documentation
- Corrected references to connectors and connections in the README. ([#15](https://github.com/fivetran/dbt_youtube_analytics_source/pull/15))

# dbt_youtube_analytics_source v0.4.0

The following changes were all made as a result of the [latest updates to the Fivetran YouTube Analytics connector](https://fivetran.com/docs/applications/youtube-analytics/changelog#june2023).

## 🚨 Breaking Changes 🚨:
- Removed support for the `video_metadata` Cloud Function generated source table and downstream models. This also means the following variables are no longer used or necessary within the package: ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))
  - `youtube__using_video_metadata`
  - `youtube_metadata_schema`
  - `youtube_analytics_database`
- To be consistent with our other packages, the identifier variables have been updated. Please see the following changes to the identifier variables used in this package. ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))

| **old identifier name** | **new identifier name** |
| ------------------------|-------------------------|
| `youtube__channel_basic_table` | `youtube_analytics_channel_basic_a_2_identifier` |
| `youtube__channel_demographics_table` | `youtube_analytics_channel_demographics_a_1_identifier` |


## Feature Updates
- Following the latest update to **all** Fivetran YouTube Analytics connectors, the `video` metadata is now synced as part of the connector by default. Therefore, the `video` source along with the following staging models have been added: ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))
  - `stg_youtube__video_tmp`
  - `stg_youtube__video`

## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([PR #10](https://github.com/fivetran/dbt_youtube_analytics_source/pull/10))
- Updated the pull request [templates](/.github). ([PR #10](https://github.com/fivetran/dbt_youtube_analytics_source/pull/10))
- Included auto-releaser GitHub Actions workflow to automate future releases. ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))

# dbt_youtube_analytics_source v0.3.0

## 🚨 Breaking Changes 🚨:
[PR #8](https://github.com/fivetran/dbt_youtube_analytics_source/pull/8) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
- Previously, Youtube Analytics staging models were by default built within a schema titled (`<target_schema>` + `_stg_youtube`) in your destination. Now, they are by default written to a schema entitled (`<target_schema>` + `youtube_source`) in your destination. Refer to the README for instructions on how to configure this further. 

# dbt_youtube_analytics_source v0.2.1
- Updated the default schema reference for video metadata
# dbt_youtube_analytics_source v0.2.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_youtube_analytics_source v0.1.0 
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
