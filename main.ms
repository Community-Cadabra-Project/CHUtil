/*
COMMAND HELPER UTIL scripts

Properties API:
    - properties_api.ms
    - properties_class.ms
Commander API:
    - commander_api.ms
    - commander_class.ms
Other API
    - proc.ms
    - method_executers.ms
*/

include('method_executers.ms')
include('properties_api.ms')
include('properties_class.ms')
include('commander_api.ms')
include('commander_class.ms')
include('proc.ms')


if (import('module_log')) {
    console('CHUtil loaded')
}