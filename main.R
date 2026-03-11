pacman::p_load(
  tidyverse,
  sf,
  rgee,
  geoidep,
  cptcity
)

ee_Initialize()

# INPUT  ---
DEPARTAMENTO <- 'LORETO'


# Data processing  ---
dep <- get_departaments() |> 
  filter(nombdep == DEPARTAMENTO)

dist <- get_districts(departamento = DEPARTAMENTO)

gf_day_1km <- ee$ImageCollection("projects/sat-io/open-datasets/gap-filled-lst/gf_day_1km")$
  mean() |> 
  ee$Image$multiply(0.1)

tmean <- ee_extract(
  x = gf_day_1km,
  y = dist,
  fun = ee$Reduce$mean(),
  sf = TRUE
)

# Design map
map <-
  ggplot() + 
  geom_sf(data = tmean, aes(fill = )) + 
  geom_sf(data = dep, aes(fill = NULL), alpha = 0)
