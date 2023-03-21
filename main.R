library(tercen)
library(dplyr, warn.conflicts = FALSE)
library(globaltest)

aCtx = tercenCtx()
ram <- aCtx$op.value("ram", type = numeric, default = 100)
cpu <- aCtx$op.value("cpu", type = numeric, default = 2)

aCtx$requestResources(nCpus=cpu, ram=ram, ram_per_cpu=round(cpu/2) )
stdz <- FALSE
if(!is.null(aCtx$op.value("standardize"))) stdz <- as.logical(aCtx$op.value("standardize"))

directional <- FALSE
if(!is.null(aCtx$op.value("directional"))) directional <- as.logical(aCtx$op.value("directional"))

modeltype = "auto"
if(!is.null(aCtx$op.value("modeltype"))) modeltype <- aCtx$op.value("modeltype")

getDataFrame = function(ctx){

  if(!ctx$hasXAxis) stop("Define variables using an x-axis in Tercen")
  if(length(ctx$colors) != 1) stop("Define grouping / response using a single variable as color in Tercen")
  if(length(ctx$labels) < 1) stop("Define observations using a single variable as label in Tercen")
  df = ctx %>% 
    select( .ri,.ci, .x, .y)
  df = df %>% 
    bind_cols(ctx$select(ctx$colors))
  colnames(df) = c(colnames(df)[1:4], "response")
  columns = ctx$cselect() %>%
    mutate(.ci = 0:(n()-1))
  df = df %>%
    mutate(response = response %>% as.factor) %>%
    left_join(columns, by = ".ci")
  
  df$obs = (ctx$select(ctx$labels)) %>%
    as.matrix() %>%
    apply(1, paste, collapse = "-")
  
  return(df)
}

gtest = function(df){
  grp.info = df %>%
    distinct(obs, response)
  
  if(modeltype == "auto" & is.numeric(grp.info$response)){
    modeltype = "linear"
  } else {
    grp.info = grp.info %>%
      mutate(response = response %>% as.factor)
    
    if(length(levels(grp.info$response)) == 2){
      modeltype = "logistic"
    } else {
      modeltype = "multinomial"
    }
  }

  aGt = df %>%
    reshape2::dcast(obs ~ .x, value.var = ".y") %>%
    left_join(grp.info, by = "obs") %>%
    select(-obs) %>%
    gt(response ~ . , data = ., model = modeltype, standardize = stdz, directional = directional)
  
  if(modeltype == "logistic"){
    ddf = df %>%
      group_by(response) %>%
      summarize(grpm = mean(.y))
    delta = ddf$grpm %>%
      diff()
  } else {
    delta = NaN
  }

  result = data.frame(p = p.value(aGt), globtest.statistic = aGt@result[2], nVariables = aGt@result[5], delta) 
}

result = aCtx %>%
  getDataFrame() %>%
  group_by(.ri, .ci) %>%
  do(gtest(.)) %>%
  ungroup() %>%
  mutate(logp = -log10(p))

result %>%
  aCtx$addNamespace() %>%
  aCtx$save()
