#!/usr/bin/env node

'use strict';

const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const campaign = 'krea-2-turbo-image';
const keyBase = 'https://evolink.ai/dashboard/keys';
const allowed = {
  githubReadme: `${keyBase}?utm_source=github&utm_medium=readme&utm_campaign=${campaign}`,
  npmPackage: `${keyBase}?utm_source=npm&utm_medium=package&utm_campaign=${campaign}`,
  skillInstall: `${keyBase}?utm_source=skill&utm_medium=install&utm_campaign=${campaign}`,
};

function read(rel) {
  return fs.readFileSync(path.join(root, rel), 'utf8');
}

function keyUrls(text) {
  const matches = text.match(/https:\/\/evolink\.ai\/dashboard\/keys\?[^\s)>"'`]+/g);
  return (matches || []).map((url) => url.replace(/[.,;:]+$/g, ''));
}

function fail(message) {
  console.error(`surface check failed: ${message}`);
  process.exitCode = 1;
}

function assertUrlSet(rel, accepted) {
  const urls = keyUrls(read(rel));
  for (const url of urls) {
    if (!accepted.includes(url)) {
      fail(`${rel} contains disallowed key URL: ${url}`);
    }
    const query = new URL(url).searchParams;
    const params = [...query.keys()].sort();
    const expected = ['utm_campaign', 'utm_medium', 'utm_source'];
    if (params.join(',') !== expected.join(',')) {
      fail(`${rel} key URL must use exactly utm_source, utm_medium, utm_campaign: ${url}`);
    }
  }
}

assertUrlSet('README.md', [allowed.githubReadme]);
assertUrlSet('README.npm.md', [allowed.npmPackage]);

for (const rel of ['README.npm.md']) {
  const text = read(rel);
  if (/README\.(de|es|fr|ja|ko|pt|ru|tr|zh-CN|zh-TW)\.md/.test(text)) {
    fail(`${rel} links to localized README variants that are excluded from the npm payload.`);
  }
  if (text.includes('utm_source=github&utm_medium=readme')) {
    fail(`${rel} contains GitHub README attribution.`);
  }
  if (text.includes('utm_source=skill&utm_medium=install')) {
    fail(`${rel} contains installer-runtime attribution.`);
  }
}

for (const rel of ['bin/cli.js', 'llms-install.md', 'SKILL.md']) {
  assertUrlSet(rel, [allowed.skillInstall]);
}

const packageJson = JSON.parse(read('package.json'));
if (!packageJson.readmeFilename || packageJson.readmeFilename !== 'README.md') {
  fail('package.json must force readmeFilename to README.md for npm rendering.');
}

if (!fs.existsSync(path.join(root, 'README.npm.md'))) {
  fail('README.npm.md must exist as a materialized npm-facing README source.');
}

if (!fs.existsSync(path.join(root, 'scripts', 'publish-npm.sh'))) {
  fail('scripts/publish-npm.sh must exist for staged npm publishing.');
}

if (!process.exitCode) {
  console.log('surface check ok');
}
