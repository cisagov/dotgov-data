# assets/vendor/

This folder is for third-party front-end libraries, bringing them into this repo
rather than grabbing from an external origin on page-load.

| Library | Version | License | Files |
| --- | --- | --- | --- |
| [Tabulator](https://tabulator.info/) | 5.6.1 | MIT | `tabulator.min.js`, `tabulator.min.css` |
| [PapaParse](https://www.papaparse.com/) | 5.4.1 | MIT | `papaparse.min.js` |

Each directory also includes the upstream `LICENSE` as required by the MIT
license both use. So **don't delete those files**.

There is no build step and nothing runs in CI. These files are maintained manually when updates
are needed, and instructions are below for fetching new versions.

## Version numbers in the directory name

`tabulator-5.6.1/`, not `tabulator/`. An upgrade then shows up as a new
directory plus changed paths in `index.html`, which is obvious in review, and
the URL change busts browser caches for free.

## Where to obtain the files

- Tabulator package: https://www.npmjs.com/package/tabulator-tables
- PapaParse package: https://www.npmjs.com/package/papaparse

These can be downloaded and extracted into the correct paths using the script below.

Set the versions you want and paste the whole block from the repo root. It
creates the version-numbered directories and copies in only the files listed
in the table below.

```
    TABULATOR=5.6.1
    PAPAPARSE=5.4.1

    tmp=$(mktemp -d)
    ( cd "$tmp" && npm pack "tabulator-tables@$TABULATOR" "papaparse@$PAPAPARSE" )

    mkdir -p "$tmp/tab" "$tmp/papa"
    tar -xzf "$tmp/tabulator-tables-$TABULATOR.tgz" -C "$tmp/tab"
    tar -xzf "$tmp/papaparse-$PAPAPARSE.tgz"        -C "$tmp/papa"

    mkdir -p "assets/vendor/tabulator-$TABULATOR" "assets/vendor/papaparse-$PAPAPARSE"

    cp "$tmp/tab/package/dist/js/tabulator.min.js" \
       "$tmp/tab/package/dist/css/tabulator.min.css" \
       "$tmp/tab/package/LICENSE" \
       "assets/vendor/tabulator-$TABULATOR/"

    cp "$tmp/papa/package/papaparse.min.js" \
       "$tmp/papa/package/LICENSE" \
       "assets/vendor/papaparse-$PAPAPARSE/"

    rm -rf "$tmp"
    find assets/vendor -type f ! -name '*.md' | sort

```

`npm pack` checks each download against the hash the registry publishes for
that release and fails if they don't match, so you don't need to verify
anything by hand. Nothing is written into `assets/vendor/` unless both
downloads succeed.

This only adds files. It won't remove the old version's directory — see the
checklist below.

These are the files that are copied, with the version numbers specified
above.

| Package | From the tarball | To |
| --- | --- | --- |
| TABULATOR | `package/dist/js/tabulator.min.js` | `assets/vendor/tabulator-$VERSION/` |
| TABULATOR | `package/dist/css/tabulator.min.css` | `assets/vendor/tabulator-$VERSION/` |
| TABULATOR | `package/LICENSE` | `assets/vendor/tabulator-$VERSION/` |
| PAPAPARSE | `package/papaparse.min.js` | `assets/vendor/papaparse-$VERSION/` |
| PAPAPARSE | `package/LICENSE` | `assets/vendor/papaparse-$VERSION/` |


## Upgrade checklist

1. Fetch and extract the new version as above. This will unpack the files, 
   create the correct directory structure, and include the LICENSE as published.
2. **Update all three paths in `index.html`.** Two of them are Tabulator (the
   `<link>` for the CSS and the `<script>` for the JS) and one is PapaParse.
   Missing one is the most likely mistake here: the page keeps working on the
   old copy and nothing looks wrong.
   ```
   <link rel="stylesheet" href="assets/vendor/tabulator-5.6.1/tabulator.min.css">
<script src="assets/vendor/tabulator-5.6.1/tabulator.min.js"></script>
<script src="assets/vendor/papaparse-5.4.1/papaparse.min.js"></script>
    ```
3. **Delete the old version's directory.**
4. Push to a branch and check the preview. Confirm the table renders, and that
   the Network tab shows the new paths and no requests to `cdnjs.cloudflare.com`.

## Files are kept byte-identical to upstream

Nothing here is edited after extraction, which is what keeps future diffs 
reviewable and lets anyone re-download the same version and get the same files.

One consequence: `tabulator.min.js` and `tabulator.min.css` end with a
`sourceMappingURL` comment pointing at `.map` files that aren't vendored (the JS
map alone is 1.2 MB). DevTools will request them and get a 404. This is
invisible to users and only appears with DevTools open and source maps enabled.
Stripping those two comment lines would silence it, but the files would no
longer match the published package — not worth the trade.

## These are not forked

If something here needs changing, fix it upstream or work around it in
`index.html`. Patching a vendored file in place leaves the next person no way to
tell what's ours and what's theirs, and means re-running the fetch above would 
silently undo the change.

## Deployment

`assets/**` must stay in the `paths:` filters of `.github/workflows/deploy.yml`
and `.github/workflows/branch-preview.yml`, and in the staging step that copies
files into `_site/`. If either is missing, these files never reach the `gh-pages`
branch, and the page loads nothing, which looks like a broken deploy rather than
a missing asset.