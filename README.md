# .gov data
<img width="70" alt="favicon" src="https://github.com/cisagov/dotgov-data/assets/603901/7cf1f2e8-ed6d-4f3d-a5fd-813a1ec2b566">



The [.gov top-level domain](https://get.gov) exists so that the online services of U.S.-based government organizations are easy to identify on the internet. In support of that goal, the .gov registry publishes information about our domains.

This repository contains the official, full list of registered domains in the .gov zone. The U.S. Government's executive, legislative, and judicial branches are represented, as are many state, territory, tribal, city, and county governments in the United States.

Three files are updated daily (when there is activity):
* [gov.txt](https://github.com/cisagov/dotgov-data/blob/main/gov.txt) — a copy of the .gov zone file
* [current-full.csv](https://github.com/cisagov/dotgov-data/blob/main/current-full.csv) — a CSV of all domains in the zone, including federal domains
* [current-federal.csv](https://github.com/cisagov/dotgov-data/blob/main/current-federal.csv) — a CSV of only federal domains in the zone

current-full.csv and current-federal.csv contain the same registered domains as the zone file, but instead of name server records they detail the registrant organization. They include all domains in the "Ready" and "On hold" states of our [registrar](https://github.com/cisagov/manage.get.gov/). 

Each file lists the "second-level domains" (e.g., get.gov) that are registered in the .gov zone; they do not list every _hostname_ (e.g., manage.get.gov) in use in the .gov namespace. This repo hosts several other files that include .gov hostnames, though they are not complete.

Note that not all registered domains offer an online service (e.g., a website, an email server) at the domain. 

## Spot an issue?

**This repo doesn't accept pull requests on the zone file or current-{full,federal}.csv**. If you manage a domain in these files and you notice that metadata about it is incorrect, log in to the [.gov registrar](https://manage.get.gov) to correct it.

* If you use any of this data or just have a question, let us know by [opening an issue](https://github.com/cisagov/dotgov-data/issues).

* Find a **security or privacy issue** on one of these domains? Review our [security policy](https://github.com/cisagov/dotgov-data/security/policy).

## Unofficial uses

* [Accept the Risk and Continue: Measuring the Long Tail of Government https Adoption](https://sudheesh.info/papers/imc20.pdf). Sudheesh Singanamalla, Esther Han Beol Jang, Richard Anderson, Tadayoshi Kohno, and Kurtis Heimerl. 2020. In Proceedings of the ACM Internet Measurement Conference (IMC '20). Association for Computing Machinery, New York, NY, USA, 577–597. [DOI](https://doi.org/10.1145/3419394.3423645)
* Lauren Ancona made a [geocoded map of .gov domains](http://laurenancona.com/maps/gov_domains.html):

[![gov_domains](https://cloud.githubusercontent.com/assets/2152151/5627069/ba4185e2-9561-11e4-873a-54d9f480ec3e.jpg)](http://laurenancona.com/maps/gov_domains.html)

## For developers

### GitHub Pages

This repo publishes a small data browser via GitHub Pages so that the CSV files named above can be searched, sorted, and filtered without needing to clone or download anything.

Key things to know:

- `main` is the canonical source of truth for index.html and the CSVs.
- The repository is configured to deploy to GitHub Pages from a branch, `gh-pages` (not `main`). 
- The `gh-pages` branch is a deploy target _only_ — it is managed exclusively by GitHub Actions, and developers shouldn't generally merge or interact with `gh-pages` directly.

#### Workflows

- **`.github/workflows/deploy.yml`** is triggered when there are changes to `index.html` or one of the `.csv` files on `main`. The workflow syncs those changes to the `gh-pages` branch to be deployed. This workflow can also be triggered manually via **Run workflow** in the Actions tab.
- **`.github/workflows/branch-preview.yml`** publishes a temporary preview of any other branch in this repository, and removes it automatically when the branch is deleted. 

### Making changes

1. Branch off `main`, make changes, and push that branch to the repo.
2. `branch-preview.yml` runs automatically. Check the **Actions** tab for the run, and open its summary to get a link to the preview.
3. Every push to your branch will update the same preview link in-place.
4. Open a PR when you're ready. Reviewers can use the same link to see a rendered page, not just the diff. 
5. Merge the PR to `main` once approved.
6. On the merge to `main`, `deploy.yml` syncs the changes to the `gh-pages` branch and it's deployed to the GitHub Pages site. 
7. Deleting your branch (or letting GitHub do it after merge) cleans up the preview automatically.

### Known limitations

* **Fork PRs don't get a preview** — the preview workflow only supports branches within this repo, not PRs from a fork.
* **Orphaned preview cleanup is manual** — if a preview is left behind outside of a normal branch deletion, it needs to be manually removed from the `gh-pages` branch using `git rm` for the folder where the preview is.