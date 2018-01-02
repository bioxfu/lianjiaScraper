#' Scrape house price from the Lianjia website
#'
#' @param city 'sh' (shanghai)
#' @param page_num Number of pages to scrape
#' @return A data frame
#' @examples
#' # In this version, we only support Shanghai city
#' price <- searchLianjia(city = 'sh', page_num = 100)
searchLianjia <- function(city = 'sh', page_num = 2) {
  community_info <- NULL
  pb <- txtProgressBar(min = 1, max = page_num, style = 3)
  for (i in 1:page_num) {
    setTxtProgressBar(pb, i)
    url <- paste0('http://', city, '.lianjia.com/xiaoqu/d', i)
    page <- xml2::read_html(url)
    location <- page %>% rvest::html_nodes('#house-lst .actshowMap_list') %>% rvest::html_attrs()
    location <- as.data.frame(do.call(rbind, location))
    location <- select(location, community=xiaoqu, districtname, platename)
    price <- page %>% rvest::html_nodes('.price .num') %>% rvest::html_text() %>% sub(pat='\n.+', rep='') %>% as.numeric()
    community_info <- rbind(community_info, data.frame(location, price, stringsAsFactors = F))
    Sys.sleep(5)
  }

  tmp <- apply(community_info[1], 1, split_community) %>% t()
  community_info$longitude <- as.numeric(tmp[, 1])
  community_info$latitude <- as.numeric(tmp[, 2])
  community_info$name <- tmp[, 3]
  return(community_info)
}

split_community <- function(x) {
  x <- sub('\\[', '', x)
  x <- sub('\\]', '', x)
  x <- gsub("'", '', x)
  strsplit(x, ', ')[[1]]
}
