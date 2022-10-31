<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# YouTube Analytics Source dbt ([Docs](https://fivetran.github.io/dbt_youtube_analytics_source/#!/overview))

# 📣 What does this dbt package do?
- Materializes [Youtube Analytics staging tables](https://fivetran.github.io/dbt_youtube_analytics_source/#!/overview/youtube_analytics_source?g_v=1) which leverage data in the format described by the [YouTube Channel Report schemas](https://fivetran.com/docs/applications/youtube-analytics#schemainformation). These staging tables clean, test, and prepare your Youtube Analytics data from [Fivetran's connector](https://fivetran.com/docs/applications/youtube-analytics#youtubeanalytics) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Youtube Analytics data through the [dbt docs site](https://fivetran.github.io/dbt_youtube_analytics_source/).
- These tables are designed to work simultaneously with our [Youtube Analytics transformation package](https://github.com/fivetran/dbt_youtube_analytics).

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Youtube Analytics connector syncing data into your destination. 
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following youtube_analytics_source package version in your `packages.yml` file.
> Do NOT add this if you have added the [Youtube Analytics Transformation](https://github.com/fivetran/dbt_youtube_analytics) package to your `packages.yml` file. 
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/youtube_analytics_source
    version: [">=0.3.0", "<0.4.0"]
```

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `youtube_analytics` schema. If this is not where your Youtube Analytics data is (for example, if your youtube schema is named `youtube_analytics_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    youtube_analytics_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```

## Step 4: Sync Required YouTube Channel Reports
To use this package you will need to pull the following YouTube Analytics reports through Fivetran:
- [channel_basic_a2](https://developers.google.com/youtube/reporting/v1/reports/channel_reports#video-user-activity) (required)
- [channel_demographics_a1](https://developers.google.com/youtube/reporting/v1/reports/channel_reports#video-viewer-demographics) (optional)
- [videos metadata table](https://resources.fivetran.com/datasheets/youtube-metadata-cloud-function-guide-2) (optional)

## (Recommended) Step 5: Using Youtube Video Metadata

### Step 5a: Sync Video Metada 

The Fivetran YouTube Analytics connector currently does not support video metadata. Consequently, it may be difficult to analyze individual video data without knowing which video belongs to which record. 

As a workaround, you can create a [Functions connector](https://fivetran.com/docs/functions) that syncs your YouTube video metadata into a table in your destination. This dbt package can then use the `VIDEOS` metadata table to enrich your YouTube Analytics reporting data. To learn more about creating a Functions connector, read our [YouTube Analytics Video Metadata Cloud Function article](https://resources.fivetran.com/datasheets/youtube-metadata-cloud-function-guide-2). It provides code and detailed steps on how to configure the function. 

### Step 5b: Enable Video Metadata

By default, the video metadata functionality within this package is disabled. If you have completed Step 5a and onfigured a cloud function to sync your video metadata into a `VIDEOS` table, you must also enable the video metadata functionality to incorporate the metadata into your package. You may use the variable configuration below in your `dbt_project.yml` to enable this functionality:

```yml
# dbt_project.yml

vars:
  youtube__using_video_metadata: true # false by default
```

### Step 5c: Define Video Metadata database and schema variables

By default, this package will look for your `VIDEOS` YouTube Analytics metadata table in the `youtube_analytics_metadata` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your YouTube Analytics metadata table is, please add the following configuration to your `dbt_project.yml` file:
```yml
# dbt_project.yml

...
config-version: 2

vars:
    youtube_metadata_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```

## Step 6: Disabling Demographics Report
This packages assumes you are syncing the YouTube `channel_demographics_a1` report. If you are _not_ syncing this report, you may add the below configuration to your `dbt_project.yml` to disable the `stg_youtube__demographics` model and all downstream references.
```yml
# dbt_project.yml

vars:
  youtube__using_channel_demographics: false # true by default
```


## (Optional) Step 7: Additional configurations
<details><summary>Expand for configurations</summary>

### Change the build schema
By default, this package builds the Youtube Analytics staging models within a schema titled (`<target_schema>` + `_youtube_source`) in your destination. If this is not where you would like your Youtube staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    youtube_analytics_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

### Specify Source Table Names

This package assumes that the `channel_basic_a_2` and `channel_demographics_a_1` reports are named accordingly. If these reports have different names in your destination, enter the correct names in the `channel_basic_table_name` and/or `channel_demographics_table_name` variables in your `dbt_project.yml` so that the package can find them:

```yml
# dbt_project.yml

vars:
  youtube__channel_basic_table:         "my_channel_basic_table_name"
  youtube__channel_demographics_table:  "demographics_youtube_report"
```

</details>

## (Optional) Step 8: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]
    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/youtube_analytics_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_youtube_analytics_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.