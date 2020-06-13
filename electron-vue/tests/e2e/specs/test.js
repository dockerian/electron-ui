// https://docs.cypress.io/api/introduction/api.html

describe('Electron-vue app prototype', () => {
  it('Visits the app root url', () => {
    cy.visit('/')
    cy.contains('h1', 'Dockerian ^=^ Electron Demo Project')
  })
})
