proc _util_init_tests() {
    _unit_register_module(associative_array(
        id: 'msutil',
        root: get_absolute_path('msunit'),
        groups: 'setting.properties',
        ignore: array_size(split(_util_sdn(), get_absolute_path('msunit')))
    ))
}