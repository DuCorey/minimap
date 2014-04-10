
#
#   .............
#   .           .------------> Minimap Scroller
#   ---------   .
#   |       |----------> Minimap Wrapper
#   |       |   .
#   |       |   .
#   #########------> Minimap Indicator (Minimap visible area)
#   |       |   .
#   ---------   .
#   .           .
#   .............
#
#  Basic Rectangle
#
class Rectangle
  constructor: (@x = 0, @y = 0, @width = 0, @height = 0) ->

#
#  Wrapper - Minimap
#
class Wrapper extends Rectangle

#
#  Scroller - Minimap Editor ScrollView
#
class Scroller extends Rectangle

#
#  Indicator - Minimap Visible Area
#
module.exports =
class Indicator extends Rectangle

  constructor: ->
    super

    @ratioX = 1
    @ratioY = 1
    @wrapper = new Wrapper()
    @scroller = new Scroller()

  setWrapperSize: (width, height) ->
    @wrapper.width = width
    @wrapper.height = height

  setScrollerSize: (width, height) ->
    @scroller.width = width
    @scroller.height = height
    @scroller.maxScrollX = Math.max 0, @scroller.width - @wrapper.width
    @scroller.maxScrollY = Math.max 0, @scroller.height - @wrapper.height

  updateMaxPos: (@maxPosX, @maxPosY) ->

  updateBoundary: ->
    @minBoundaryX = 0
    @maxBoundaryX = @maxPosX

    @minBoundaryY = 0
    @maxBoundaryY = @maxPosY

  updateRatio: ->
    @ratioX = @x / (@scroller.width - @width)
    @ratioY = @y / (@scroller.height - @height)

  updateScrollerPosition: ->
    @scroller.x = - @ratioX * @scroller.maxScrollX
    @scroller.y = - @ratioY * @scroller.maxScrollY

  updatePosition: ->
    x = Math.round @ratioX * @scroller.maxScrollX
    y = Math.round @ratioY * @scroller.maxScrollY

    x = @calBoundaryX x
    y = @calBoundaryY y

  calBoundaryX: (x) ->
    x = Math.max @minBoundaryX, x
    x = Math.min @maxBoundaryX, x

  calBoundaryY: (y) ->
    y = Math.max @minBoundaryY, y
    y = Math.min @maxBoundaryY, y

  setCenterX: (cx) ->
    x = cx - @width / 2
    @calBoundaryX x

  setCenterY: (cy) ->
    y = cy - @height / 2
    @calBoundaryY y

  computeFromCenterX: (cx) ->
    @setCenterY cx - @scroller.x

  computeFromCenterY: (cy) ->
    @setCenterY cy - @scroller.y
