# YouTube Analytics Source dbt ([Docs](https://fivetran.github.io/dbt_youtube_analytics_source/#!/overview))

<p align="left">
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

## What does this dbt package do?
- Materializes [Youtube Analytics staging tables](https://fivetran.github.io/dbt_youtube_analytics_source/#!/overview/youtube_analytics_source?g_v=1) which leverage data in the format described by the [YouTube Channel Report schemas](https://fivetran.com/docs/applications/youtube-analytics#schemainformation). These staging tables clean, test, and prepare your Youtube Analytics data from [Fivetran's connector](https://fivetran.com/docs/applications/youtube-analytics#youtubeanalytics) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Youtube Analytics data through the [dbt docs site](https://fivetran.github.io/dbt_youtube_analytics_source/).
- These tables are designed to work simultaneously with our [Youtube Analytics transformation package](https://github.com/fivetran/dbt_youtube_analytics).

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Youtube Analytics connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `youtube_analytics` transformation package)
Include the following youtube_analytics_source package version in your `packages.yml` file.
> Do NOT add this if you have added the [Youtube Analytics Transformation](https://github.com/fivetran/dbt_youtube_analytics) package to your `packages.yml` file.
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/youtube_analytics_source
    version: [">=0.5.0", "<0.6.0"] # we recommend using ranges to capture non-breaking changes automatically
```

### Step 3: Define database and schema variables
By default, this package runs using your destination and the `youtube_analytics` schema. If this is not where your Youtube Analytics data is (for example, if your youtube schema is named `youtube_analytics_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    youtube_analytics_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```

### Step 4: Enable/Disable Demographics Report
This packages assumes you are syncing the YouTube `channel_demographics_a1` report. If you are _not_ syncing this report, you may add the below configuration to your `dbt_project.yml` to disable the `stg_youtube__demographics` model and all downstream references.
```yml
# dbt_project.yml

vars:
  youtube__using_channel_demographics: false # true by default
```

### (Optional) Step 5: Additional configurations

#### Unioning Multiple Youtube Analytics Connections
If you have multiple Youtube Analytics connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table(s) into the final models. You will be able to see which source it came from in the `source_relation` column(s) of each model. To use this functionality, you will need to set either (**note that you cannot use both**) the `union_schemas` or `union_databases` variables:

```yml
# dbt_project.yml
vars:
    ##You may set EITHER the schemas variables below
    youtube_analytics_union_schemas: ['youtube_analytics_one','youtube_analytics_two']

    ##Or may set EITHER the databases variables below
    youtube_analytics_union_databases: ['youtube_analytics_one','youtube_analytics_two']
```

#### Change the build schema
By default, this package builds the Youtube Analytics staging models within a schema titled (`<target_schema>` + `_youtube_source`) in your destination. If this is not where you would like your Youtube staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    youtube_analytics_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
# dbt_project.yml
vars:
    youtube_analytics_<default_source_table_name>_identifier: your_table_name 
```

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]
    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/youtube_analytics_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_youtube_analytics_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).