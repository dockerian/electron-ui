# electron-vue

> **NOTE**: deprecated due to outdated templates and dependencies.
> Remain as an electron-vue app example with tests.
> * run build, dev and prod (okay)
> * run unit tests with karma or jest (okay)
> * run lint (failed) or lint:fix (okay)
> * run e2e (misconfigured/failed)


<a name="contents">
## Contents

* [Build Setup](#build-setup)
* [Project Notes](#project-notes)
* [Research](#research)


<a name="build-setup"><br/>
## Build Setup

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:9080
npm run dev

# build electron application for production
npm run build

# lint all JS/Vue component files in `src/`
npm run lint

```


<a name="project-notes"><br/>
## Project Notes

### Note[electron-vue]

This project was generated with [electron-vue](https://github.com/SimulatedGREG/electron-vue)@[45a3e22](https://github.com/SimulatedGREG/electron-vue/tree/45a3e224e7bb8fc71909021ccfdcfec0f461f634) using [vue-cli](https://github.com/vuejs/vue-cli). See [documentation](https://simulatedgreg.gitbooks.io/electron-vue/content/index.html).

```bash
npm install -g vue-cli
# create new project without e2e and unit testing yet
vue init simulatedgreg/electron-vue app-name
```

### Update packages

```bash
npm rm electron
npm install -D electron
npm install -D @vue/cli-service
npm install -D eslint-plugin-vue

# fix `npm audit` issues
npm install -D copy-webpack-plugin@6.0.2
npm install -D css-loader@3.6.0
# remove multispinner due to high vulnerability risk
# see https://github.com/SimulatedGREG/electron-vue/issues/924
# npm uninstall multispinner

vue add e2e-cypress
vue add unit-jest
```

### Karma and mocha tests

For unit testing with karma, run

```bash
npm install -D \
  karma karma-chai karma-coverage karma-mocha \
  karma-sourcemap-loader karma-spec-reporter karma-webpack \
  karma-chrome-launcher karma-electron \
  mocha chai
```

For e2e testing with mocha and spectron, run

```bash
npm install -D chai mocha spectron require-dir
```

### Fixes

Based on an [Auth0 blog](https://auth0.com/blog/electron-tutorial-building-modern-desktop-apps-with-vue-js/), there needs some [changes](https://github.com/auth0-blog/electron-vue/commit/be9ed797140c711c053c9b16dd2a029aacf72266) in order to make "electron-vue" working with the latest Electron.

* add to "`new HtmlWebpackPlugin`" ("`.electron-vue/webpack.renderer.config.js`")

  ```js
  let rendererConfig = {
    plugins: [
      new HtmlWebpackPlugin({
        ...
        isBrowser: false,
        isDevelopment: process.env.NODE_ENV !== 'production',
        ...
      }),
    ]
  }
  ```

* change "`CopyWebpackPlugin`" parameters:

  ```js
  new CopyWebpackPlugin({
    patterns: [{
      ...
    }]
  }),
  ```
  **Note**: `CopyWebpackPlugin` API changed since webpack 4. See [webpack](https://webpack.js.org/plugins/copy-webpack-plugin/) doc.

* replace the contents of the `<body>` element ("`./src/index.ejs`"):

  ```html
  <div id="app"></div>
  <!-- Set `__static` path to static files in production -->
  <% if (!htmlWebpackPlugin.options.isBrowser && !htmlWebpackPlugin.options.isDevelopment) { %>
    <script>
      window.__static = require('path').join(__dirname, '/static').replace(/\\/g, '\\\\')
    </script>
  <% } %>
  ```

* add "`webPreferences`" to "`src/main/index.js`":

  ```js
  // find the createWindow function definition
  function createWindow () {
    // add the webPreferences property passed to BrowserWindow
    mainWindow = new BrowserWindow({
      height: 563,
      useContentSize: true,
      width: 1000,
      webPreferences: {
        nodeIntegration: true,
        nodeIntegrationInWorker: true
      }
    })
  }
  ```


<a name="research"><br/>
## Research

* [Electron with Vue - Auth0 blog](https://community.auth0.com/t/electron-tutorial-building-modern-desktop-apps-with-vue-js/32627/26)
* [Electron & Vue.js quick start boilerplate](https://github.com/kdydesign/vue-electron)
* [Vue with Electron (example)](https://codesource.io/build-a-desktop-application-with-vuejs-and-electronjs/)
* [Bit](https://bit.dev/) | [source](https://github.com/teambit/bit) for reusable components
* [Made-with-VueJS #Boilerplate](https://madewithvuejs.com/boilerplate)
* [VueJS Boilerplates](https://blog.bitsrc.io/10-top-vuejs-boilerplates-for-2020-c70192003d20)
  - [Electron-nuxt](https://github.com/michalzaq12/electron-nuxt)
  - [Mevn-CLI](https://mevn.madlabs.xyz/) | [source](https://github.com/madlabsinc/mevn-cli)
  - [Vue Enterprise Boilerplate](https://github.com/chrisvfritz/vue-enterprise-boilerplate)
  - [Vuetify](https://vuetifyjs.com/en/) | [source](https://github.com/vuetifyjs/vuetify) - Material Component Framework for Vue
  - [Vuesion](https://github.com/vuesion/vuesion)


&raquo; Back to <a href="/">Home</a> | <a href="#contents">Contents</a> &laquo;
