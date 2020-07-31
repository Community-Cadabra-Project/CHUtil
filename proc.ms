array proc _util_split_arg(string @arg, string @pref) {
    @args = split(" ", @arg)
    @len = length(@args)
    @len_pref = length(@pref)
    @sub_args = array()
    @key_arg = null
    @model = array()
    for(@i = 0, @i < @len, @i++) {
        if (@args[@i][0] == @pref) {
            if (!is_null(@key_arg)) {
                @model[] = array(@key_arg[cslice(@len_pref, -1)], @sub_args)
                @sub_args = array()
            }
            @key_arg = @args[@i]
        } else {
            @sub_args[] = @args[@i]
        }
    }
    if (!is_null(@key_arg)) {
        @model[] = array(@key_arg[cslice(@len_pref, -1)], @sub_args)
    }
    return(@model)
}

void proc _util_sort_entries(array @array, @comp=closure(@l, @r){return(@l[0] > @r[0])}) {
    array_sort(@array, @comp)
}

array proc _util_assoc_to_entries(array @array) {
    array @new_array = array()
    foreach(@key: @value in @array) {
        @new_array[] = array(@key, @value)
    }
    return(@new_array)
}

array proc _util_entries_to_assoc(array @array) {
    array @map = array()
    foreach(@entry in @array) {
        @map[@entry[0]] = @entry[1]
    }
    return(@map)
}

array proc _util_get_all_scripts(string @path, string @filter = null) {
    @files = array()
    @list_files = list_files(@path)
    foreach(@file in @list_files) {
        if (@filter && string_contains(@file, @filter)) {
            continue()
        }
        if (string_contains(@file, '.')) {
            if (string_contains(@file, '.ms'), @files[] = @path.'\\'.@file)
        } else {
            array_push_all(@files, _util_get_all_scripts(@path.'\\'.@file, @filter))
        }
    }
    return(@files)
}

array proc _util_get_all_files(string @path, string @filter = null) {
    @files = array()
    @list_files = list_files(@path)
    foreach(@file in @list_files) {
        if (@filter && string_contains(@file, @filter)) {
           continue()
        }
        if (string_contains(@file, '.')) {
            @files[] = @path.'\\'.@file
        } else {
            array_push_all(@files, _util_get_all_files(@path.'\\'.@file, @filter))
        }
    }
    return(@files)
}

void proc _util_make_file(string @path, string @split = '\\', int @ignore = 0) {
    if (file_exists(@path)) {
        return()
    }
    @folders = split(@split, @path)

    if (@ignore > 0) {
        @sub_path = array_implode(@folders[cslice(0, @ignore)], @split).@split
    } else {
        @sub_path = @folders[0].@split
    }
	
	for(@i = @ignore+1, @i < array_size(@folders) - 1, @i++){
		@sub_path .= @folders[@i].@split
		if(!file_exists(@sub_path)){
			create_dir(@sub_path)
		}
	}
	create_file(@path)
}

void proc _util_make_folder(string @path, string @split = '\\', int @ignore = 0) {
    if (file_exists(@path)) {
        return()
    }
    @folders = split(@split, @path)

    if (@ignore > 0) {
        @sub_path = array_implode(@folders[cslice(0, @ignore)], @split).@split
    } else {
        @sub_path = @folders[0].@split
    }
	
	for(@i = @ignore + 1, @i < array_size(@folders), @i++){
		@sub_path .= @folders[@i].@split
		if(!file_exists(@sub_path)){
			create_dir(@sub_path)
		}
	}
}

array proc _util_array_and(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @result = array()
    foreach(@val in @arr1) {
        if (array_contains(@arr2, @val), @result[] = @val)
    }
    return(@result)
}

array proc _util_array_or(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @carr1 = @arr1[]
    @carr2 = @arr2[]
    @result = array()
    foreach(@val in @arr1) {
        if (!array_contains(@arr2, @val), @result[] = @val, array_remove(@arr2, @val))
    }
    array_push_all(@result, @carr2)
    return(@result)
}

boolean proc _util_array_some_contains(array @arr1, array @arr2) {
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

array proc _util_array_minus(array @arr1, array @arr2) {
    if (is_associative(@arr1)) {
        throw(CastException, 'arr1 must be not associative array')
    } else if (is_associative(@arr2)) {
        throw(CastException, 'arr2 must be not associative array')
    }
    @result = array()
    foreach(@val in @arr1) {
        if (!array_contains(@arr2, @val), @result[] = @val)
    }
    return(@result)
}

string proc _util_parse_exception(array @e) {
    @builder = res_create_resource('STRING_BUILDER')
    string_append(@builder, @e['classType'])
    string_append(@builder, ': ')
    string_append(@builder, @e['message'])
    if (@e['stackTrace'], string_append(@builder, '\n'))
    _util_parse_stack_trace(0, @e['stackTrace'], -1, @builder)
    return(string(@builder))
}

Resource proc _util_parse_stack_trace(int @start = 0, array @traces = get_stack_trace(), int @end = -1, Resource @builder = res_create_resource('STRING_BUILDER')) {
    if (!@traces, return(@builder))
    @traces = @traces[cslice(@start, @end)]
    @size = array_size(@traces)
    for(@i = 0, @i < @size, @i++) {
        @trace = @traces[@i]
        string_append(@builder, 'at ')
        string_append(@builder, @trace['id'])
        string_append(@builder, ':')
        string_append(@builder, @trace['file'])
        string_append(@builder, ':')
        string_append(@builder, @trace['line'])
        string_append(@builder, '.')
        string_append(@builder, @trace['col'])
        if (@i + 1 != @size) {
            string_append(@builder, '\n')
        }
    }
    return(@builder)
}

void proc _util_error(string @msg) {
    console(@msg, false)
    die()
}

string proc _util_get_cur_thread() {
    return(x_get_current_thread()[16..])
}

proc _method(array @self, string @key) {
    array_remove(@arguments, 1)
    return(execute_array(@arguments, @self[@key]))
}

proc _util_delete_closures(array @o) {
    array @clone = array()
    if (is_associative(@o)) {
        foreach(@k: @v in @o) {
            if (is_array(@v)) {
                @clone[@k] = _util_delete_closures(@v)
            } else if (!is_closure(@v)) {
                @clone[@k] = @v
            }
        }
    } else {
        foreach(@v in @o) {
            if (is_array(@v)) {
                @clone[] = _util_delete_closures(@v)
            } else if (!is_closure(@v)) {
                @clone[] = @v
            }
        }
    }
    return(@clone)
}
