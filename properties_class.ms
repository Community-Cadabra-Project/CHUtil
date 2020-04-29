# METHODS
########################################################################################
@__util_methods_properties = array()

@__util_methods_properties['private_add_link'] = closure(@self, @key) {
    @self['private_link'][@key] = @self['private_count']
    @self['private_count']++
}
@__util_methods_properties['get_string'] = closure(@self, @key) {
    return(@self['private_store'][@key])
}
@__util_methods_properties['get_array'] = closure(@self, @key) {
    return(array_get(@self['private_store'][@key]))
}
@__util_methods_properties['get_int'] = closure(@self, @key) {
    return(integer(@self['private_store'][@key]))
}
@__util_methods_properties['get_bool'] = closure(@self, @key) {
    return(boolean((@self['private_store'][@key])))
}
@__util_methods_properties['push'] = closure(@self, @key, @value) {
    _method1(@self, 'private_add_link', @key)
    @self['private_store'][@key] = @value
}
@__util_methods_properties["add_all"] = closure(@self, @map) {
    foreach(@key: @value in @map) {
        _method1(@self, 'push', @key)
    }
}
@__util_methods_properties['contains'] = closure(@self, @key) {
    return(boolean(array_index_exists(@self['private_store'], @key)))
}
@__util_methods_properties['key_set'] = closure(@self) {
    return(array_keys(@self['private_store']))
}
@__util_methods_properties['remove_all'] = closure(@self, @key_set) {
    foreach(@key in @key_set) {
        _method1(@self, 'remove', @key)
    }
}
@__util_methods_properties['remove'] = closure(@self, @key) {
    @temp = @self['private_store'][@key]
    array_remove(@self['private_store'], @key)
    array_remove(@self['private_link'], @key)
    return(@temp)
}
@__util_methods_properties['clear'] = closure(@self, @key) {
    @self['private_count'] = 0
    @self['private_store'] = array()
    @self['private_link'] = array()
}
@__util_methods_properties['is_empty'] = closure(@self) {
    return(array_size(array_keys(@self['private_store'])) == 0)
}
@__util_methods_properties['parse_string'] = closure(@self, @text) {
    @entries = split("\n", @text)
    for(@i = 0, @i < array_size(@entries), @i++) {
        if (trim(@entries[@i]) == "", continue())
        if (@entries[@i][0] == '#', continue())
        @entry = reg_split("[=]", @entries[@i])
        if (array_size(@entry) != 2) {
            throw(IOException, "Syntax error at: ".@i);
        }
        @key = @entry[0]
        @value = @entry[1]
        _method2(@self, 'push', @key, @value)
    }
}
@__util_methods_properties['to_string'] = closure(@self) {
    if (_method(@self, 'is_empty'), return(""))
    @builder = res_create_resource('STRING_BUILDER')
    @store = array()
    foreach(@key: @value in @self['private_store']) {
        array_push(@store, array(@key, @value, @self['private_link'][@key]))
    }
    array_sort(@store, closure(@left, @right){
        return(@left[2] > @right[2]);
    });
    @size = array_size(@store)
    for(@i = 0, @i < @size - 1, @i++) {
        string_append(@builder, @store[@i][0], '=', @store[@i][1], '\n')
    }
    string_append(@builder, @store[-1][0], '=', @store[-1][1])
    return(string(@builder))
}
########################################################################################


@util_new_properties_object = closure() {
    @self = array()

    # param @private_count - счетчик добавление аргументов, необходим для сортировки
    # param @private_store - карта аргументов
    # param @private_link - карта связки ключей и их значения @private_count

    @self['private_count'] = 0
    @self['private_store'] = array()
    @self['private_link'] = array()

    foreach(@key: @value in @__util_methods_properties) {
        @self[@key] = @value
    }

    return(@self)
}

if (import('script_log')) {
    console('CHUtil: properties_class.ms loaded')
}

