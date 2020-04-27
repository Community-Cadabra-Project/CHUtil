proc _private_util_commander_init_fields() {
    @self = array()

    # param @private_commands - ассоциативный массив зарегестрированных команд,
    #                           вызываемых по ключу  
                        
    @self['private_commands'] = array()

    return(@self)
}

proc _util_new_commander_object() {
    @self = _private_commander_init_fields()

    @self['register'] = closure(@key, closure @lymda) {
        @self['private_commands'][@key] = @lymda
    }

    @self['register_proc'] = closure(@key, string @proc_name) {
        execute(@key, closure(){call_proc(@proc_name, @arguments)}, @self['register'])
    }

    @self('unregister') = closure(@key) {
        array_remove(@self['private_commands'], @key)
    }

    @self['execute'] = closure(@key) {
        execute(@arguments, @self['private_commands'][@key])
    }
}

console('CHUtil: commander_class.ms loaded')

