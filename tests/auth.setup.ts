/**
 * Copyright 2024 Defense Unicorns
 * SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial
 */

import { test as setup, expect } from '@playwright/test';
import { authFile } from './playwright.config';
import dotenv from 'dotenv';

dotenv.config();

const password = process.env.PASSWORD

setup('authenticate', async ({ page }) => {
  await page.goto('/ui/login/');

  await page.locator('input[name="username"]').fill('admin');
  await page.locator('input[name="password"]').fill(password);
  await page.getByRole('button', { name: "Login" }).click();

  await page.waitForURL('/ui/admin/onboarding-page');  // successful redirect

  await page.context().storageState({ path: authFile });

  await expect(page).toHaveURL('/ui/admin/onboarding-page');
})
