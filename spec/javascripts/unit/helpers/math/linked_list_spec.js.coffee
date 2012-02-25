
#= require helpers/math/linked_list

describe 'helpers.math.LinkedList', ->

  LinkedList = helpers.math.LinkedList

  describe '#create', ->

    it 'should create instance of linked list', ->
      (expect LinkedList.create()).toEqual new LinkedList()


  describe 'defaults', ->

    beforeEach ->
      @list = LinkedList.create()

    it 'should have property head set to null', ->
      (expect @list.head).toBe null

    it 'should have property tail set to null', ->
      (expect @list.tail).toBe null

    it 'should set length to zero', ->
      (expect @list.length).toBe 0


  describe '#push', ->

    beforeEach ->
      @list = LinkedList.create()

    it 'should add element to the end of the list and set head and tail', ->
      element = {}

      @list.push element

      (expect @list.head).toBe element
      (expect @list.tail).toBe element

    it 'should append element to the existing last element and update tail', ->
      first = {}
      second = {}

      @list.push first
      @list.push second

      (expect @list.head).toBe first
      (expect @list.tail).toBe second

    it 'should link the current tail to new element', ->
      first = {}
      second = {}

      @list.push first
      @list.push second

      (expect first.next).toBe second
      (expect first.previous).toBe null

      (expect second.previous).toBe first
      (expect second.next).toBe null

    it 'should link together multiple elements', ->
      first = {}
      second = {}
      third = {}

      @list.push first
      @list.push second
      @list.push third

      (expect @list.head).toBe first
      (expect @list.head.next).toBe second
      (expect @list.tail.previous).toBe second
      (expect @list.tail).toBe third

    it 'should increase length property', ->
      @list.push {}
      (expect @list.length).toBe 1

      @list.push {}
      (expect @list.length).toBe 2


  describe '#remove', ->

    beforeEach ->
      @list = LinkedList.create()

    it 'should remove the last element and update head and tail', ->
      first = {}
      @list.push first

      @list.remove first

      (expect @list.head).toBe null
      (expect @list.tail).toBe null

    it 'should remove element between others and update links', ->
      first = {}
      second = {}
      third = {}

      @list.push first
      @list.push second
      @list.push third

      @list.remove second

      (expect @list.head).toBe first
      (expect @list.tail).toBe third
      (expect first.next).toBe third
      (expect third.previous).toBe first

    it 'should decrease length property', ->
      @element = {}
      @list.push @element

      @list.remove @element

      (expect @list.length).toBe 0


  describe '#insertBefore', ->

    beforeEach ->
      @list = LinkedList.create()

      @first = {}
      @second = {}
      @third = {}

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
