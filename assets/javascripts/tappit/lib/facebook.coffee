namespace 'Tappit.Lib'

class Tappit.Lib.FacebookConnection extends Backbone.Model
  @_sdkMarkup = '''
  <div id="fb-root"></div>
  <script src="//connect.facebook.net/en_US/all.js" async="true"></script>
  '''

  status: 'unconnected'

  connect: ->
    deferred = new $.Deferred()

    window.fbAsyncInit = =>
      @initFBApi()
      @trigger 'facebook:connected'

   	$('body').append(FacebookConnection._sdkMarkup) unless $('#fb-root').length > 0
    
    deferred

  initFBApi: ->
    if !appId = Tappit.Config.facebook.appId then raise "A Facebook App Id must be specified in configuration"
    
    console.log appId

