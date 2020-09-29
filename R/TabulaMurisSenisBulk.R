#' Get the Tabula Muris Senis bulk RNA-seq data
#'
#' @return A \linkS4class{SingleCellExperiment} object with a single matrix of
#'   counts.
#'
#' @author Charlotte Soneson
#'
#' @references
#'
#' @examples
#' sce <- TabulaMurisSenisBulk()
#'
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment
TabulaMurisSenisBulk <- function() {
    hub <- ExperimentHub::ExperimentHub()
    host <- file.path("TabulaMurisSenisData", "tabula-muris-senis-bulk")
    counts <- hub[hub$rdatapath == file.path(host, "counts.rds")][[1]]
    coldata <- hub[hub$rdatapath == file.path(host, "coldata.rds")][[1]]
    rowranges <- hub[hub$rdatapath == file.path(host, "rowranges.rds")][[1]]
    SingleCellExperiment::SingleCellExperiment(
        assays = list(counts = counts),
        rowRanges = rowranges,
        colData = coldata
    )
}
