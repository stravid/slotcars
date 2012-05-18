
Shared.LinkedList = Ember.Object.extend

  head: null
  tail: null
  length: 0

  push: (element) ->

    if @tail?
      # link with existing tail
      element.previous = @tail
      @tail.next = element

    @tail = element
    element.next = null

    unless @head?
      @head = element
      @head.previous = null

    @length += 1

  remove: (element) ->

    @length -= 1

    # last element is special case
    if element is @head and element is @tail
      @head = @tail = null
      return

    if element.next?
      if element.previous?
        element.next.previous = element.previous
      else
        element.next.previous = null
        @head = element.next

    if element.previous?
      if element.next?
        element.previous.next = element.next
      else
        element.previous.next = null
        @tail = element.previous


  insertBefore: (before, element) ->
    if before is @head
      @head = element
    else
      before.previous.next = element

    element.next = before
    element.previous = before.previous

    before.previous = element

    @length += 1

  clear: ->
    @head = null
    @tail = null
    @length = 0

  getCircularNextOf: (element) ->
    if element is @tail then @head else element.next

  getCircularPreviousOf: (element) ->
    if element is @head then @tail else element.previous
