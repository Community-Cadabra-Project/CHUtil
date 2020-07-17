proc _util_export(string @id, mixed @o) {
    export(x_get_current_thread().' - '.@id, @o)
}

mixed proc _util_import(string @id) {
    return(import(x_get_current_thread().' - '.@id))
}