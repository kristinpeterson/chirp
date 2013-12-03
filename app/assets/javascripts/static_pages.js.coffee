# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

###
@desc Counts down characters in textarea, changing text and style of #char_count when count reaches certain limits
@param {Textarea object} textarea
@return {void}
###
root = exports ? this
root.countChars = (textarea) ->
  micropost = textarea.value
  len = micropost.length
  charCount = 140 - len
  $("#char_count").text charCount
  $("#charcount").val charCount
  if charCount <= 10 and charCount > 0
    $("#char_count").removeClass "muted"
    $("#char_count").removeClass "text-error"
    $("#char_count").addClass "text-warning"
  else if charCount < 0
    $("#char_count").removeClass "muted"
    $("#char_count").removeClass "text-warning"
    $("#char_count").addClass "text-error"
  else if charCount > 10
    $("#char_count").removeClass "text-error"
    $("#char_count").removeClass "text-warning"
    $("#char_count").addClass "muted"