array proc _private_util_log_import() {
    return(import('org.cadabra.msutil.log'))
}

void proc _util_log_register(string @key, string @prefix = '', array @outs = array(closure(@msg) {console(@msg, false)}), array @types = array('FATAL', 'ERROR', 'WARNING', 'INFO', 'DEBUG')) {
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

export('org.cadabra.msutil.log', array(
        objects: array()
    )
)