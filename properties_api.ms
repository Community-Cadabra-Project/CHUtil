proc _properties_init_self() {
    @self = array()

    # param @private_count - счетчик добавление аргументов, необходим для сортировки
    # param @private_store - карта аргументов
    # param @private_link - карта связки ключей и их значения @private_count

    @self['private_count'] = 0
    @self['private_store'] = array()
    @self['private_link'] = array()

    return(@self)
}

proc _private_properties_add_link(@self, @key) {
    @self['private_link'][@key] = @self['private_count']
    @self['private_count']++
}

proc _properties_get_string(@self, @key) {
    return(@self['private_store'][@key])
}

proc _properties_get_array(@self, @key) {
    return(array_get(@self['private_store'][@key]))
}

proc _properties_get_int(@self, @key) {
    return(integer(@self['private_store'][@key]))
}

proc _properties_get_bool(@self, @key) {
    return(boolean((@self['private_store'][@key])))
}

proc _properties_pull(@self, @key, @value) {
    _private_properties_add_link(@self, @key)
    @self['private_store'][@key] = @value
}

proc _properties_add_all(@self, @map) {
    foreach(@key: @value in @map) {
        _properties_pull(@self, @key, @value)
    }
}

proc _properties_contains(@self, @key) {
    return(boolean(array_index_exists(@self['private_store'], @key)))
}

proc _properties_key_set(@self) {
    return(array_keys(@self['private_store']))
}

proc _properties_remove_all(@self, @key_set) {
    foreach(@key in @key_set) {
        _properties_remove(@self, @key)
    }
}

proc _properties_remove(@self, @key) {
    @temp = @self['private_store'][@key]
    array_remove(@self['private_store'], @key)
    array_remove(@self['private_link'], @key)
    return(@temp)
}

proc _properties_clear(@self, @key) {
    @self['private_count'] = 0
    @self['private_store'] = array()
    @self['private_link'] = array()
}

proc _properties_is_empty(@self) {
    return(array_size(array_keys(@self['private_store'])) == 0)
}

proc _properties_parse_string(@self, @text) {
    @entries = split("\n", @text)
    for(@i = 0, @i < array_size(@entries), @i++) {
         if (trim(@entries[@i]) == "", continue())
        if (@entries[@i][0] == '#', continue())
        @key_value = reg_split("[=]", @entries[@i])
        if (array_size(@key_value) != 2) {
            throw(IOException, "Syntax error at: ".@i);
        }
        @key = @key_value[0]
        @value = @key_value[1]
        _properties_pull(@self, @key, @value)
    }
}

proc _properties_to_string(@self) {
    if (_properties_is_empty(@self), return(""))
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

console('CHUtil: properties_api.ms loaded')