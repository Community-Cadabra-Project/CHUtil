@util_new_commander_object = closure() {

    @self = array()

    # param @private_commands - ассоциативный массив зарегестрированных команд,
    #                           вызываемых по ключу  
                        
    @self['private_commands'] = array()

    foreach(@key: @value in @__util_methods_commander) {
        @self[@key] = @value
    }
    
    return(@self)
}

# METHODS
########################################################################################
@__util_methods_commander = array()

@__util_methods_commander['register'] = closure(@self, @key, closure @lymda) {
    @self['private_commands'][@key] = @lymda
}
@__util_methods_commander['register_proc'] = closure(@self, @key, string @proc_name) {
    _method2(@self, 'register' @key, closure(){call_proc(@proc_name, @arguments)})
}
@__util_methods_commander['unregister'] = closure(@self, @key) {
    array_remove(@self['private_commands'], @key)
}
@__util_methods_commander['execute'] = closure(@self, @key) {
    execute(@arguments, @self['private_commands'][@key])
}
@__util_methods_commander['clear'] = closure(@self) {
    @self['private_commands'] = array()
}
@__util_methods_commander['is_register'] = closure(@self, @key) {
    return(array_index_exists(@self['private_commands'], @key))
}
########################################################################################

if (import('script_log')) {
    console('CHUtil: commander_class.ms loaded')
}

