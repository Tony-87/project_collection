// app.js
const Vue = require('vue')

module.exports = function createApp (context) {
  return new Vue({
    data: {
      url: context.url
    },
    template: `<html><head><meta charset="utf-8"></head> <div>访问的 URL 是： {{ url }}</div></html>`
  })
}