export(
    '__util_id_timer',
    array('id' : '(Util Timer)', 'count' : 0)
)

proc _util_interval(number @interval) {
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
    @timer_info = import('__util_id_timer')
    @name = @timer_info['id'].'-'.@timer_info['count']
    @timer_info['count']++
    if (@timer_info['count'] == 9223372036854775807) {
        @timer_info['count'] = 0
    }
    x_new_tracked_thread(@name, closure() {
        try {
            x_sleep(@delay)
            while(true) {
                execute(@lymda)
                x_sleep(@interval)
            }
        } catch(InterruptedException @e) {
            return()
        }
    }) 
    return(@name)
}

proc _util_clear_interval() {
    if (array_size(@arguments) == 0) {
        @cur_name = _util_get_cur_thread()
        if (string_contains(@cur_name, import('__util_id_timer')['id'])) {
            x_tracked_thread_interrupt(@cur_name)
        }
    } else {
        x_tracked_thread_interrupt(@arguments[0])
    }
}

proc _util_split_arg(string @arg, string @pref) {
    @args = split(" ", @arg)
    @len = length(@args)
    @len_pref = length(@pref)
    @sub_args = array()
    @key_arg = null
    @model = array()
    for(@i = 0, @i < @len, @i++) {
        if (@args[@i][0] == @pref) {
            if (!is_null(@key_arg)) {
                array_push(@model, array(@key_arg[cslice(@len_pref, -1)], @sub_args))
                @sub_args = array()
            }
            @key_arg = @args[@i]
        } else {
            array_push(@sub_args, @args[@i])
        }
    }
    if (!is_null(@key_arg)) {
        array_push(@model, array(@key_arg[cslice(@len_pref, -1)], @sub_args))
    }
    return(@model)
}

proc _util_sort_entries(array @array, @comp=closure(@l, @r){return(@l[0] > @r[0])}) {
    @temp_array = _unit_associative_to_entries(@array)
    array_sort(@temp_array, @comp)
    return(@temp_array)
}

proc _util_assoc_to_entries(array @array) {
    array @new_array = array()
    foreach(@key: @value in @array) {
        array_push(@new_array, array(@key, @value))
    }
    return(@new_array)
}

proc _util_entries_to_assoc(array @array) {
    array @map = array()
    foreach(@entry in @array) {
        @map[@entry[0]] = @entry[1]
    }
    return(@map)
}

proc _util_get_all_scripts(string @path) {
    @files = array()
    @list_files = list_files(@path)
    foreach(@file in @list_files) {
        if (string_contains(@file, '.')) {
            if (string_contains(@file, '.ms'), array_push(@files, @path.'\\'.@file))
        } else {
            array_push_all(@files, _util_get_all_scripts(@path.'\\'.@file))
        }
    }
    return(@files)
}

proc _util_get_all_files(string @path) {
    @files = array()
    @list_files = list_files(@path)
     foreach(@file in @list_files) {
        if (string_contains(@file, '.')) {
            array_push(@files, @path.'\\'.@file)
        } else {
            array_push_all(@files, _util_get_all_files(@path.'\\'.@file))
        }
    }
    return(@files)
}

proc _util_arrays_and(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @result = array()
    foreach(@val in @arr1) {
        if (array_contains(@arr2, @val), array_push(@result, @val))
    }
    return(@result)
}

proc _util_array_or(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @carr1 = @arr1[]
    @carr2 = @arr2[]
    @result = array()
    foreach(@val in @arr1) {
        if (!array_contains(@arr2, @val), array_push(@result, @val), array_remove(@arr2, @val))
    }
    array_push_all(@result, @carr2)
    return(@result)
}

proc _util_array_some_contains(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    foreach(@val in @arr2) {
        if (array_contains(@arr1, @val), return(true))
    }
    return(false)
}

proc _util_array_minus(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @result = array()
    foreach(@val in @arr1) {
        if (!array_contains(@arr2, @val), array_push(@result, @val))
    }
    return(@result)
}

proc _util_error(string @msg) {
    console(@msg, false)
    die()
}

proc _util_get_cur_thread() {
    return(x_get_current_thread()[16..])
}

if (import('script_log')) {
    console('MSUtil: proc.ms loaded', false)
}