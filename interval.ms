export(
    'org.cadabra.msutil.interval',
    array('id' : '(Util Timer)', 'count' : 0)
)

string proc _util_interval(number @interval) {
    int @delay = 0
    closure @lymda
    @size = array_size(@arguments)
    if (@size < 2) {
        return()
    } else if (@size < 3) {
        if (!is_closure(@arguments[1])) {
            throw(
                CastException,
                'Procedure "_unit_interval" expects a value of type ms.lang.closure in argument 2, but a value of type '.typeof(@arguments[1]).' was found instead.'
                )
        }
        @lymda = @arguments[1]
    } else {
         if (!is_integer(@arguments[1])) {
            throw(
                CastException,
                'Procedure "_unit_interval" expects a value of type ms.lang.closure in argument 2, but a value of type '.typeof(@arguments[1]).' was found instead.'
                )
        }
        if (!is_closure(@arguments[2])) {
            throw(
                CastException,
                'Procedure "_unit_interval" expects a value of type ms.lang.closure in argument 3, but a value of type'.typeof(@arguments[2]).'was found instead.'
                )
        }
        @delay = @arguments[1]
        @lymda = @arguments[2]
    }
    @timer_info = import('org.cadabra.msutil.interval')
    @name = @timer_info['id'].'-'.@timer_info['count']
    @timer_info['count']++
    if (@timer_info['count'] == 9223372036854775807) {
        @timer_info['count'] = 0
    }
    x_new_thread(@name, closure() {
        try {
            sleep(@delay)
            while(true) {
                execute(@lymda)
                sleep(@interval)
            }
        } catch(InterruptedException @e) {
            return()
        }
    }) 
    return(@name)
}

void proc _util_clear_interval(@id) {
    x_interrupt(@id)
}