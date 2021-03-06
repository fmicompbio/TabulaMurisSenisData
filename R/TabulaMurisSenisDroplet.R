#' Access the Tabula Muris Senis droplet single-cell RNA-seq data
#'
#' Access the droplet (10x Genomics) RNA-seq data from the Tabula Muris Senis
#' consortium.
#'
#' The data set was downloaded from figshare
#' (https://figshare.com/articles/dataset/Processed_files_to_use_with_scanpy_/8273102?file=23938934
#' for the full data set,
#' https://figshare.com/articles/dataset/Tabula_Muris_Senis_Data_Objects/12654728
#' for the individual tissue ones).
#'
#' @return A named list of \linkS4class{SingleCellExperiment} objects (one
#'   per tissue requested via \code{tissues}).
#'
#' @param tissues A character vector with the tissues to retrieve objects for.
#'   A list of available tissues can be obtained using
#'   \code{listTabulaMurisSenisTissues("Droplet")}.
#' @param processedCounts Logical scalar. If \code{TRUE}, include the processed
#'   counts in addition to the raw counts in the SingleCellExperiment object.
#' @param reducedDims Logical scalar. If \code{TRUE}, include the PCA, tSNE
#'   and UMAP representations in the SingleCellExperiment object (the tSNE
#'   representation is not available for the full dataset ('All' tissue)).
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
#'   sce <- TabulaMurisSenisDroplet(tissues = "All")
#' }
#'
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SummarizedExperiment assay
#' @importFrom SingleCellExperiment SingleCellExperiment reducedDim
#' @importFrom HDF5Array HDF5Array
#'
TabulaMurisSenisDroplet <- function(tissues = "All", processedCounts = FALSE,
                                    reducedDims = TRUE) {
    allowedTissues <- listTabulaMurisSenisTissues(dataset = "Droplet")
    if (!all(tissues %in% allowedTissues)) {
        stop("'tissues' must be a subset of ",
             paste(allowedTissues, collapse = ", "))
    }

    hub <- ExperimentHub::ExperimentHub()
    host <- file.path("TabulaMurisSenisData", "tabula-muris-senis-droplet")

    names(tissues) <- tissues
    out <- lapply(tissues, function(ts) {
        counts <- hub[hub$rdatapath ==
                          file.path(host, paste0(ts, "_counts.h5"))][[1]]
        coldata <- hub[hub$rdatapath ==
                           file.path(host, paste0(ts, "_coldata.rds"))][[1]]
        rowdata <- hub[hub$rdatapath ==
                           file.path(host, paste0(ts, "_rowdata.rds"))][[1]]
        sce <- SingleCellExperiment::SingleCellExperiment(
            assays = list(counts = HDF5Array::HDF5Array(counts,
                                                        name = "counts")),
            rowData = rowdata,
            colData = coldata
        )
        if (processedCounts) {
            proccounts <- hub[hub$rdatapath ==
                                  file.path(host,
                                            paste0(ts, "_processed.h5"))][[1]]
            SummarizedExperiment::assay(sce, "logcounts",
                                        withDimnames = FALSE) <-
                HDF5Array::HDF5Array(proccounts, name = "processed")
        }
        if (reducedDims) {
            pca <- hub[hub$rdatapath ==
                           file.path(host, paste0(ts, "_pca.rds"))][[1]]
            umap <- hub[hub$rdatapath ==
                            file.path(host, paste0(ts, "_umap.rds"))][[1]]
            SingleCellExperiment::reducedDims(sce) <- list(PCA = pca,
                                                           UMAP = umap)
            if (ts != "All") {
                tsne <- hub[hub$rdatapath ==
                                file.path(host, paste0(ts, "_tsne.rds"))][[1]]
                SingleCellExperiment::reducedDim(sce, "TSNE") <- tsne
            }
        }
        sce
    })
    out
}
