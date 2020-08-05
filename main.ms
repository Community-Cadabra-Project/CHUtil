proc _util_init_module() {
    _unit_register_module(associative_array(
        id: 'msutil',
        root: get_absolute_path('msunit'),
        groups: 'setting.properties'
    ))
}