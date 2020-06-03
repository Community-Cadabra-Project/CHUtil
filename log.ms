string proc _private_util_log_name() {
    return('__UTIL_LOGS')
}

array proc _private_util_log_import() {
    return(import(_private_util_log_name()))
}

void proc _util_log_register(string @key, string @prefix = '', array @outs = array(closure(@msg) {console(@msg, false)}), array @types = _private_util_log_import()['enum']) {
    @log = array()
    @log['prefix'] = @prefix
    @log['outs'] = @outs
    @log['types'] = @types
    _private_util_log_import()['objects'][@key] = @log
}

array proc _util_log_get(string @key) {
    return(_private_util_log_import()['objects'][@key])
}

void proc _util_log(string @key, string @type, string @msg) {
    @log = _util_log_get(@key)
    if (array_contains(@log['types'], @type)) {
        @full_msg = @log['prefix'].': ['.@type.'] '.@msg
        foreach(@out in @log['outs']) {
            execute(@full_msg, @out)
        }
    }
}

export(_private_util_log_name(), array(
        objects: array(),
        enum: array('FATAL', 'ERROR', 'WARNING', 'INFO', 'DEBUG')
    )
)