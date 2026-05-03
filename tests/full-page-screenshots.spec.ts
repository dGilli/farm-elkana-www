import { test, expect } from '@playwright/test';

test('match page screenshot', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveScreenshot({ fullPage: true, timeout: 10000 });
});

