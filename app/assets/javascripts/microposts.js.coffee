$(document).ready ->
  if gon.charcount <= 10 and gon.charcount >= 0
    $("#char_count").removeClass "muted"
    $("#char_count").removeClass "text-error"
    $("#char_count").addClass "text-warning"
  else if gon.charcount < 0
    $("#char_count").removeClass "muted"
    $("#char_count").removeClass "text-warning"
    $("#char_count").addClass "text-error"
  else if gon.charcount > 10
    $("#char_count").removeClass "text-error"
    $("#char_count").removeClass "text-warning"
    $("#char_count").addClass "muted"