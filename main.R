pacman::p_load(
  tidyverse,
  land4health,
  geoidep,
  cptcity,
  extrafont
  )

ee_Initialize()

# INPUT  -----------------------------------------------------------------------
DEPARTAMENTO <- 'CUSCO'

# Data processing  -------------------------------------------------------------
dep <- get_departaments() |> 
  filter(nombdep == DEPARTAMENTO)

dist <- get_districts(departamento = DEPARTAMENTO)

# Mean temperature from 2003 to 2020 
gf_day_1km <- ee$ImageCollection(
  "projects/sat-io/open-datasets/gap-filled-lst/gf_day_1km")$
  mean() |> 
  ee$Image$multiply(0.1)

tmean <- ee_extract(
  x = gf_day_1km,
  y = dist,
  fun = ee$Reducer$max(),
  sf = TRUE,
  scale = 1000)

# Design map -------------------------------------------------------------------
(map <-
  ggplot() + 
  geom_sf(data = tmean, aes(fill = b1),linewidth = 0.05) +
  geom_sf(data = dep, aes(fill = NULL), alpha = 0, color = "black") + 
  scale_fill_gradientn(
    name = 'Tmean °C',
    colours = cpt(pal = 'jjg_neo10_base_red_pink'),
    guide = guide_colorbar(
     barheight = unit(5, "cm"), 
     barwidth  = unit(0.4, "cm"))
    ) + 
   theme_void(base_family = 'Josefin Slab',base_size = 14) 
 )

ggsave(
  filename = paste0(str_to_lower(DEPARTAMENTO),'.svg'),
  plot = last_plot()
  )
