import 
    std/[os, monotimes, times, math],
    silicideData

var mean = 1e-3
var m2 = 0.0
var count = 1.0

# Figure out why sleep estimate sticks a little too high
proc hybridSleep*(secs: float) =
    var localSecs = secs

    if estimate > 0.00833:
        estimate = 1e-3

    while localSecs > estimate:
        var start = getMonoTime()
        sleep(1)
        var fin = getMonoTime()

        observed = (fin-start).inNanoseconds().float / 1e9
        localSecs -= observed

        count += 1
        var delta = observed - mean
        mean += delta / count
        m2 += delta * (observed - mean)
        var stdDev = sqrt(m2 / (count - 1))
        estimate = mean + stdDev

    var start = getMonoTime()
    while (getMonoTime() - start).inNanoseconds().float / 1e9 < localSecs:
        discard
