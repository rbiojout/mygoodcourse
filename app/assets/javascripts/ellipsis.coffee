document.addEventListener 'turbolinks:load', ->
  $('.ellipsis').dotdotdot({
    watch: "window"
  })
  return