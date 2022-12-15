# .gov data
<img width="70" alt="favicon" src="https://user-images.githubusercontent.com/603901/149229443-26d6a916-5806-4ee8-80ba-57812f77004b.png">

The [.gov top-level domain](https://home.dotgov.gov) is operated so that the online services of US-based government organizations are easy to identify on the internet. In support of that aim, we publish .gov domain data publicly.

This repository contains the official, full list of registered domains in the .gov zone. The US Government's executive, legislative, and judicial branches are represented, as are US-based state, territory, tribal, city, and county governments.

Two files are updated daily (when there is activity):
* [current-full.csv](https://github.com/cisagov/dotgov-data/blob/main/current-full.csv) – a CSV of all domains, including federal domains
* [current-federal.csv](https://github.com/cisagov/dotgov-data/blob/main/current-federal.csv) – a CSV of only federal domains

These files list the "second-level domains" (e.g., cisa.gov) that are actively registered in the .gov zone; they do not list every _hostname_ (e.g., presidentscup.cisa.gov) in use in the .gov namespace. Note that not all registered domains offer an online service (e.g., a website, an email server) at the domain.

This repo hosts several other files that include .gov hostnames, though they are not complete. 

## Spot an issue?

**This repo doesn't accept pull requests on current-{full,federal}**. If you manage a domain in these files and you:
* notice that metadata about it is incorrect, log in to the [.gov registrar](https://domains.dotgov.gov) to correct it.
* want to transfer it to a different agency, step through the [domain ownership transfer process](https://home.dotgov.gov/management/#how-do-i-transfer-my-domain-to-a-different-agency).

If you use any of this data or just have a question, let us know by [opening an issue](https://github.com/cisagov/dotgov-data/issues).

Find a **security or privacy issue** on one of these domains? Review our [security policy](https://github.com/cisagov/dotgov-data/security/policy).

## Unofficial uses

* [Accept the Risk and Continue: Measuring the Long Tail of Government https Adoption](https://sudheesh.info/papers/imc20.pdf). Sudheesh Singanamalla, Esther Han Beol Jang, Richard Anderson, Tadayoshi Kohno, and Kurtis Heimerl. 2020. In Proceedings of the ACM Internet Measurement Conference (IMC '20). Association for Computing Machinery, New York, NY, USA, 577–597. DOI:https://doi.org/10.1145/3419394.3423645
* Lauren Ancona made a [geocoded map of .gov domains](http://laurenancona.com/maps/gov_domains.html):

[![gov_domains](https://cloud.githubusercontent.com/assets/2152151/5627069/ba4185e2-9561-11e4-873a-54d9f480ec3e.jpg)](http://laurenancona.com/maps/gov_domains.html)
