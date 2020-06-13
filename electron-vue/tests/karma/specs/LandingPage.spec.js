import Vue from 'vue'
import LandingPage from '@/components/LandingPage'
import router from '../../../src/renderer/router'

describe('LandingPage.vue', () => {
  it('should render correct contents', () => {
    const vm = new Vue({
      router,
      el: document.createElement('div'),
      render: h => h(LandingPage)
    }).$mount()

    expect(vm.$el.querySelector('.title').textContent)
      .to.contain('Dockerian ^=^ Electron Demo Project')
  })
})
