fruits <- data.frame(
    val = c(
        stats::rnorm(10, 0, 1),
        stats::rnorm(10, 1, 1),
        stats::rnorm(10, 2, 1),
        stats::rnorm(15, 2, 2),
        stats::rnorm(20, 3, 3),
        stats::rnorm(25, 4, 1),
        stats::rnorm(15, 1, 3),
        stats::rnorm(20, 2, 2)
    ),
    grp = c(
        rep(   "Apple", 10),
        rep(  "Banana", 10),
        rep( "Coconut", 10),
        rep(  "Durian", 15),
        rep("Eggfruit", 20),
        rep(     "Fig", 25),
        rep(   "Guava", 15),
        rep("Honeydew", 20)
    )
)



