function play_live(tstr, tz, sequence, durations, seek) {
    var airtime = moment.tz(tstr, tz); // Construct the time in the given timezone
    var t_since = moment().diff(airtime, "s")

    console.log(tstr, tz, sequence, durations, seek)
    console.log("t_since", t_since)

    if (t_since < 0) {
        setTimeout(function () {
            play_live(tstr, tz, sequence, durations, 0);
        }, 1000*(-t_since + 2)); // start playing when class starts
        return; // Live class hasn't started
    }

    var total_time = durations.reduce(function (x,y) { return x+y });
    if (t_since > total_time) {
        return; // Live class is over
    }

    var j = 0
    var prev_t = 0
    var t = 0
    var time_left=300
    for (var i=0, l=durations.length; i<l;i++) {
        t += durations[i]
        if (t_since < t) {
            j = i // play this video
            time_left = t - t_since
            if (typeof(seek) === "undefined") {
                seek = Math.max(0, durations[i] - time_left);
            }
            break
        }
    }


    iframe = document.getElementById(sequence[j])

    if (typeof(seek) == "undefined") {
        seek = 0;
    }

    // Start playing!
    iframe.src = iframe.src + "?start=" + seek + "&autoplay=1"

    setTimeout(function () {
        play_live(tstr, tz, sequence, durations, 0);
    }, 1000*(time_left+5)); // play next video 5 seconds after this one.
}
