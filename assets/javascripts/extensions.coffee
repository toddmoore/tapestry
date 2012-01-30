window.namespace = (namespaceString, func) ->
  namespaceParts = namespaceString.split '.'

  root = window
  for namespacePart in namespaceParts
    root[namespacePart] = new Object() if typeof(root[namespacePart]) == "undefined"
    root = root[namespacePart]

  func.apply(root) if func

window.instanceOf = ( object, klass ) ->
  return true if object.constructor == klass

  # NOTE: The __proto__ accessor is provided by all browsers except IE, but without it
  # ECMAScript provides no means to traverse the prototype tree. Also the base Object()
  # has no prototype. In these cases we may not be able to traverse further.
  return false if( object.__proto__ == null )
  return @instanceOf( object.__proto__, klass )

# stub out console for unsupporting browsers
console ?= {log: ->}

