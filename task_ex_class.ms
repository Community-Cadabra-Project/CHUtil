# METHODS
########################################################################################
@__util_methods_task_ex = array()

@__util_methods_task_ex['add'] = closure(@self, closure @lymda) {
    array_push(@self['private_tasks'], @lymda)
}

@__util_methods_task_ex['private_pull'] = closure(@self) {
    @index = array_size(@self['private_tasks']) - 1
    @pull = @self['private_tasks'][@index]
    array_remove(@self['private_tasks'], @index)
    return(@pull)
}

@__util_methods_task_ex['start'] = closure(@self) {
    if (@self['private_is_run']) {
        return()
    } else {
        @self['private_is_run'] = true
        execute(@self, @self['private_run'])
    }
}

@__util_methods_task_ex['private_run'] = closure(@self) {
    @runnable = closure() {
        @cur_tasks = @self['private_cur_tasks']
        while(true) {
            for(@i = 0, @i < array_size(@cur_tasks), @i++) {
                @task = @cur_tasks[@i]
                if (!tracked_thread_is_alive(@task)) {
                    @self['private_number']++
                    array_remove(@cur_tasks, @i)
                    @i--;
                }
            }
            @number = @self['private_number']

            if (@number == 0) {
                try {
                    x_sleep(@self['private_delay'])
                } catch(InterruptedException @e) {
                    return()
                }
                continue()
            }
            while (array_size(@self['private_tasks']) == 0) {
                try {
                    x_sleep(@self['private_delay'])
                } catch(InterruptedException @e) {
                    return()
                }
            }
            @n = min(@self['private_number'], array_size(@self['private_tasks']))
            for(@i = 0, @i < @n, @i++) {
                if(is_interrupted(), return())
                @new_task = execute(@self, @self['private_pull'])

                @id = @self['private_id'].'-'.@self['private_count']
                x_new_tracked_thread(@id, closure() {
                    execute(@new_task)
                })

                @self['private_number']--
                @self['private_count']++
                if (@self['private_count'] == 9223372036854775807, @self['private_count'] == 0)
                array_push(@cur_tasks, @id)
            }
        }
    }
    x_new_tracked_thread(@self['private_id'], @runnable)
}

@__util_methods_task_ex['interrupt'] = closure(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_tracked_thread_interrupt(@task)
    }
}

@__util_methods_task_ex['stop'] = closure(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_stop_tracked_thread(@task)
    }
}

@__util_methods_task_ex['is_run'] = closure(@self) {
    return(@self['private_is_run'])
}

# FIELDS
########################################################################################

@util_new_task_ex_object = closure(@id, @number, @delay, boolean @start) {
    @self = array()
    @self['private_tasks'] = array()
    @self['private_id'] = @id
    @self['private_count'] = 0
    @self['private_delay'] = @delay
    @self['private_is_run'] = @start
    @self['private_number'] = @number
    @self['private_cur_tasks'] = array()

    foreach(@key: @value in @__util_methods_task_ex) {
        @self[@key] = @value
    }

    if (@start) {
        _method(@self, 'private_run')
    }
    return(@self)
}


if (import('script_log')) {
    console('CHUtil: task_ex_class.ms loaded')
}

