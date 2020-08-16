array proc _private_util_log_import() {
    return(import('org.cadabra.msutil.log'))
}

void proc _util_log_register(string @key, string @prefix, array @outs) {
    @log = array()
    @log['prefix'] = @prefix
    @log['outs'] = @outs
    _private_util_log_import()['objects'][@key] = @log
}

array proc _util_log_get(string @key) {
    return(_private_util_log_import()['objects'][@key])
}

void proc _util_log(string @key, string @type, string @who, string @msg, mixed @args = null) {
    @log = _util_log_get(@key)
    @params = associative_array(
        type: @type,
        who: @who,
        msg: @msg,
        prefix: @log['prefix'],
        args: @args
    )
    @level = _private_util_log_import()['levels'][@type]
    foreach(@out in @log['outs']) {
        if (@level >= @out['level']) {
            execute(@params, @out['write'])
        }
    }
}

void proc _util_log_add_type(string @type, int @level) {
    _private_util_log_import()['levels'][@type] = @level
}

export('org.cadabra.msutil.log', array(
        objects: array(),
        levels: associative_array(
            'FATAL': 5000,
            'ERROR': 4000,
            'WARNING': 3000,
            'INFO': 2000,
            'DEBUG': 1000
        )
    )
)