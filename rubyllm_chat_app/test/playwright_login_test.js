#!/usr/bin/env node
// Playwright Hello World — a template for subagents doing UI verification.
// Usage: node playwright_hello.js --port 48025 --user admin --pass secret123
//        node playwright_hello.js --url https://my-app.run.app --user admin --pass secret123
//
// This script:
// 1. Navigates to http://localhost:<port> or the given --url
// 2. Checks the page loads (HTTP 200)
// 3. Optionally logs in if --user and --pass are provided
//
// Subagents: copy this file into your worktree and adapt it for your specific GHI.
// Install deps first: npm install playwright

const { chromium } = require('playwright');

// Parse CLI args
const args = process.argv.slice(2);
function getArg(name) {
  const idx = args.indexOf(`--${name}`);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : null;
}

const PORT = getArg('port') || '8080';
const USERNAME = getArg('user');
const PASSWORD = getArg('pass');
const BASE_URL = getArg('url') || `http://localhost:${PORT}`;

(async () => {
  console.log(`[Playwright] Launching browser for ${BASE_URL}...`);
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    // Step 1: Navigate to the app
    console.log(`[Playwright] Navigating to ${BASE_URL}...`);
    const response = await page.goto(BASE_URL, { waitUntil: 'domcontentloaded', timeout: 15000 });
    const status = response ? response.status() : 'unknown';
    console.log(`[Playwright] Page loaded with status: ${status}`);

    if (status !== 200) {
      console.error(`[Playwright] FAIL: Expected 200, got ${status}`);
      process.exit(1);
    }

    // Step 2: Log in if credentials provided
    if (USERNAME && PASSWORD) {
      console.log(`[Playwright] Attempting login as "${USERNAME}"...`);

      // Try common login selectors — adapt these for your app!
      const usernameField = await page.$('input[name="username"], input[name="email"], input[name="user"], input[type="email"], #username, #email');
      const passwordField = await page.$('input[name="password"], input[type="password"], #password');
      const submitButton = await page.$('button[type="submit"], input[type="submit"], button:has-text("Log in"), button:has-text("Sign in")');

      if (usernameField && passwordField) {
        await usernameField.fill(USERNAME);
        await passwordField.fill(PASSWORD);
        if (submitButton) {
          await submitButton.click();
          await page.waitForLoadState('domcontentloaded');
          console.log(`[Playwright] Login submitted. Current URL: ${page.url()}`);
        } else {
          console.log('[Playwright] WARN: Found fields but no submit button. Pressing Enter...');
          await passwordField.press('Enter');
          await page.waitForLoadState('domcontentloaded');
        }
      } else {
        console.log('[Playwright] WARN: Could not find login fields on this page. Skipping login.');
      }
    }

    // Step 3: Take a screenshot as proof
    const screenshotPath = `/tmp/playwright_hello_${PORT}.png`;
    await page.screenshot({ path: screenshotPath, fullPage: true });
    console.log(`[Playwright] Screenshot saved to ${screenshotPath}`);

    // Step 4: Print page title
    const title = await page.title();
    console.log(`[Playwright] Page title: "${title}"`);
    console.log('[Playwright] SUCCESS: Hello world test passed!');

  } catch (err) {
    console.error(`[Playwright] ERROR: ${err.message}`);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
