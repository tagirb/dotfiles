# parse index status
$1 ~ /^[ACDMR]$/ { !i[$1]++; }
# parse working tree status
$2 ~ /^[DM?]$/ { !w[$2]++; }

END {
    # working tree status
    if (length(w) > 0) {
        wM = ("M" in w) ? "%F{green}*" : ""
        wD = ("D" in w) ? "%F{red}-" : ""
        wU = ("?" in w) ? "%F{cyan}?" : ""
        if (length(i) > 0) {
            printf " "
        }
        printf " %s%s%s ", wM, wD, wU
    }

    # index status
    if (length(i) > 0) {
        iA = ("A" in i) ? "+" : ""
        iC = ("C" in i || "M" in i || "R" in i) ? "*" : ""
        iD = ("D" in i) ? "-" : ""
        printf "%%K{059} %%F{yellow}%s%s%s ", iA, iC, iD
    }
}
