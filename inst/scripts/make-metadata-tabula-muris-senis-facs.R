## validate with `ExperimentHubData::makeExperimentHubMetadata()`
## (above pkg directory)
suppressPackageStartupMessages({
    library(dplyr)
    library(tidyr)
})
convs <- c(coldata = "colData", counts = "counts", processed = "processed counts",
           rowdata = "rowData", pca = "PCA", tsne = "tSNE", umap = "UMAP")
convs2 <- c(coldata = "Cell metadata", counts = "Count matrix",
            processed = "Processed count matrix", rowdata = "Gene annotation",
            pca = "PCA representation", tsne = "tSNE representation",
            umap = "UMAP representation")
suffix <- c(coldata = ".rds", counts = ".h5", processed = ".h5", rowdata = ".rds",
            pca = ".rds", tsne = ".rds", umap = ".rds")
rdclass <- c(coldata = "DFrame", counts = "H5File", processed = "H5File",
             rowdata = "DFrame", pca = "matrix", tsne = "matrix", umap = "matrix")
filelist <- read.csv("tabula-muris-senis-files.csv") %>%
    dplyr::filter(dataset == "facs") %>%
    dplyr::mutate(tissue = sub("\\.h5ad", "",
                               sub("tabula-muris-senis-facs-processed-official-annotations[-]*",
                                   "", filename))) %>%
    dplyr::mutate(tissue = replace(tissue, tissue == "", "All")) %>%
    dplyr::mutate(outs = "coldata;counts;processed;rowdata;pca;tsne;umap") %>%
    tidyr::separate_rows(outs, sep = ";") %>%
    dplyr::mutate(outs2 = convs[outs],
                  descs = convs2[outs],
                  suffix = suffix[outs]) %>%
    dplyr::mutate(Title = paste0("Tabula Muris Senis FACS ", tissue, " ", outs2),
                  Description = paste0(descs, " for the Tabula Muris Senis FACS ",
                                       tissue, " scRNA-seq dataset"),
                  RDataPath = file.path("TabulaMurisSenisData", "tabula-muris-senis-facs",
                                        paste0(tissue, "_", outs, suffix)),
                  BiocVersion = "3.14",
                  Genome = "GRCm38",
                  SourceType = "HDF5",
                  SourceUrl = ifelse(tissue == "All",
                                     "https://figshare.com/articles/dataset/Processed_files_to_use_with_scanpy_/8273102?file=23937842",
                                     "https://figshare.com/articles/dataset/Tabula_Muris_Senis_Data_Objects/12654728"),
                  SourceVersion = "",
                  Species = "Mus musculus",
                  TaxonomyId = "10090",
                  Coordinate_1_based = NA,
                  DataProvider = "The Tabula Muris Consortium",
                  Maintainer = "Charlotte Soneson <charlottesoneson@gmail.com>",
                  RDataClass = rdclass[outs],
                  DispatchClass = ifelse(suffix == ".h5", "H5File", "Rds")) %>%
    dplyr::select(Title, Description, RDataPath, BiocVersion, Genome,
                  SourceType, SourceUrl, SourceVersion, Species, TaxonomyId,
                  Coordinate_1_based, DataProvider, Maintainer, RDataClass,
                  DispatchClass) %>%
    dplyr::filter(file.exists(RDataPath))

write.csv(
    filelist,
    file = "../extdata/metadata-tabula-muris-senis-facs.csv",
    row.names = FALSE
)
