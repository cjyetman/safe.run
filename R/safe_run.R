# Safe Run Current Selection
safe_run <-
  function() {
    context <- rstudioapi::getActiveDocumentContext()
    command <- paste0('{\n', context$selection[[1]]$text, '\n}')
    rstudioapi::sendToConsole(command)
  }
