#= require_tree .

$ = jQuery

$(document).ready ->
  $("#photo").tuckOnScroll()
  $("[data-toggle=class]").toggleClassOnClick()

$.fn.tuckOnScroll = (options) ->
  $(document).scroll =>
    fromTop = $(window).scrollTop() - 0
    fromBottom = $(document).height() - ($(window).scrollTop() + $(window).height())
    bottom = Math.min(fromTop, fromBottom)
    $(this).css(bottom: "#{-bottom}px")

$.fn.toggleClassOnClick = ->
  $(this).click ->
    target = $(this).data("target")
    klass  = $(this).data("class")
    $(target).toggleClass(klass)
