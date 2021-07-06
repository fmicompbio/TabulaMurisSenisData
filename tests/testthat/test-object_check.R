test_that("downloading droplet data works", {
    droplet <- TabulaMurisSenisDroplet(tissues = "Large_Intestine",
                                       processedCounts = FALSE,
                                       reducedDims = TRUE)
    expect_is(droplet, "list")
    expect_named(droplet, "Large_Intestine")

    droplet_li <- droplet$Large_Intestine
    expect_s4_class(droplet_li, "SingleCellExperiment")
    expect_setequal(SummarizedExperiment::assayNames(droplet_li), "counts")
    expect_setequal(SingleCellExperiment::reducedDimNames(droplet_li),
                    c("PCA", "UMAP", "TSNE"))
    expect_equal(colnames(SingleCellExperiment::reducedDim(droplet_li, "PCA")),
                 paste0("PC", seq_len(ncol(SingleCellExperiment::reducedDim(droplet_li, "PCA")))))
    expect_equal(unique(as.character(droplet_li$tissue)), "Large_Intestine")
})

test_that("downloading facs data works", {
    facs <- TabulaMurisSenisFACS(tissues = "Aorta",
                                 processedCounts = FALSE,
                                 reducedDims = TRUE)
    expect_is(facs, "list")
    expect_named(facs, "Aorta")

    facs_ao <- facs$Aorta
    expect_s4_class(facs_ao, "SingleCellExperiment")
    expect_setequal(SummarizedExperiment::assayNames(facs_ao), "counts")
    expect_setequal(SingleCellExperiment::reducedDimNames(facs_ao),
                    c("PCA", "UMAP", "TSNE"))
    expect_equal(colnames(SingleCellExperiment::reducedDim(facs_ao, "PCA")),
                 paste0("PC", seq_len(ncol(SingleCellExperiment::reducedDim(facs_ao, "PCA")))))
    expect_equal(unique(as.character(facs_ao$tissue)), "Aorta")
})

test_that("downloading bulk data works", {
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
