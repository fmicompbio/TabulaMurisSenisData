## Helper function to get a hub record
.getHubRecord <- function(hub, host, tissue, suffix) {
    res <- hub[hub$rdatapath ==
                   file.path(host, paste0(tissue, suffix))]
    if (length(res) != 1) {
        stop("(", tissue, ") Error - expected a single ",
             sub("^_", "", suffix), " file")
    }
    res
}

## Function to get single-cell data (droplet/FACS)
#' @importFrom AnnotationHub getInfoOnIds
#' @importFrom SummarizedExperiment assay
#' @importFrom SingleCellExperiment SingleCellExperiment reducedDim
#' @importFrom HDF5Array HDF5Array
#' @importFrom gdata humanReadable
.tmsSingleCell <- function(hub, host, tissues, processedCounts,
                           reducedDims, infoOnly) {
    lapply(tissues, function(ts) {
        totalSize <- 0

        ## counts, colData, rowData
        ## --------------------------------------------------------------------
        counts <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                suffix = "_counts.h5")
        coldata <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                 suffix = "_coldata.rds")
        rowdata <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                 suffix = "_rowdata.rds")
        if (infoOnly) {
            totalSize <- totalSize +
                as.numeric(AnnotationHub::getInfoOnIds(counts)$file_size) +
                as.numeric(AnnotationHub::getInfoOnIds(coldata)$file_size) +
                as.numeric(AnnotationHub::getInfoOnIds(rowdata)$file_size)
        } else {
            sce <- SingleCellExperiment::SingleCellExperiment(
                assays = list(counts = HDF5Array::HDF5Array(counts[[1]],
                                                            name = "counts")),
                colData = coldata[[1]],
                rowData = rowdata[[1]]
            )
        }

        ## processedCounts
        ## --------------------------------------------------------------------
        if (processedCounts) {
            proccounts <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                        suffix = "_processed.h5")
            if (infoOnly) {
                totalSize <- totalSize +
                    as.numeric(AnnotationHub::getInfoOnIds(proccounts)$file_size)
            } else {
                SummarizedExperiment::assay(sce, "logcounts",
                                            withDimnames = FALSE) <-
                    HDF5Array::HDF5Array(proccounts[[1]], name = "processed")
            }
        }

        ## reducedDims
        ## --------------------------------------------------------------------
        if (reducedDims) {
            pca <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                 suffix = "_pca.rds")
            umap <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                  suffix = "_umap.rds")
            if (infoOnly) {
                totalSize <- totalSize +
                    as.numeric(AnnotationHub::getInfoOnIds(pca)$file_size) +
                    as.numeric(AnnotationHub::getInfoOnIds(umap)$file_size)
            } else {
                SingleCellExperiment::reducedDims(sce) <- list(PCA = pca[[1]],
                                                               UMAP = umap[[1]])
            }
            if (ts != "All") {
                tsne <- .getHubRecord(hub = hub, host = host, tissue = ts,
                                      suffix = "_tsne.rds")
                if (infoOnly) {
                    totalSize <- totalSize +
                        as.numeric(AnnotationHub::getInfoOnIds(tsne)$file_size)
                } else {
                    SingleCellExperiment::reducedDim(sce, "TSNE") <- tsne[[1]]
                }
            }
        }
        if (infoOnly) {
            message("Total download size (", ts, "): ",
                    gdata::humanReadable(totalSize))
        } else {
            sce
        }
    })
}
