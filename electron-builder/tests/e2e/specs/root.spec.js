// https://docs.cypress.io/api/introduction/api.html

describe('Cypress Test', () => {
  it('Visits the app root url', () => {
    cy.visit('/')
    cy.contains('h1', 'Vue.js with electron-builder')
  })
})
