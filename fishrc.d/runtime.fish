# Note the execution time of last executed function

set PREEXEC_TIME (date +%s.%N)
set POSTEXEC_TIME (date +%s.%N)
set EXEC_RUNTIME 0

function preexec_test --on-event fish_preexec
    set PREEXEC_TIME (date +%s.%N)
end

function postexec --on-event fish_postexec
    set POSTEXEC_TIME (date +%s.%N)
    set EXEC_RUNTIME (math -s3 "$POSTEXEC_TIME - $PREEXEC_TIME")
end
