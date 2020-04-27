proc _private_properties_init_fields() {
    @self = array()

    # param @private_count - счетчик добавление аргументов, необходим для сортировки
    # param @private_store - карта аргументов
    # param @private_link - карта связки ключей и их значения @private_count

    @self['private_count'] = 0
    @self['private_store'] = array()
    @self['private_link'] = array()

    return(@self)
}

proc _create_properties_object() {
    @self = _private_properties_init_fields()

    @self['private_add_link'] = closure(@key) {
        @self['private_link'][@key] = @self['private_count']
        @self['private_count']++
    }

    @self['get_string'] = closure(@key) {
        return(@self['private_store'][@key])
    }

    @self['get_array'] = closure(@key) {
        return(array_get(@self['private_store'][@key]))
    }

    @self['get_int'] = closure(@key) {
        return(integer(@self['private_store'][@key]))
    }

    @self['get_bool'] = closure(@key) {
        return(boolean((@self['private_store'][@key])))
    }

    @self['pull'] = closure(@key, @value) {
        execute(@key, @self['private_add_link'])
        @self['private_store'][@key] = @value
    }

    @self["add_all"] = closure(@map) {
        foreach(@key: @value in @map) {
            @execute(@key, @value, @self['pull'])
        }
    }

    @self['contains'] = closure(@key) {
        return(boolean(array_index_exists(@self['private_store'], @key)))
    }

    @self['key_set'] = closure() {
        return(array_keys(@self['private_store']))
    }

    @self['remove_all'] = closure(@key_set) {
        foreach(@key in @key_set) {
            execute(@key, @self['remove'])
        }
    }

    @self['remove'] = closure(@key) {
        @temp = @self['private_store'][@key]
        array_remove(@self['private_store'], @key)
        array_remove(@self['private_link'], @key)
        return(@temp)
    }

    @self['clear'] = closure(@key) {
        @self['private_count'] = 0
        @self['private_store'] = array()
        @self['private_link'] = array()
    }

    @self['is_empty'] = closure() {
        return(array_size(array_keys(@self['private_store'])) == 0)
    }

    @self['parse_string'] = closure(@text) {
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
            execute(@key, @value, @self['pull'])
        }
    }

    @self['to_string'] = closure() {
        if (execute(@self['is_empty']), return(""))
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

    return(@self)
}

console('CHUtil: properties_class.ms loaded')

