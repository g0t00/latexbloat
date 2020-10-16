#!/bin/env node
const puppeteer = require('puppeteer');
const fs = require('fs');
const process = require('process');
if (process.argv.length !== 4) {
  console.log('Expected a relative input and output file.');
  process.exit(1);
}

(async () => {
  const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const page = await browser.newPage();
  const input = process.cwd() + '/' + process.argv[2];
  const output = process.cwd() + '/' + process.argv[3];
  const file = fs.readFileSync(input, {encoding: 'utf-8'});
  const [, width] = file.match(/\<.*?width="(.*?)px"/);
  const [, height] = file.match(/\<.*?height="(.*?)px"/);
  // console.log(width, height);

  await page.goto(`file://${input}`, {waitUntil: 'networkidle2'});
  await page.pdf({path: output, width: `${parseInt(width) + 10}px`, height: `${parseInt(height) + 10}px`});

  await browser.close();
})();
