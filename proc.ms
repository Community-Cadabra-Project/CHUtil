proc _unit_split_arg(@arg, @pref) {
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

proc _unit_sort_entries(array @array, @comp=closure(@l, @r){return(@l[0] > @r[0])}) {
    @temp_array = _unit_associative_to_entries(@array)
    array_sort(@temp_array, @comp)
    return(@temp_array)
}

proc _unit_assoc_to_entries(array @array) {
    array @new_array = array()
    foreach(@key: @value in @array) {
        array_push(@new_array, array(@key, @value))
    }
    return(@new_array)
}

proc _unit_entries_to_assoc(array @array) {
    array @map = array()
    foreach(@entry in @array) {
        @map[@entry[0]] = @entry[1]
    }
    return(@map)
}

proc _util_get_all_scripts(@path) {
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


if (import('script_log')) {
    console('CHUtil: proc.ms loaded')
}