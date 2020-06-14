proc _util_init_module() {
    _unit_register_module(
        'msutil',
        get_absolute_path('msunit/tests'),
        get_absolute_path('msunit/setting.properties'),
        _unit_get_default_outs(get_absolute_path('msunit/logs'))
    )
}