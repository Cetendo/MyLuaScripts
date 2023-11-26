util.keep_running()
util.require_natives(1681379138)
shadow = menu.shadow_root()
my_root = menu.my_root()


function containsOnlyIandL(str)
    return str:match("^[IL]+$") and str:find("I") and str:find("L")
end

playerhistory = menu.ref_by_path("Online>Player History")
