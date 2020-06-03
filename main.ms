/*
COMMAND HELPER UTIL scripts

Serialization:
    *.properties
        - properties_api.ms
        - properties_class.ms

Patterns:
    Commander
        - commander_api.ms
        - commander_class.ms

Logging:
    Messager:
        - msg.ms
    Logger:
        - log.ms

Usefull procedurs:
    - proc.ms
    - method_executers.ms

MultiProgramming:
    Multy task executer:
        - task_ex_api.ms
        - task_ex_class.ms
*/

include('proc.ms')
include('msg.ms')
include('log.ms')
include('method_executers.ms')
include('properties_api.ms')
include('properties_class.ms')
include('commander_api.ms')
include('commander_class.ms')
include('task_ex_class.ms')
include('task_ex_api.ms')


if (import('module_log')) {
    console('MSUtil loaded', false)
}