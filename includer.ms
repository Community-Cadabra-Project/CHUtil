execute(closure() {
    @model = associative_array()
    export('org.cadabra.msutil.includer', @model)
})

void proc _util_includer_register(string @id, string @path) {
    @model = import('org.cadabra.msutil.includer')
    if (array_index_exists(@model, @id)) {
        throw(IllegalArgumentException, "ID '@id' already exist")
    }
    @model[@id] = @path
}

void proc _util_includer_prev_register(string @id, int @stack = 1) {
    @model = import('org.cadabra.msutil.includer')
    if (array_index_exists(@model, @id)) {
        throw(IllegalArgumentException, "ID '@id' already exist")
    }
    @trace = get_stack_trace()
    #extract the path to the file relative  the folder from the stack
    @file = @trace[@stack]['file']
    @model[@id] = @file
}

string proc _util_includer_get_path(string @id) {
    @model = import('org.cadabra.msutil.includer')
    return(@model[@id])
}