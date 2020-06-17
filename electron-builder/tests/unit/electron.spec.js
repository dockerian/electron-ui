/**
 * @jest-environment node
 */
import spectron from 'spectron'
import { testWithSpectron } from 'vue-cli-plugin-electron-builder'
jest.setTimeout(50000)

const options = {
  // Disables launching of Spectron. Enable this if you want to launch spectron yourself.
  noSpectron: false,
  // Do not start Spectron app or wait for it to load. You will have to call app.start() and app.client.waitUntilWindowLoaded() before running any tests.
  noStart: false,
  // Run dev server in development mode. By default it is run in production (serve --mode production).
  forceDev: false,
  // Set custom Vue env mode.
  mode: 'test',
  // Custom options to be passed to Spectron. Defaults are already set, only use this if you need something customized.
  spectronOptions: {
    args: [],
    chromeDriverArgs: ['--headless'], // headless not working
    env: {}
  }
}

test('Load App Window Properly', async () => {
  // Wait for dev server to start
  const { app, stopServe } = await testWithSpectron(spectron, options)
  const win = app.browserWindow
  const client = app.client

  // Window was created
  expect(await client.getWindowCount()).toBe(1)
  // It is not minimized
  expect(await win.isMinimized()).toBe(false)
  // Window is visible
  expect(await win.isVisible()).toBe(true)
  // Size is correct
  const { width, height } = await win.getBounds()
  expect(width).toBeGreaterThan(0)
  expect(height).toBeGreaterThan(0)
  // App is loaded properly
  expect(
    /Vue\.js with electron-builder/.test(
      await client.getHTML('#app')
    )
  ).toBe(true)

  await stopServe()
})
