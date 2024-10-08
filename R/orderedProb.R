get_g <- function(value,func_data){
    n<- length(value)
    j<- 0
    result <- rep(0,n)
    for(i in seq_len(n)){
        if(value[i]==func_data[j+1]){
            j = j+1
            result[i] = j - 1
        }else{
            result[i] = j - 1
        }
        if(j == length(func_data)&&i!=n){
            result[(i+1):n] = length(func_data)-1
            break
        }
    }
    result
}
get_h <- function(value,func_data){
    n<- length(value)
    j<- 0
    result <- rep(0,n)
    for(i in seq_len(n)){
        if(value[i]==func_data[j+1]){
            j = j+1
            result[i] = j
        }else{
            result[i] = j + 1 
        }
        if(j == length(func_data)&&i!=n){
            result[(i+1):n] = length(func_data)+1
            break
        }
    }
    result
}

## the probability that
## l[i] < pvals[i] < h[i] for all i
## where pvals is from a uniform distribution
orderedProb <- function(l,h){
    stopifnot(length(l)==length(h))
    if(any(l>=h)) return(0)
    n <- length(l)
    for(i in seq_len(n-1)){
        if(l[i]>l[i+1]) l[i+1] <- l[i]
        j <- n-i
        if(h[j] > h[j+1]) h[j] <- h[j+1]
    }
    
    total <- sort(c(0,l,h,1))
    #g(t_i)
    g_value <- get_g(total,h)
    #h(t_i)
    h_value <- get_h(total,l)
    
    n_t <- length(total)
    diff_t <- diff(total)
    m <- length(l)
    compute_prob_fft(m,g_value,h_value,n_t,diff_t)
}
