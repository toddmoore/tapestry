window.Tappit ?= {} # Do this manually because namespace() isn't defined yet

class Tappit.Application
  _.extend this.prototype, Backbone.Events
  #_.extend this.prototype, LiveWeb.Lib.RouteConstructor.prototype

  constructor: ->
    @facebook = new Tappit.Lib.FacebookConnection


  start: ->
    deferred = new $.Deferred()
    $.when(@facebook.connect()).then =>
      alert("connected")


    
    
		
