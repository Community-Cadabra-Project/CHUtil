proc _util_commander_init_self() {
    @self = array()

    # field @private_commands - ассоциативный массив зарегестрированных команд,
    #                           вызываемых по ключу  
                        
    @self['private_commands'] = array()

    return(@self)
}

proc _util_commander_register(@self, @key, closure @lymda) {
    @self['private_commands'][@key] = @lymda
}

proc _util_commander_register_proc(@self, @key, string @proc_name) {
    _util_commander_register(@self, @key, closure(){call_proc(@proc_name, @arguments)})
}

proc _util_commander_unregister(@self, @key) {
    array_remove(@self['private_commands'], @key)
}

proc _util_commander_execute(@self, @key) {
    if (array_size(@arguments) > 2) {
        return(execute(@arguments[2], @self['private_commands'][@key]))
    } else {
        return(execute(@self['private_commands'][@key]))
    }
}

proc _util_commander_clear(@self) {
    @self['private_commands'] = array()
}

proc _unit_commander_is_register(@self, @key) {
    return(array_index_exists(@self['private_commands'], @key))
}

if (import('script_log')) {
    console('CHUtil: commander_api.ms loaded')
}