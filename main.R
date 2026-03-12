pacman::p_load(
  tidyverse,
  land4health,
  geoidep,
  cptcity)

ee_Initialize()

# INPUT  -----------------------------------------------------------------------
DEPARTAMENTO <- 'LORETO'

# Data processing  -------------------------------------------------------------
dep <- get_departaments() |> 
  filter(nombdep == DEPARTAMENTO)

dist <- get_districts(departamento = DEPARTAMENTO)

# Mean temperature from 2003 to 2020 
gf_day_1km <- ee$ImageCollection(
  "projects/sat-io/open-datasets/gap-filled-lst/gf_day_1km")$
  max() |> 
  ee$Image$multiply(0.1)

tmean <- ee_extract(
  x = gf_day_1km,
  y = dist,
  fun = ee$Reducer$mean(),
  sf = TRUE,
  scale = 1000)

# Design map -------------------------------------------------------------------
(map <-
  ggplot() + 
  geom_sf(data = tmean, aes(fill = b1)) +
  geom_sf(data = dep, aes(fill = NULL), alpha = 0) + 
  scale_fill_gradientn(colours = cpt(pal = 'ocal_reds',rev = T))
 )




