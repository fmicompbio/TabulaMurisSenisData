#' Get the Tabula Muris Senis FACS single-cell RNA-seq data
#'
#' Access the FACS (Smart-Seq2) RNA-seq data from the Tabula Muris Senis
#' consortium.
#'
#' The data set was downloaded from figshare
#' (https://figshare.com/articles/dataset/Processed_files_to_use_with_scanpy_/8273102?file=23937842
#' for the full data set,
#' https://figshare.com/articles/dataset/Tabula_Muris_Senis_Data_Objects/12654728
#' for the individual tissue ones).
#'
#' @return If \code{infoOnly} is \code{FALSE}, returns a named list of
#'   \linkS4class{SingleCellExperiment} objects (one per tissue requested
#'   via \code{tissues}). Otherwise, each element in the list is `NULL`.
#'
#' @param tissues A character vector with the tissues to retrieve objects for.
#'   A list of available tissues can be obtained using
#'   \code{listTabulaMurisSenisTissues("FACS")}.
#' @param processedCounts Logical scalar. If \code{TRUE}, include the processed
#'   counts in addition to the raw counts in the SingleCellExperiment object.
#' @param reducedDims Logical scalar. If \code{TRUE}, include the PCA, tSNE
#'   and UMAP representations in the SingleCellExperiment object (the tSNE
#'   representation is not available for the full dataset ('All' tissue)).
#' @param infoOnly Logical scalar. If \code{TRUE}, only print the total size
#'   of the files that will be downloaded to and/or retrieved from the cache.
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
#'   sce <- TabulaMurisSenisFACS(tissues = "All")
#' }
#'
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#'
TabulaMurisSenisFACS <- function(tissues = "All", processedCounts = FALSE,
                                 reducedDims = TRUE, infoOnly = FALSE) {
    allowedTissues <- listTabulaMurisSenisTissues(dataset = "FACS")
    if (!all(tissues %in% allowedTissues)) {
        stop("'tissues' must be a subset of ",
             paste(allowedTissues, collapse = ", "))
    }

    hub <- ExperimentHub::ExperimentHub()
    host <- file.path("TabulaMurisSenisData", "tabula-muris-senis-facs")

    names(tissues) <- tissues
    .tmsSingleCell(hub = hub, host = host, tissues = tissues,
                   processedCounts = processedCounts,
                   reducedDims = reducedDims, infoOnly = infoOnly)
}
