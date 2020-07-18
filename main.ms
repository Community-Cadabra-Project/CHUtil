proc _util_init_module() {
    _unit_register_module(associative_array(
        id: 'msutil',
        folder: get_absolute_path('msunit/tests'),
        groups: get_absolute_path('msunit/setting.properties'),
        outs: _unit_get_default_outs(get_absolute_path('msunit/logs'))
    ))
}