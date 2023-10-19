local skt = require("socket")
local sleep = skt.sleep

local lthreads = {}

function lthreads.get_time()
	return skt.gettime()*1000
end

lthreads.threads = {}

lthreads.tgroups = {}

function lthreads.add(func, wait_time, loop, group, skip)
    local thread = {
        func = func,
        wait_time = wait_time,
        last_time = lthreads.get_time(),
        loop = loop,
        active = true,
        group = group,
        skip = skip
    }
    if group then
        lthreads.tgroups[group] = lthreads.tgroups[group] or {}
        table.insert(lthreads.tgroups[group], thread)
    else
        table.insert(lthreads.threads, thread)
    end
    return thread
end

function lthreads.func(func, ...)
    local co = coroutine.create(func)
    coroutine.resume(co, function(time)
        lthreads.add(function()
            if coroutine.status(co) == "suspended" then
                coroutine.resume(co)
            end
        end, time)
        coroutine.yield()
        
    end, ...)
    return co
end

function lthreads.clrearGroup(group)
    lthreads.tgroups[group] = nil
end

function lthreads.checkThreads()
    local time = lthreads.get_time()
    for i, thread in ipairs(lthreads.threads) do
        if thread.active then
            if time - thread.last_time >= thread.wait_time then
                thread.func(thread)
                if thread.loop then
                    thread.last_time = time
                else
                    table.remove(lthreads.threads, i)
                end
            end
        else
            table.remove(lthreads.threads, i)
        end
    end
    for i, group in pairs(lthreads.tgroups) do
        for j, thread in pairs(group) do
            if thread.active then
                if not thread.glast_time then
                    thread.glast_time = true
                    thread.last_time = lthreads.get_time()
                end
                if time - thread.last_time >= thread.wait_time then
                    thread.func(thread)
                    if thread.loop then
                        thread.last_time = time
                    else
                        table.remove(group, j)
                    end
                end
                if not thread.skip then
                    break
                end
            else
                table.remove(group, j)
            end
        end
    end
end

function lthreads.clear()
	lthreads.threads = {}
	lthreads.tgroups = {}
end

function lthreads.init()
	if main ~= nil and type(main) == "function" then
		lthreads.func(main)
	end
	while true do
		sleep(0.001)
		lthreads.checkThreads()
	end
end

return lthreads