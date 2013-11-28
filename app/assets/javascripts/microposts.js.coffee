$ ->
  $("#micropost_listing th a, #micropost_listing .pagination a").live "click", ->
    $.getScript @href
    false