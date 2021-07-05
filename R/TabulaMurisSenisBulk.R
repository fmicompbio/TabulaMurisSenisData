#' Access the Tabula Muris Senis bulk RNA-seq data
#'
#' Access the bulk RNA-seq data from the Tabula Muris Senis consortium.
#'
#' The data set was downloaded from GEO (accession number GSE132040). The
#' summary statistics from HTSeq-count were combined with the provided sample
#' metadata and included in the colData of the object. In addition,
#' gene annotations from GENCODE vM19 were downloaded and included in the
#' rowRanges of the object.
#'
#' @return A \linkS4class{SingleCellExperiment} object with a single matrix of
#'   counts.
#'
#' @author Charlotte Soneson
#'
#' @references
#' Schaum et al (2019): The murine transcriptome reveals global aging nodes with
#' organ-specific phase and amplitude. bioRxiv doi:10.1101/662254.
#'
#' The Tabula Muris Consortium (2020): A single-cell transcriptomic atlas
#' characterizes ageing tissues in the mouse. Nature 583:590–595.
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
