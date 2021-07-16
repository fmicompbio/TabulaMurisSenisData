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
#' @param infoOnly Logical scalar. If \code{TRUE}, only print the total size
#'   of the files that will be downloaded to and/or retrieved from the cache.
#'
#' @return If \code{infoOnly} is \code{FALSE}, return a
#'   \linkS4class{SingleCellExperiment} object with a single matrix of counts.
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
#' @importFrom AnnotationHub getInfoOnIds
#' @importFrom SingleCellExperiment SingleCellExperiment
#' @importFrom gdata humanReadable
#'
TabulaMurisSenisBulk <- function(infoOnly = FALSE) {
    hub <- ExperimentHub::ExperimentHub()
    host <- file.path("TabulaMurisSenisData", "tabula-muris-senis-bulk")

    counts <- .getHubRecord(hub = hub, host = host, tissue = "",
                            suffix = "counts.rds")
    coldata <- .getHubRecord(hub = hub, host = host, tissue = "",
                             suffix = "coldata.rds")
    rowranges <- .getHubRecord(hub = hub, host = host, tissue = "",
                               suffix = "rowranges.rds")

    if (infoOnly) {
        totalSize <-
            as.numeric(AnnotationHub::getInfoOnIds(counts)$file_size) +
            as.numeric(AnnotationHub::getInfoOnIds(coldata)$file_size) +
            as.numeric(AnnotationHub::getInfoOnIds(rowranges)$file_size)
        message("Total download size: ",
                gdata::humanReadable(totalSize))
    } else {
        SingleCellExperiment::SingleCellExperiment(
            assays = list(counts = counts[[1]]),
            rowRanges = rowranges[[1]],
            colData = coldata[[1]]
        )
    }
}
