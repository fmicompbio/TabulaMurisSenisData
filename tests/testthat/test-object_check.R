test_that("downloading droplet data works", {
    expect_null(TabulaMurisSenisDroplet(tissues = "Large_Intestine",
                                        infoOnly = TRUE)[[1]])

    droplet <- TabulaMurisSenisDroplet(tissues = "Large_Intestine",
                                       processedCounts = TRUE,
                                       reducedDims = TRUE)
    expect_is(droplet, "list")
    expect_named(droplet, "Large_Intestine")

    droplet_li <- droplet$Large_Intestine
    expect_s4_class(droplet_li, "SingleCellExperiment")
    expect_setequal(SummarizedExperiment::assayNames(droplet_li),
                    c("counts", "logcounts"))
    expect_s4_class(SummarizedExperiment::assay(droplet_li, "counts"),
                    "DelayedMatrix")
    expect_s4_class(SummarizedExperiment::assay(droplet_li, "logcounts"),
                    "DelayedMatrix")
    expect_setequal(SingleCellExperiment::reducedDimNames(droplet_li),
                    c("PCA", "UMAP", "TSNE"))
    expect_equal(colnames(SingleCellExperiment::reducedDim(droplet_li, "PCA")),
                 paste0("PC", seq_len(ncol(
                     SingleCellExperiment::reducedDim(droplet_li, "PCA")))))
    expect_equal(colnames(SingleCellExperiment::reducedDim(droplet_li, "TSNE")),
                 paste0("TSNE", seq_len(ncol(
                     SingleCellExperiment::reducedDim(droplet_li, "TSNE")))))
    expect_equal(colnames(SingleCellExperiment::reducedDim(droplet_li, "UMAP")),
                 paste0("UMAP", seq_len(ncol(
                     SingleCellExperiment::reducedDim(droplet_li, "UMAP")))))
    expect_equal(unique(as.character(droplet_li$tissue)), "Large_Intestine")
    expect_equal(unique(as.character(droplet_li$method)), "droplet")

    ## Test that processed counts correspond to raw counts
    cts <- as.matrix(t(assay(droplet_li, "counts")))
    proc_counts <- log2(cts/rowSums(cts) * 1e4 + 1)
    proc_counts <- t(t(proc_counts)/apply(proc_counts, 2, sd))
    proc_counts[is.na(proc_counts)] <- 0
    proc_counts[proc_counts > 10] <- 10
    expect_true(
        max(abs(proc_counts - as.matrix(t(assay(droplet_li, "logcounts"))))) < 1e-5
    )

    ## Without reducedDims and processedCounts
    droplet <- TabulaMurisSenisDroplet(tissues = "Large_Intestine",
                                       processedCounts = FALSE,
                                       reducedDims = FALSE)
    expect_equal(length(SingleCellExperiment::reducedDims(droplet[[1]])), 0)
    expect_setequal(SummarizedExperiment::assayNames(droplet[[1]]), "counts")
})

test_that("downloading facs data works", {
    expect_null(TabulaMurisSenisFACS(tissues = "Aorta",
                                     infoOnly = TRUE)[[1]])

    facs <- TabulaMurisSenisFACS(tissues = "Aorta",
                                 processedCounts = TRUE,
                                 reducedDims = TRUE)
    expect_is(facs, "list")
    expect_named(facs, "Aorta")

    facs_ao <- facs$Aorta
    expect_s4_class(facs_ao, "SingleCellExperiment")
    expect_setequal(SummarizedExperiment::assayNames(facs_ao),
                    c("counts", "logcounts"))
    expect_s4_class(SummarizedExperiment::assay(facs_ao, "counts"),
                    "DelayedMatrix")
    expect_s4_class(SummarizedExperiment::assay(facs_ao, "logcounts"),
                    "DelayedMatrix")
    expect_setequal(SingleCellExperiment::reducedDimNames(facs_ao),
                    c("PCA", "UMAP", "TSNE"))
    expect_equal(colnames(SingleCellExperiment::reducedDim(facs_ao, "PCA")),
                 paste0("PC", seq_len(ncol(
                     SingleCellExperiment::reducedDim(facs_ao, "PCA")))))
    expect_equal(colnames(SingleCellExperiment::reducedDim(facs_ao, "TSNE")),
                 paste0("TSNE", seq_len(ncol(
                     SingleCellExperiment::reducedDim(facs_ao, "TSNE")))))
    expect_equal(colnames(SingleCellExperiment::reducedDim(facs_ao, "UMAP")),
                 paste0("UMAP", seq_len(ncol(
                     SingleCellExperiment::reducedDim(facs_ao, "UMAP")))))
    expect_equal(unique(as.character(facs_ao$tissue)), "Aorta")
    expect_equal(unique(as.character(facs_ao$method)), "facs")

    ## Test that processed counts correspond to raw counts
    cts <- as.matrix(t(assay(facs_ao, "counts")))
    proc_counts <- log2(cts/rowSums(cts) * 1e4 + 1)
    proc_counts <- t(t(proc_counts)/apply(proc_counts, 2, sd))
    proc_counts[is.na(proc_counts)] <- 0
    proc_counts[proc_counts > 10] <- 10
    expect_true(
        max(abs(proc_counts - as.matrix(t(assay(facs_ao, "logcounts"))))) < 1e-5
    )

    ## Without reducedDims and processedCounts
    facs <- TabulaMurisSenisFACS(tissues = "Aorta",
                                 processedCounts = FALSE,
                                 reducedDims = FALSE)
    expect_equal(length(SingleCellExperiment::reducedDims(facs[[1]])), 0)
    expect_setequal(SummarizedExperiment::assayNames(facs[[1]]), "counts")
})

test_that("downloading bulk data works", {
    expect_null(TabulaMurisSenisBulk(infoOnly = TRUE))

    bulk <- TabulaMurisSenisBulk()

    expect_s4_class(bulk, "SingleCellExperiment")
    expect_setequal(SummarizedExperiment::assayNames(bulk), "counts")
    expect_equal(length(unique(as.character(bulk$organ))), 18)
})

test_that("listing available tissues works", {
    drl <- listTabulaMurisSenisTissues(dataset = "Droplet")
    fl <- listTabulaMurisSenisTissues(dataset = "FACS")

    expect_error(listTabulaMurisSenisTissues(dataset = "Missing"))
    expect_equal(length(drl), 17)
    expect_equal(length(fl), 24)
})
