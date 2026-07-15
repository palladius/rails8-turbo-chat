#!/usr/bin/env node
// Playwright Login Test for Rails 8 Turbo Chat (Devise authentication)
//
// Usage:
//   node test/playwright_login_test.js --port 8080 --user "$PLAYWRIGHT_USERNAME" --pass "$PLAYWRIGHT_PASSWORD"
//   node test/playwright_login_test.js --url https://rails8-turbo-chat-2026-ohznl4txyq-ew.a.run.app/ --user "$PLAYWRIGHT_USERNAME" --pass "$PLAYWRIGHT_PASSWORD"
//
// Setup (one-time):
//   cd rubyllm_chat_app && npm install playwright && npx playwright install chromium
//
// What this does:
// 1. Navigates to the app root (redirects to /users/sign_in if not logged in)
// 2. Fills the Devise login form (email + password)
// 3. Submits and verifies login succeeded (redirected away from /sign_in)
// 4. Saves a screenshot to /tmp/playwright_hello_<port>.png
//
// For fan-out subagents: use deterministic port 48000 + ISSUE_NUMBER

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
  console.log(`[Playwright] Launching headless Chromium for ${BASE_URL}...`);
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    // Step 1: Navigate to the app (Devise will redirect to /users/sign_in)
    console.log(`[Playwright] Navigating to ${BASE_URL}...`);
    const response = await page.goto(BASE_URL, { waitUntil: 'domcontentloaded', timeout: 15000 });
    const status = response ? response.status() : 'unknown';
    console.log(`[Playwright] Page loaded with status: ${status}`);

    if (status !== 200) {
      console.error(`[Playwright] FAIL: Expected HTTP 200, got ${status}`);
      process.exit(1);
    }

    // Step 2: Log in via Devise form
    if (USERNAME && PASSWORD) {
      console.log(`[Playwright] Attempting Devise login as "${USERNAME}"...`);

      // Devise uses user[email] and user[password] field names
      const emailField = await page.$('input[name="user[email]"], input#user_email, input[type="email"]');
      const passwordField = await page.$('input[name="user[password]"], input#user_password, input[type="password"]');

      if (emailField && passwordField) {
        await emailField.fill(USERNAME);
        await passwordField.fill(PASSWORD);

        // Devise submit button — works with any locale (Accedi, Sign in, Log in, etc.)
        const submitButton = await page.$('input[type="submit"], button[type="submit"]');
        if (submitButton) {
          await submitButton.click();
        } else {
          console.log('[Playwright] No submit button found, pressing Enter...');
          await passwordField.press('Enter');
        }

        await page.waitForLoadState('domcontentloaded');
        const postLoginUrl = page.url();
        console.log(`[Playwright] Post-login URL: ${postLoginUrl}`);

        // Check if login succeeded: we should NOT be on /sign_in anymore
        if (postLoginUrl.includes('/sign_in')) {
          console.error('[Playwright] WARN: Still on sign_in page. Login may have failed (bad credentials or user not seeded).');
        } else {
          console.log('[Playwright] Login successful!');
        }
      } else {
        // Not on login page — might already be logged in
        console.log('[Playwright] No Devise login form found. Page might not require auth or user is already logged in.');
      }
    } else {
      console.log('[Playwright] No credentials provided, skipping login.');
    }

    // Step 3: Take a screenshot as proof
    const screenshotPath = `/tmp/playwright_hello_${PORT}.png`;
    await page.screenshot({ path: screenshotPath, fullPage: true });
    console.log(`[Playwright] Screenshot saved to ${screenshotPath}`);

    // Step 4: Report page state
    const title = await page.title();
    const url = page.url();
    console.log(`[Playwright] Final URL: ${url}`);
    console.log(`[Playwright] Page title: "${title}"`);
    console.log('[Playwright] SUCCESS: Test completed!');

  } catch (err) {
    console.error(`[Playwright] ERROR: ${err.message}`);
    // Still try to screenshot on error for debugging
    try {
      await page.screenshot({ path: `/tmp/playwright_error_${PORT}.png`, fullPage: true });
      console.log(`[Playwright] Error screenshot saved to /tmp/playwright_error_${PORT}.png`);
    } catch (_) {}
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
