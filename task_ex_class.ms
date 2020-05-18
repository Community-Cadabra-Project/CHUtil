# METHODS
########################################################################################
@__util_task_ex_methods = array()

@__util_task_ex_methods['add'] = closure(@self, closure @lymda) {
    array_push(@self['private_tasks'], @lymda)
}

@__util_task_ex_methods['private_pull'] = closure(@self) {
    @index = array_size(@self['private_tasks']) - 1
    @pull = @self['private_tasks'][@index]
    array_remove(@self['private_tasks'], @index)
    return(@pull)
}

@__util_task_ex_methods['start'] = closure(@self) {
    if (@self['private_is_run']) {
        return()
    } else {
        @self['private_is_run'] = true
        execute(@self, @self['private_run'])
    }
}

@__util_task_ex_methods['private_run'] = closure(@self) {
    @runnable = closure() {
        @cur_tasks = @self['private_cur_tasks']
        while(true) {
            for(@i = 0, @i < array_size(@cur_tasks), @i++) {
                @task = @cur_tasks[@i]
                if (!tracked_thread_is_alive(@task)) {
                    @self['private_number']++
                    @self['private_complited']++
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
                if (@self['private_final_n'] != @number, continue())
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

@__util_task_ex_methods['interrupt'] = closure(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_tracked_thread_interrupt(@task)
    }
}

@__util_task_ex_methods['stop'] = closure(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_stop_tracked_thread(@task)
    }
}

@__util_task_ex_methods['is_run'] = closure(@self) {
    return(@self['private_is_run'])
}

@__util_task_ex_methods['size_waiting'] = closure(@self) {
    return(array_size(@self['private_tasks']))
}

@__util_task_ex_methods['size_running'] = closure(@self) {
    return(array_size(@self['private_cur_tasks']))
}

@__util_task_ex_methods['complited'] = closure(@self) {
    return(@self['private_complited'])
}

# FIELDS
########################################################################################

@util_task_ex_new_object = closure(string @id, int @number, int @delay, boolean @start) {

    # param @private_tasks  - (array) задачи, ожидающие своего выполнения (очередь)
    # param @private_id     - (string) название потока, запускающего задачи
    # param @private_count  - (int) счетчик задач для индвификации
    # param @private_delay  - (int) время задержки проверки возможности запустить новую задачу в секундах
    # param @private_is_run - (boolean) true если поток исполнения запущен, иначе false
    # param @private_number - (int) максимальное кол-во одновременно исполняемых задач
    # param @private_cur_tasks - (array) исполняемые задачи
    # param @private_complited - (int) кол-воа завершенных задач

    @self = array()
    @self['private_tasks'] = array()
    @self['private_id'] = @id
    @self['private_count'] = 0
    @self['private_delay'] = @delay
    @self['private_is_run'] = @start
    @self['private_number'] = @number
    @self['private_final_n'] = @number
    @self['private_cur_tasks'] = array()
    @self['private_complited'] = 0

    foreach(@key: @value in @__util_task_ex_methods) {
        @self[@key] = @value
    }

    if (@start) {
        _method(@self, 'private_run')
    }
    return(@self)
}


if (import('script_log')) {
    console('MSUtil: task_ex_class.ms loaded', false)
}

