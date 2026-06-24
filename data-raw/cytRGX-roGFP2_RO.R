rawdata <- read.csv("./data-raw/cytRGX-roGFP2_RO.csv")

rep <- unique(rawdata[["replicate"]])

roGFP <- vector("list", length(rep))

for (i in rep)
{
    df0 <- rawdata[rawdata[["replicate"]] == i, ]

    roGFP[[i]] <- data.frame(
        TEMP = factor(df0[["TEMP"]], levels = c("22C", "31C")),
        DAT = as.factor(df0[["DAT"]]),
        RGF1 = as.factor(df0[["RGF1"]]),
        ro_index = as.numeric(df0[["RO.index"]])
    )
}

names(roGFP) <- sprintf("rep%02d", seq_along(rep))

usethis::use_data(roGFP, overwrite = TRUE)
