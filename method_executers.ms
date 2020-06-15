proc _method(@self, @key) {
    return(execute(@self, @arguments, @self[@key]))
}
proc _method1(@self, @key, @p1) {
    if (array_size(@arguments) != 2 + 1) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @self[@key]))
}
proc _method2(@self, @key, @p1, @p2) {
    if (array_size(@arguments) != 2 + 2) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @self[@key]))
}
proc _method3(@self, @key, @p1, @p2, @p3) {
    if (array_size(@arguments) != 2 + 3) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @self[@key]))
}
proc _method4(@self, @key, @p1, @p2, @p3, @p4) {
    if (array_size(@arguments) != 2 + 4) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @self[@key]))
}
proc _method5(@self, @key, @p1, @p2, @p3, @p4, @p5) {
    if (array_size(@arguments) != 2 + 5) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @self[@key]))
}
proc _method6(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6) {
    if (array_size(@arguments) != 2 + 6) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @self[@key]))
}
proc _method7(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7) {
    if (array_size(@arguments) != 2 + 7) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @self[@key]))
}
proc _method8(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8) {
    if (array_size(@arguments) != 2 + 8) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @self[@key]))
}
proc _method9(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9) {
    if (array_size(@arguments) != 2 + 9) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @self[@key]))
}
proc _method10(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10) {
    if (array_size(@arguments) != 2 + 10) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @self[@key]))
}
proc _method11(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11) {
    if (array_size(@arguments) != 2 + 11) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @self[@key]))
}
proc _method12(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12) {
    if (array_size(@arguments) != 2 + 12) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @self[@key]))
}
proc _method13(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13) {
    if (array_size(@arguments) != 2 + 13) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @self[@key]))
}
proc _method14(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14) {
    if (array_size(@arguments) != 2 + 14) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14, @self[@key]))
}
proc _method15(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14, @p15) {
    if (array_size(@arguments) != 2 + 15) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14, @p15, @self[@key]))
}
proc _method16(@self, @key, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14, @p15, @p16) {
    if (array_size(@arguments) != 2 + 16) {
        throw(IllegalArgumentException, 'Number of arguments does not match the required.')
    }
    return(execute(@self, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14, @p15, @p16, @self[@key]))
}

if (import('script_log')) {
    console('MSUtil: method_executers.ms loaded', false)
}