proc _test_split_args() {
    @example = '-update 1 2 3 -run 3 4 5 -start 5 6'
    @res = _util_entries_to_assoc(_util_split_arg(@example, '-'))
    _assert_key_exist('update', @res)
    _assert_equals(@res['update'], array('1', '2', '3'))
    _assert_key_exist('run', @res)
    _assert_equals(@res['run'], array('3', '4', '5'))
    _assert_key_exist('update', @res)
    _assert_equals(@res['start'], array('5', '6'))
}

proc _test_entries() {
    @example1 = array(
        array(4, 1),
        array(3, 2),
        array(2, 3),
        array(1, 4),
        array(0, 5),
    )
    _util_sort_entries(@example1)

    @example2 = _util_assoc_to_entries(array(
        5, 4, 3, 2, 1
    ))

    _assert_equals(@example1, @example2)

    _assert_equals(
        _util_entries_to_assoc(@example2),
        array(5, 4, 3, 2, 1)
    )
}

proc _test_arrays_math() {
    _assert_execute_throw(
        CastException,
        closure() {
            _util_array_and(
                array(),
                array(a:1)
            )
        }
    )
    _assert_execute_throw(
        CastException,
        closure() {
            _util_array_and(
                array(a:1),
                array()
            )
        }
    )

    _assert_equals(
        array(2),
        _util_array_and(
            array(-1, 0, 1, 2),
            array(2, 3, 4)
        )
    )

    _assert_equals(
        array(0, 1, 2, 3, 4),
        _util_array_or(
            array(0, 1, 2),
            array(2, 3, 4)
        )
    )

    _assert_equals(
        array(-1, 0, 1),
        _util_array_minus(
            array(-1, 0, 1, 2),
            array(2, 3, 4)
        )
    )

    _assert_true(
        _util_array_some_contains(
            array(1, 2, 3, 5),
            array(8, 9, 2, 7)
        )
    )
}

proc _test_deep_push() {
    @a = array(
        0: '123',
        1: 1,
        3: array(
            array(1, 2),
            '123'
        ),
        test: array(
            a: array(1, 2),
            b: '123'
        ),
    )

    @b = array(
        0: 0,
        3: array(
            '123',
            array(1, 2)
        ),
        4: 4,
        test: array(
            b: 'test',
            a: array(1, 2, 3)
        )
    )

    _assert_equals(
        array(
            0: 0,
            1: 1,
            3: array(
                '123',
                array(1, 2)
            ),
            4: 4,
            test: array(
                b: 'test',
                a: array(1, 2, 3)
            )
        ),
        _util_array_deap_push(@a, @b)
    )
}