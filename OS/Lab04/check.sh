# check.sh - checks your work.  Run it with:   sh check.sh
#
# It builds your code with make and runs the browser three times, so it takes
# about a minute. Nothing in your files is changed.

pass=0
fail=0
ok() { echo "  PASS  $1"; pass=$((pass + 1)); }
no() {
    echo "  FAIL  $1"
    echo "        $2"
    fail=$((fail + 1))
}

echo ""
echo "Building ..."
make clean >/dev/null 2>&1
make >/tmp/build.log 2>&1
if [ -x ./rr ] && [ -x ./priority ] && [ -x ./tab ]; then
    ok "rr.c, priority.c and tab.c all compile"
else
    no "rr.c, priority.c and tab.c all compile" "the errors are below"
    cat /tmp/build.log
    exit 1
fi

echo "Running the browser 3 times. This takes about a minute ..."
rr0=$(./rr 3 0 2>&1)
rr2=$(./rr 3 2 2>&1)
pr0=$(./priority 3 0 2>&1)
echo ""

# =====================================================================
# TEST 1 (exact): the order and length of the slices in rr
# This part is fully decided by YOUR code, so it must match exactly.
# =====================================================================
echo "$rr0" | grep '^\[sched\] round [0-9]' | sed 's/^.*: //' > /tmp/got_order
awk 'BEGIN { for (r = 0; r < 3; r++) for (i = 0; i < 3; i++)
                 printf "tab %d runs for %d s\n", i, (i == 0 ? 4 : 2) }' > /tmp/want_order
if diff -q /tmp/want_order /tmp/got_order >/dev/null 2>&1; then
    ok "rr: the slices are round robin, and the active tab gets a double slice"
else
    no "rr: the slices are round robin, and the active tab gets a double slice" \
       "expected (left) against what your scheduler printed (right):"
    diff -y --width=70 /tmp/want_order /tmp/got_order | head -12 | sed 's/^/          /'
    echo "          (an empty right side means task A1 or task A2 is not written yet)"
fi

# =====================================================================
# TEST 2 (semantic): the threads. Their ORDER is decided by the operating
# system, so we only check that three different threads did work.
# =====================================================================
nthreads=$(echo "$rr0" | grep -o 'thread [0-9]' | sort -u | wc -l)
if [ "$nthreads" -eq 3 ]; then
    ok "tab: 3 different threads are editing the page"
elif [ "$nthreads" -eq 0 ]; then
    no "tab: 3 different threads are editing the page" \
       "no thread printed anything: is task B written, and task C after it?"
else
    no "tab: 3 different threads are editing the page" \
       "only $nthreads different thread number(s) appeared, expected 3: did you pass &i instead of &id[i] in Part B?"
fi

# =====================================================================
# TEST 3 (semantic): every tab must get CPU time
# =====================================================================
nres=$(echo "$rr0" | grep -c '^RESULT')
zero=$(echo "$rr0" | awk '/^RESULT/ && $5 == 0 { n++ } END { print n + 0 }')
counts=$(echo "$rr0" | awk '/^RESULT/ { c[$3] = $5 } END { printf "%d %d %d", c[0], c[1], c[2] }')
if [ "$nres" -lt 3 ]; then
    no "rr: every tab did some work" \
       "only $nres tab(s) reported a result, expected 3: is task A1 (fork and execvp) written?"
elif [ "$zero" -eq 0 ]; then
    ok "rr: every tab did some work  (tab 0/1/2 = $counts edits)"
else
    no "rr: every tab did some work" \
       "$zero tab(s) did nothing, edits were $counts: check SIGCONT and the sleep before SIGSTOP"
fi

# =====================================================================
# TEST 4 (semantic): the active tab does about twice the work
# =====================================================================
ratio=$(echo "$rr0" | awk '/^RESULT/ { c[$3] = $5 }
    END { o = (c[1] + c[2]) / 2; printf "%.2f", (o > 0 ? c[0] / o : 0) }')
if awk "BEGIN { exit !($ratio > 1.3 && $ratio < 3.0) }"; then
    ok "rr: the active tab did clearly more work than the others  (${ratio}x, edits $counts)"
else
    no "rr: the active tab did clearly more work than the others" \
       "got ${ratio}x, expected between 1.3x and 3.0x (edits were $counts).
        Every tab also gets a last second while the browser shuts down, so the
        numbers are not exactly 2 to 1."
fi

# =====================================================================
# TEST 5 (semantic): the double slice follows the active tab
# =====================================================================
best=$(echo "$rr2" | awk '/^RESULT/ { if ($5 > m) { m = $5; t = $3 } } END { print (m > 0 ? t : "none") }')
if [ "$best" = "2" ]; then
    ok "rr: with './rr 3 2' the big slice moves to tab 2"
elif [ "$best" = "none" ]; then
    no "rr: with './rr 3 2' the big slice moves to tab 2" "no tab did any work"
else
    no "rr: with './rr 3 2' the big slice moves to tab 2" \
       "tab $best did the most work instead: is the active tab hard coded to 0?"
fi

# =====================================================================
# TEST 6 (semantic): no edit may be lost once the lock is there
# =====================================================================
edits=$(echo "$rr0" | awk '/^RESULT/ { t += $5 } END { print t + 0 }')
lost=$(echo "$rr0" | grep -c LOST)
if [ "$edits" -eq 0 ]; then
    no "tab: no edit was lost" "no edit happened at all, so there is nothing to check yet"
elif [ "$lost" -eq 0 ]; then
    ok "tab: no edit was lost  ($edits edits, 0 lost)"
else
    no "tab: no edit was lost" \
       "$lost of $edits edits were lost: the lock must cover all of your task C code"
fi

# =====================================================================
# TESTS 7 and 8 (semantic): the priority scheduler
# =====================================================================
ptotal=$(echo "$pr0" | awk '/^RESULT/ { t += $5 } END { print t + 0 }')
pcounts=$(echo "$pr0" | awk '/^RESULT/ { c[$3] = $5 } END { printf "%d %d %d", c[0], c[1], c[2] }')
if [ "$ptotal" -lt 30 ]; then
    no "priority: the active tab gets more than under round robin" \
       "almost nothing ran with './priority 3 0': is Part D written?"
    no "priority: no tab starves" "cannot be checked until Part D runs the tabs"
else
    pratio=$(echo "$pr0" | awk '/^RESULT/ { c[$3] = $5 }
        END { o = (c[1] + c[2]) / 2; printf "%.2f", (o > 0 ? c[0] / o : 99) }')
    if awk "BEGIN { exit !($pratio > 1.3) }"; then
        ok "priority: the most important tab gets the most CPU  (${pratio}x, edits $pcounts)"
    else
        no "priority: the most important tab gets the most CPU" \
           "got ${pratio}x (edits $pcounts): the tab with the biggest prio must be the one that runs"
    fi

    share=$(echo "$pr0" | awk '/^RESULT/ { if ($5 > mx) mx = $5; if (mn == "" || $5 < mn) mn = $5 }
        END { printf "%.0f", 100 * mn / mx }')
    if [ "$share" -ge 15 ]; then
        ok "priority: no tab starves  (weakest tab has $share% of the busiest)"
    else
        no "priority: no tab starves" \
           "weakest tab has only $share% of the busiest (edits $pcounts): add the aging lines of task D2"
    fi
fi

echo ""
echo "  $pass passed, $fail failed"
echo ""
if [ "$fail" -eq 0 ]; then
    echo "  All checks passed."
else
    echo "  Read the FAIL lines above, fix one thing, and run sh check.sh again."
fi
echo ""
