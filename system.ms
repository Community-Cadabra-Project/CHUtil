# separation of directory names
proc _util_sdn() {
    return(import('org.cadabra.msutil.system.sdn'))
}

execute(closure() {
    string @sdn

    switch(get_os()) {
        case 'WINDOWS':
            @sdn = '\\'
        default:
            @sdn = '/'
    }
    export('org.cadabra.msutil.system.sdn', @sdn)
})