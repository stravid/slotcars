describe 'Shared.LinkedList', ->

  beforeEach ->
    @list = Shared.LinkedList.create()

    @first = {}
    @second = {}
    @third = {}

  describe 'defaults', ->

    it 'should have property head set to null', ->
      (expect @list.head).toBe null

    it 'should have property tail set to null', ->
      (expect @list.tail).toBe null

    it 'should set length to zero', ->
      (expect @list.length).toBe 0


  describe '#push', ->

    it 'should add element to the end of the list and set head and tail', ->
      @list.push @first

      (expect @list.head).toBe @first
      (expect @list.tail).toBe @first

    it 'should append element to the existing last element and update tail', ->
      @list.push @first
      @list.push @second

      (expect @list.head).toBe @first
      (expect @list.tail).toBe @second

    it 'should link the current tail to new element', ->
      @list.push @first
      @list.push @second

      (expect @first.next).toBe @second
      (expect @first.previous).toBe null

      (expect @second.previous).toBe @first
      (expect @second.next).toBe null

    it 'should link together multiple elements', ->
      @list.push @first
      @list.push @second
      @list.push @third

      (expect @list.head).toBe @first
      (expect @list.head.next).toBe @second
      (expect @list.tail.previous).toBe @second
      (expect @list.tail).toBe @third

    it 'should increase length property', ->
      @list.push {}
      (expect @list.length).toBe 1

      @list.push {}
      (expect @list.length).toBe 2


  describe '#remove', ->

    it 'should remove the last element and update head and tail', ->
      @list.push @first

      @list.remove @first

      (expect @list.head).toBe null
      (expect @list.tail).toBe null

    it 'should remove element between others and update links', ->
      @list.push @first
      @list.push @second
      @list.push @third

      @list.remove @second

      (expect @list.head).toBe @first
      (expect @list.tail).toBe @third
      (expect @first.next).toBe @third
      (expect @third.previous).toBe @first

    it 'should decrease length property', ->
      @list.push @first

      @list.remove @first

      (expect @list.length).toBe 0


  describe '#insertBefore', ->

    beforeEach ->
      @list.push @first
      @list.push @second
      @list.push @third

    it 'should insert the element as head', ->
      inserted = {}
      @list.insertBefore @first, inserted

      (expect @list.head).toBe inserted
      (expect @first.previous).toBe inserted

    it 'should insert the element between others', ->
      inserted = {}
      @list.insertBefore @second, inserted

      (expect @first.next).toBe inserted
      (expect @second.previous).toBe inserted
      (expect inserted.previous).toBe @first
      (expect inserted.next).toBe @second

    it 'should increase length property', ->
      length = @list.length
      @list.insertBefore @third, {}

      (expect @list.length).toBe 4


  describe '#clear', ->

    it 'should set head and tail to null and length to zero', ->
      @list.push {}
      @list.push {}

      @list.clear()

      (expect @list.head).toBe null
      (expect @list.tail).toBe null
      (expect @list.length).toBe 0


  describe '#getCircularNextOf', ->

    beforeEach ->
      @list.push @first
      @list.push @second
      @list.push @third

    it 'should return the next element', ->
      (expect @list.getCircularNextOf @second).toBe @third

    it 'should return head element for tail', ->
      (expect @list.getCircularNextOf @third).toBe @first


  describe '#getCircularPreviousOf', ->

    beforeEach ->
      @list.push @first
      @list.push @second
      @list.push @third

    it 'should return the previous element', ->
      (expect @list.getCircularPreviousOf @second).toBe @first

    it 'should return tail element for head', ->
      (expect @list.getCircularPreviousOf @first).toBe @third