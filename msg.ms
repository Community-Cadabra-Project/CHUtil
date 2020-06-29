proc _util_msg_register_module(string @module, string @path) {
    @model = import('org.cadabra.msutil.msg')
    @model[@module] = array()
    @model[@module]['path'] = length(@path)
}

proc _util_msg_register_file(string @module, array @msg) {
    @model = import('org.cadabra.msutil.msg')
    @model[@module]['msg'][@msg['name']] = @msg['msg']
}

string proc _util_msg(@module, @key, @stack = 1, @args = array()) {
    @model = import('org.cadabra.msutil.msg')[@module]
    @trace = get_stack_trace()
    #extract the path to the file relative  the folder from the stack
    @file = @trace[@stack]['file'][cslice(@model['path']+1, -1)]
    return(sprintf(@model['msg'][@file][@key], @args))
}

export('org.cadabra.msutil.msg', array())