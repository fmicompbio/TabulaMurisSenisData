#' Get the Tabula Muris Senis FACS single-cell RNA-seq data
#'
#' @return A \linkS4class{SingleCellExperiment} object.
#'
#' @param processedCounts Logical scalar. If \code{TRUE}, include the processed
#'   counts in addition to the raw counts in the SingleCellExperiment object.
#' @param reducedDims Logical scalar. If \code{TRUE}, include the PCA and UMAP
#'   representations in the SingleCellExperiment object.
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
#'   sce <- TabulaMurisSenisFACS()
#' }
#'
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SummarizedExperiment assays
#' @importFrom SingleCellExperiment SingleCellExperiment reducedDims
#'
TabulaMurisSenisFACS <- function(processedCounts = FALSE,
                                 reducedDims = TRUE) {
    hub <- ExperimentHub::ExperimentHub()
    host <- file.path("TabulaMurisSenisData", "tabula-muris-senis-facs")
    counts <- hub[hub$rdatapath == file.path(host, "counts.h5")][[1]]
    proccounts <- hub[hub$rdatapath == file.path(host, "processed_counts.h5")][[1]]
    coldata <- hub[hub$rdatapath == file.path(host, "colData.rds")][[1]]
    rowdata <- hub[hub$rdatapath == file.path(host, "rowData.rds")][[1]]
    pca <- hub[hub$rdatapath == file.path(host, "pca.rds")][[1]]
    umap <- hub[hub$rdatapath == file.path(host, "umap.rds")][[1]]
    sce <- SingleCellExperiment::SingleCellExperiment(
        assays = list(counts = counts),
        rowData = rowdata,
        colData = coldata,
        reducedDims = list(PCA = pca,
                           UMAP = umap)
    )
    if (processedCounts) {
        SummarizedExperiment::assays(sce)[["logcounts"]] <- proccounts
    }
    if (reducedDims) {
        SingleCellExperiment::reducedDims(sce) <- list(PCA = pca, UMAP = umap)
    }
    sce
}
