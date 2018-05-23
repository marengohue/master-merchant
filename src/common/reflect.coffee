Function::prop = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

Function::get = (prop, get) ->
  Object.defineProperty @prototype, prop, {get, configurable: yes}

Function::set = (prop, set) ->
  Object.defineProperty @prototype, prop, {set, configurable: yes}