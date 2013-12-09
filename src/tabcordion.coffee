###
- Currently only supports data-target on the tabs, not href
###

$.fn.tabcordion = (option) ->
  return this.each ->
    $this = $(this)
    options = typeof option == 'object' && option
    data = $this.data('tabcordion') || new Tabcordion(this, options)
    if typeof option == 'string'
      data[option]()
    else if typeof option == 'number'
      data.index(option)

$.fn.tabcordion.defaults =
  resizeEl: null # defaults to el
  onResize: true
  delay: 500
  breakWidth: 768
  tabs:
    minWidth: null
    class: 'tabbable'
    listClass: 'nav nav-tabs'
    itemClass: ''
    bodyClass: 'tab-pane' # fade
  accordion:
    maxWidth: null
    class: 'accordion'
    listClass: 'nav'
    itemClass: 'accordion-group'
    bodyClass: 'accordion-body collapse'
  activeClass: 'active in'
  # can be used to define a method that will schedule the call to onResize
  scheduler: null

class Tabcordion
  constructor: (el, options) ->
    @$el = $(el);
    @options = $.extend {}, $.fn.tabcordion.defaults, {resizeEl: @$el}, options
    @options.tabs.minWidth = @options.breakWidth unless @options.tabs.minWidth?
    @options.accordion.maxWidth = @options.breakWidth unless @options.accordion.maxWidth?
    # set up the initial tabbed state
    @$el.addClass(@options.tabs.class)
      .find('> .tab-content > *')
      .addClass(@options.tabs.bodyClass)
    @$el.find('> ul > li > a').attr('data-toggle', 'tab')
    @$el.data('tabcordion', this)
    if listClass = @$el.find('> ul').attr('class')
      @options.tabs.listClass += ' ' + listClass
    if @options.onResize
      @proxy = $.proxy @eventHandler, this
      $(window).on 'resize', @proxy
    @onResize()
    @initialized = true

  index: (i)->
    if @$el.hasClass @options.tabs.class
      for set in [@$el.find('.tab-content > *'), @$el.find('.nav-tabs > *')]
        if set.length > i
          set.removeClass('active')
            .slice(i, i + 1).addClass('active')
    else
      @$el.find('.accordion-body, .accordion-toggle')
        .removeClass('active in')
      $items = @$el.find('.accordion-group')
        .removeClass('active')
      $item = $items.slice(i, i + 1)
      $item.addClass(@options.activeClass)
        .find('.accordion-heading > .accordion-toggle')
        .addClass(@options.activeClass)

  eventHandler: (e)->
    clearTimeout @timeout if @timeout
    @timeout = setTimeout =>
      if @options.scheduler
        @options.scheduler =>
          @onResize(e)
      else
        @onResize(e)
    , @options.delay

  onResize: () ->
    width = $(@options.resizeEl).width()
    if width < @options.tabs.minWidth
      @accordion()
    else if width > @options.accordion.maxWidth
      @tabs()

  tabs: ->
    unless @initialized
      return @$el.find('> ul.nav a').tab().on 'click', ->
        $(this).tab('show')
    if @$el.hasClass @options.tabs.class
      return
    @$el.removeClass(@options.accordion.class)
      .addClass(@options.tabs.class)

    $list = @$el.find('> ul.nav')
      .removeClass(@options.accordion.listClass)
      .addClass(@options.tabs.listClass)
    $tabContent = @$el.find('.tab-content').css('display', 'block')
    $list.parent().append($tabContent)

    $list.children()
      .removeClass(@options.accordion.itemClass)
      .addClass(@options.tabs.itemClass)
      .each (i, el)=>
        $navItem = $(el)
        $link = $navItem.find('.accordion-heading a')
        $link.attr('data-toggle', 'tab')

        $content = $($link.attr('data-target'))
          .removeClass('fade')

        $inner = $content.find('> .accordion-inner').remove()
        $content.append($inner.children())
        
        $navItem
          .children().remove().end()
          .append($link)

        $tabContent.append($content)
        @switchContent $link, $content, @options.accordion, @options.tabs
        $link.tab()

  accordion: ->
    if @$el.hasClass @options.accordion.class
      return
    @$el.removeClass(@options.tabs.class)
      .addClass(@options.accordion.class)
    
    $list = @$el.find('> ul.nav')
      .removeClass(@options.tabs.listClass)
      .addClass(@options.accordion.listClass)
    $list.parent().append($list)
    $tabContent = @$el.find('.tab-content').css('display', 'none')

    $navItems = $list.children()
    $navItems
      .removeClass(@options.tabs.itemClass)
      .addClass(@options.accordion.itemClass)
      .each (i, el)=>
        $navItem = $(el)
        $link = $navItem.find('a')
        $content = $($link.attr('data-target'))
        
        $heading = $('<div class="accordion-heading" />').append($link);
        $content.append($('<div class="accordion-inner" />').append($content.children()))
        
        if !$content.attr 'id'
          $content.attr 'id', Tabcordion.generateId 'body'
        
        $link.addClass('accordion-toggle')
        $link.attr('data-toggle', 'collapse')
        $link.attr('data-target', '#' + $content.attr('id'))
        $link.data('parent', @$el)

        $navItem.append($heading)
          .append($content)
        @switchContent $link, $content, @options.tabs, @options.accordion
        true

  switchContent: ($link, $content, from, to) ->
    switchToTab = (to.bodyClass == @options.tabs.bodyClass)
    isActive = $content.hasClass('active')
    $content
      .removeClass(from.bodyClass)
      .addClass(to.bodyClass)
    if isActive
      $link.addClass @options.activeClass
      $content.addClass @options.activeClass
    else
      $link.removeClass @options.activeClass
      $content.removeClass @options.activeClass
    $link.on 'click', (e)->
      e.preventDefault()
    $content.collapse
      parent: @$el.find('> ul')
      toggle: false
    if switchToTab
      $content.collapse('reset')
    else
      $content.height if isActive then 'auto' else 0
      $content.collapse()
    return isActive

  getItems: ->
    @$el.find '.nav > li a[data-target]'

  destroy: ->
    $(window).off 'resize', @proxy if @proxy

$.extend Tabcordion,
  idSuffix: 1
  generateId: (suffix) ->
    loop
      id = "tabcordion-#{suffix}-#{Tabcordion.idSuffix++}"
      break if $('#' + id).length == 0
    return id
