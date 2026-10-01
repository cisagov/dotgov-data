import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';
import vm from 'node:vm';

const html = readFileSync(new URL('../index.html', import.meta.url), 'utf8');
const scriptStart = html.lastIndexOf('<script>');
const markup = html.slice(0, scriptStart);
const script = html.slice(scriptStart + '<script>'.length, html.indexOf('</script>', scriptStart));

for (const [url, repo, production] of [
  ['https://data.get.gov/', 'cisagov/dotgov-data', true],
  ['https://cisagov.github.io/dotgov-data/', 'cisagov/dotgov-data', true],
  ['https://cisagov.github.io/dotgov-data-staging/', 'cisagov/dotgov-data-staging', false],
  ['https://example.github.io/dotgov-data/', 'example/dotgov-data', false],
]) {
  for (const librariesAvailable of [true, false]) {
    test(`${url} initializes with CDN libraries ${librariesAvailable ? 'available' : 'missing'}`, () => {
      // Build only the startup DOM surface, using IDs from the actual markup.
      // Missing elements must return null, as they do in a browser.
      const elements = new Map();
      for (const match of markup.matchAll(/<[^>]+\bid="([^"]+)"[^>]*>/g)) {
        elements.set(match[1], {
          hidden: /\shidden(?:\s|>|=)/.test(match[0]),
          disabled: /\sdisabled(?:\s|>|=)/.test(match[0]),
          textContent: '',
          addEventListener() {},
        });
      }
      const document = {
        title: 'Data viewer | data.get.gov',
        getElementById: id => elements.get(id) || null,
        querySelectorAll: () => [],
      };
      const requests = [];
      const context = {
        document,
        window: { location: new URL(url) },
        URL,
        URLSearchParams,
        fetch: request => {
          requests.push(request);
          // Stop at file discovery. No external requests or table rendering.
          return new Promise(() => {});
        },
      };
      if (librariesAvailable) {
        context.Tabulator = function () {};
        context.Papa = {};
      }

      assert.doesNotThrow(() => vm.runInNewContext(script, context));
      assert.equal(elements.get('non-production-banner').hidden, production);
      assert.equal(elements.get('h1-nonproduction-tag').hidden, production);
      assert.equal(elements.get('footer-production-note').hidden, !production);
      if (!production) {
        assert.equal(elements.get('site-title-link').textContent, new URL(url).hostname);
        assert.ok(elements.get('non-production-banner-text').textContent.includes(repo));
      }
      if (librariesAvailable) {
        assert.deepEqual(requests, [`https://api.github.com/repos/${repo}/contents/?ref=main`]);
      } else {
        assert.deepEqual(requests, []);
        assert.match(elements.get('message-banner').textContent, /could not load Tabulator and PapaParse/);
        assert.equal(elements.get('global-search').disabled, true);
      }
    });
  }
}
