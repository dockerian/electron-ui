'use strict'

const path = require('path')
const merge = require('webpack-merge')
const webpack = require('webpack')

const baseConfig = require('../../.electron-vue/webpack.renderer.config')
const projectRoot = path.resolve(__dirname, '../../src/renderer')

// Set BABEL_ENV to use proper preset config
process.env.BABEL_ENV = 'test'

let webpackConfig = merge(baseConfig, {
  devtool: '#inline-source-map',
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': '"testing"'
    })
  ]
})

// don't treat dependencies as externals
delete webpackConfig.entry
delete webpackConfig.externals
delete webpackConfig.output.libraryTarget

// apply vue option to apply isparta-loader on js
webpackConfig.module.rules
  .find(rule => rule.use.loader === 'vue-loader').use.options.loaders.js = 'babel-loader'

module.exports = config => {
  config.set({
    browsers: ['electron'],
    client: {
      useIframe: false
    },
    coverageReporter: {
      dir: '../../coverage',
      reporters: [
        { type: 'html', subdir: 'html' },
        { type: 'lcov', subdir: '.' },
        { type: 'text-summary' }
      ]
    },
    customLaunchers: {
      customElectron: {
        base: 'Electron',
        // userDataDir: __dirname + '/.electron',
        // require: __dirname + '/main-fixtures.js'
        browserWindowOptions: {
          show: false
        }
      },
      chrome: {
        base: 'Chrome',
        flags: [
          '--headless',
          '--disable-gpu',
          '--disable-web-security',
          '--disable-site-isolation-trials',
          '--remote-debugging-port-9222'
        ]
      },
      electron: {
        base: 'Electron',
        flags: '' // ['--show']
      }
    },
    frameworks: ['mocha', 'chai'],
    files: ['./index.js'],
    preprocessors: {
      './index.js': ['webpack', 'sourcemap']
    },
    reporters: ['spec', 'coverage'],
    singleRun: true,
    webpack: webpackConfig,
    webpackMiddleware: {
      noInfo: true
    }
  })
}
