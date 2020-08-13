# separation of directory names
proc _util_sdn() {
    return(import('org.cadabra.msutil.system.sdn'))
}

/*
For procedures like _util_make_folder, _util_make_file,
that can be throw SecurityException
*/
proc _util_ign() {
    return(import('org.cadabra.msutil.system.ign'))
}

execute(closure() {
    @path = 'system_setting.yml'

    @setting = associative_array(
        sdn: '\\',
        ign: 3
    )

    @user_setting = array()
    if (file_exists(@path)) {
        @user_setting = yml_decode(read(@path))
        foreach(@key: @value in @setting) {
            if (!array_index_exists(@user_setting, @key)) {
                @user_setting[@key] = @value
            } else {
                if (typeof(@value) != typeof(@user_setting[@key])) {
                    @expect = typeof(@value)
                    throw(FormatException, "MSUtil:system_setting.yml - Attribut at @key must be @expect")
                }
            }
        }
        write_file(@path, yml_encode(@user_setting), 'OVERWRITE')
    } else {
        @user_setting = @setting
        write_file(@path, yml_encode(@user_setting), 'OVERWRITE')
    }
    export('org.cadabra.msutil.system.ign', @user_setting['ign'])
    export('org.cadabra.msutil.system.sdn', @user_setting['sdn'])
})