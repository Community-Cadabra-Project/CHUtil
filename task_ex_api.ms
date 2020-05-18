# METHODS
########################################################################################
@__util_methods_task_ex = array()

proc _util_task_ex_add(@self, closure @lymda) {
    array_push(@self['private_tasks'], @lymda)
}

proc _util_private_task_ex_pull(@self) {
    @index = array_size(@self['private_tasks']) - 1
    @pull = @self['private_tasks'][@index]
    array_remove(@self['private_tasks'], @index)
    return(@pull)
}

proc _util_task_ex_start(@self) {
    if (@self['private_is_run']) {
        return()
    } else {
        @self['private_is_run'] = true
        _util_private_task_ex_run(@self)
    }
}

proc _util_private_task_ex_run(@self) {
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
            @bool_cont = false
            while (array_size(@self['private_tasks']) == 0) {
                try {
                    x_sleep(@self['private_delay'])
                } catch(InterruptedException @e) {
                    return()
                }
                if (@self['private_final_n'] != @number && array_size(@cur_tasks) != 0) {
                    @bool_cont = true
                    break()
                }
            }
            if (@bool_cont, continue())
            @n = min(@self['private_number'], array_size(@self['private_tasks']))
            for(@i = 0, @i < @n, @i++) {
                if(is_interrupted(), return())
                @new_task = _util_private_task_ex_pull(@self)

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

proc _util_task_ex_interrupt(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_tracked_thread_interrupt(@task)
    }
}

proc _util_task_ex_stop(@self) {
    x_tracked_thread_interrupt(@self['private_id'])
    while(tracked_thread_is_alive(@self['private_id'])) {}
    foreach(@task in @self['private_cur_tasks']) {
        x_stop_tracked_thread(@task)
    }
}

proc _util_task_ex_is_run(@self) {
    return(@self['private_is_run'])
}

proc _util_task_ex_size_waiting(@self) {
    return(array_size(@self['private_tasks']))
}

proc _util_task_ex_size_running(@self) {
    return(array_size(@self['private_cur_tasks']))
}

proc _util_task_ex_complited(@self) {
    return(@self['private_complited'])
}

# FIELDS
########################################################################################

proc _util_task_ex_init_self(@id, @number, @delay, boolean @start) {

    # param @private_tasks  - (array) задачи, ожидающие своего выполнения (очередь)
    # param @private_id     - (string) название потока, запускающего задачи
    # param @private_count  - (int) счетчик задач для индвификации
    # param @private_delay  - (int) время задержки проверки возможности запустить новую задачу в секундах
    # param @private_is_run - (boolean) true если поток исполнения запущен, иначе false
    # param @private_number - (int) максимальное кол-во одновременно исполняемых задач
    # param @private_cur_tasks - (array) исполняемые задачи
    # param @private_complited - кол-воа исполненных задач

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

    if (@start) {
        _util_private_task_ex_run(@self)
    }
    return(@self)
}


if (import('script_log')) {
    console('MSUtil: task_ex_class.ms loaded', false)
}

