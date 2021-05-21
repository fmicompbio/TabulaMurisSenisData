#' Get the Tabula Muris Senis bulk RNA-seq data
#'
#' @return A \linkS4class{SingleCellExperiment} object with a single matrix of
#'   counts.
#'
#' @author Charlotte Soneson
#'
#' @references
#' Schaum et al.: The murine transcriptome reveals global aging nodes with
#' organ-specific phase and amplitude. bioRxiv doi:10.1101/662254 (2019).
#'
#' The Tabula Muris Consortium: A single-cell transcriptomic atlas
#' characterizes ageing tissues in the mouse. Nature 583:590–595 (2020).
#'
#' @examples
#' if (interactive()) {
#'   sce <- TabulaMurisSenisBulk()
#' }
#'
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment
#'
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
