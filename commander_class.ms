@util_commander_new_object = closure() {

    @self = array()

    # param @private_commands - ассоциативный массив зарегестрированных команд,
    #                           вызываемых по ключу  
                        
    @self['private_commands'] = array()

    foreach(@key: @value in @__util_commander_methods) {
        @self[@key] = @value
    }
    
    return(@self)
}

# METHODS
########################################################################################
@__util_commander_methods = array()

@__util_commander_methods['register'] = closure(@self, @key, closure @lymda) {
    @self['private_commands'][@key] = @lymda
}
@__util_commander_methods['register_proc'] = closure(@self, @key, string @proc_name) {
    _method2(@self, 'register' @key, closure(){call_proc(@proc_name, @arguments[0])})
}
@__util_commander_methods['unregister'] = closure(@self, @key) {
    array_remove(@self['private_commands'], @key)
}
@__util_commander_methods['execute'] = closure(@self, @key) {
    if (array_size(@arguments) > 2) {
        return(execute(@arguments[2..], @self['private_commands'][@key]))
    } else {
        return(execute(@self['private_commands'][@key]))
    }
}
@__util_commander_methods['clear'] = closure(@self) {
    @self['private_commands'] = array()
}
@__util_commander_methods['is_register'] = closure(@self, @key) {
    return(array_index_exists(@self['private_commands'], @key))
}
########################################################################################

if (import('script_log')) {
    console('MSUtil: commander_class.ms loaded', false)
}

