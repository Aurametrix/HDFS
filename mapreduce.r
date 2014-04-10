# ----------------------------------------------------------------------
# Function: mapReduce
#   mapReduce pattern implemented on an R data structure 
#   (array data.frame matrix) 
#
# map: the map step evaluated on the data structure
# ...: The Reduce step can be one or more functions with optional names 
#      evaluated on the split data.  name=function.
# data: the R data structure  
# Returns a matrix or data.frame.
# ----------------------------------------------------------------------

mapReduce <- function( map, ..., data=NULL, apply=sapply ) {

    if( is.null(data) ) 
      stop( "You must explicitly provide data using the data argument" ) 

    m <- match.call( expand.dots=FALSE )
    map <- eval( m$map, data )

  # The dots will be the expression that gets evaluated.
    expr = m$`...`

  # Split data ... this is important since each of the features
  # will operate on the split data.  This is also the most time
  # consuming part of the process.
  # because split is a poor function
    if( class(data) == "list" ) {
      split.data <- data
    } else {
      split.data <- split( data, map )
    }

  # innerFun: Evaluates expression 
    innerFun = function( entity.data, expr ) {
        eval( expr, entity.data )
    }    

  # outerFun: Split data based on map  
    outerFun = function( expr, split.data ) {
      sapply(
        # split( data, map ) , 
        split.data  ,
        innerFun ,
        expr
      )
    }

  # RETURN:
    ret=apply( 
      expr ,  # Elimanates call
      outerFun ,  # Contains inner function
      split.data 
    )

    # detach(data)
    return(ret)
}



