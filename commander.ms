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
    @self['private_commands'][@key] = closure(@array) {
        return(call_proc_array(@proc_name, @array))
    }
}

proc _util_commander_unregister(@self, @key) {
    array_remove(@self['private_commands'], @key)
}

proc _util_commander_execute(@self, @key) {
    if (!array_index_exists(@self['private_commands'], @key)) {
        throw(IllegalArgumentException, "Command '@key' not registered!")
    }
    @command = @self['private_commands'][@key]
    if (array_size(@arguments) > 2) {
        return(execute(@arguments[2..], @command))
    } else {
        return(execute(@command))
    }
}

proc _util_commander_clear(@self) {
    @self['private_commands'] = array()
}

proc _unit_commander_is_register(@self, @key) {
    return(array_index_exists(@self['private_commands'], @key))
}