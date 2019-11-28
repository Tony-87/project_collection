const Vue = require('vue')
const server = require('express')()
const vserver = require('vue-server-renderer')

const indexRenderer = vserver.createRenderer({
  template: require('fs').readFileSync('./demo2.template.html', 'utf-8')
})


server.get('*', (req, res) => {
  const app = new Vue({
    data: {
      url: req.url
    },
    template: `<div>
                <h1>这是模板渲染的</h1>
                <h2>访问的 URL 是： {{ url }}</h2>
              </div>`
  })

  indexRenderer.renderToString(app, (err, html) => {
    // console.log(html) // html 将是注入应用程序内容的完整页面
    if (err) {
      res.status(500).end('Internal Server Error')
      return
    }
    res.end(html)
  })

})

server.listen(8080)
console.log('server is on localhost:8080')