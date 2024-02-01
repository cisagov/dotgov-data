# 1. Automated updates to domain zone file
Date: 2024-02-01

## Status
In progress

## Context
The dotgov-data repository contains public data for all registered domains in the .gov zone. Two files in this repository, current-full.csv (all domains) and current-federal.csv (only federal domains), are updated daily whenever possible. Other files in the repository contain more .gov hostname data, though they are not complete. The zone file is updated infrequently due to requiring manual changes to update it. Automating updates to the zone file at a regular frequency would increase its reliability and accuracy. Tracking version histories of the zone file would allow users to also understand the changes made to the public record.

Two options for automating gov.txt updates have been proposed:
### 1. Pull data from CZDS zone file ([GitHub issue](https://github.com/cisagov/dotgov-data/issues/107))
The [CZDS API Client in Python](https://github.com/icann/czds-api-client-python) allows people to download zone files for a given zone. We can pull this zone file daily to update the dotgov-data repository’s domain data csv files.

**Benefits**
- The more straightforward implementation. Automates an existing process that is currently done manually.

**Disadvantages**
- A user account is required to access CZDS.
- CZDS takes more time to update data for non .gov domains (e.g., .org, .com).

### 2. Pull data from Cloudflare zone file ([GitHub issue](https://github.com/cisagov/dotgov-data/pull/108))
The second option involves using Cloudflare’s existing tools to check zone updates every 5 minutes (or less frequently) and commit changes to the zone file once a day. 

Cloudflare uses an open source tool called [Nomulus](https://github.com/google/nomulus) which every 5 minutes generates a zone file that Cloudflare’s servers can receive. If we use Cloudflare’s API to check these zone files generated every 5 minutes, we can access more up-to-date and robust zone data.

**Benefits**
- Access to more frequent updates to zone file. Cloudflare API has access to zone file updates every 5 minutes as opposed to CZDS file which is updated daily.
- More robust zone data that includes .org and .com domains sooner than the CZDS file.

**Disadvantages**
- Implementing this approach requires more time to familiarize with the Cloudflare API

## Decision
We will start with automating the zone file via CZDS since it provides more jurisdiction over updated domain data and it presents as the most efficient path to prototyping continuous updates of the zone file.

The initial approach will involve building a GitHub Action that runs an automation script. The automation script, at certain intervals, pulls up-to-date domain data from CZDS and downloads the new CZDS file.

Once the zone file is successfully downloadable, we can create another GitHub Action that can take this CZDS data and store it as an artifact that the user can click and download. ([GitHub Docs: Storing workflow data as artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts))

**Consideration:** What do we want to do with this data in the process of updating dotgov-data? Possible approaches include making a PR listing the changes made or directly pushing the updated file to main.

## Consequences
The goal is to set up the initial steps to automate updates to getgov-data in the following order: use GitHub Actions to call the CZDS API Client to pull the CZDS zone file, save a zone file updates to a downloadable artifact, and upload new data onto getgov-data. The level of automation of these tasks can vary depending on team discretion.





