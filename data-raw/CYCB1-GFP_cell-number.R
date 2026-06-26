rawdata <- read.csv("./data-raw/CYCB1-GFP_cell-number.csv")

rep <- unique(rawdata[["replicate"]])

CYCB1 <- vector("list", length(rep))

for (i in rep)
{
    df0 <- rawdata[rawdata[["replicate"]] == i, ]
    df0[["treatment"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    df0[["grp"]] <- vapply(
        df0[["treatment"]],
        function(x) switch(as.integer(x), "A", "B", "C", "D"),
        FUN.VALUE = character(1)
    )

    CYCB1[[i]] <- data.frame(
        TEMP = factor(df0[["TEMP"]], levels = c("22C", "31C")),
        RGF1 = as.factor(df0[["RGF1"]]),
        treatment = df0[["treatment"]],
        grp = as.factor(df0[["grp"]]),
        cells = as.integer(df0[["Cortex.cell.number"]])
    )
}

names(CYCB1) <- sprintf("rep%02d", seq_along(rep))

usethis::use_data(CYCB1, overwrite = TRUE)
