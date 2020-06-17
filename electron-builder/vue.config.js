// See https://nklayman.github.io/vue-cli-plugin-electron-builder/guide/configuration.html

module.exports = {
  pluginOptions: {
    electronBuilder: {
      outputDir: 'dist', // overriding default "dist_electron"
      builderOptions: {
        appId: 'com.dockerian.digitags',
        productName: 'digitags',
        copyright: 'Copyright © 2020 Dockerian',
        directories: {
          output: './dist'
        }
      }
    }
  }
}
