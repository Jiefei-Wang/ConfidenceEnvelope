source("setup.r",local =TRUE)
# devtools::install_github('jtleek/tidypvals')


library(tidypvals)
library(tidyverse)
jager2014|>
group_by(year)|>
summarize(n=n())

papers <- jager2014|>
filter(year==2010)

length(unique(papers$pmid))


papers<- papers|>
pull(pvalue)

## factor to its actual value
pvals <- as.numeric(levels(pvals)[pvals])
length(pvals)

sum(pvals<=0.05)


alpha <- 0.05
n <- length(pvals)
lambda <- 0.5

pi_fun <- pi_generator(lambda, pvals)
res_GCB <- generalExceedance::pi_BJ_fast(pi_fun, pvals, 0.05, c(0,1), c(0,1))$upper

methods <- c("abh", "st.spline", "st.boot", "langaas", "jiang")
res_others <- sapply(methods, function(method) cp4p::estim.pi0(pvals, pi0.method = method)[[1]])

pi0_estimates <- c(res_others, GCB = res_GCB)
pi0_estimates[pi0_estimates<alpha] <- alpha
pi0_estimates[pi0_estimates>1] <- 1

rejection <- c()
for (i in seq_along(pi0_estimates)){
    cur_pi0 <- pi0_estimates[i]
    pvals_adj <- cp4p::adjust.p(pvals, pi0 = cur_pi0)$adjp$adjusted.p
    rejection[i] <- sum(pvals_adj <= alpha)
}


## estimate number of nulls
est_null <- ceiling(pi0_estimates*n)

selections <- c(methods, "GCB")
dt <- data.frame(selections, est_null, rejection)
dt

library(openxlsx)
write.xlsx(dt, "example.xlsx")
