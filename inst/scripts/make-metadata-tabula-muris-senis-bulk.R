## validate with `ExperimentHubData::makeExperimentHubMetadata()`
## (above pkg directory)
write.csv(
    file = "../extdata/metadata-tabula-muris-senis-bulk.csv",
    data.frame(
        Title = sprintf("Tabula Muris Senis bulk %s", c("counts", "rowRanges", "colData")),
        Description = sprintf("%s for the Tabula Muris Senis bulk RNA-seq dataset",
                              c("Count matrix", "Gene annotation", "Sample metadata")),
        RDataPath = file.path("TabulaMurisSenisData", "tabula-muris-senis-bulk",
                              c("counts.rds", "rowranges.rds", "coldata.rds")),
        BiocVersion = "3.14",
        Genome = "GRCm38",
        SourceType = c("BAM", "BAM", "TXT"),
        SourceUrl = rep("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE132040", 3),
        SourceVersion = "",
        Species = "Mus musculus",
        TaxonomyId = "10090",
        Coordinate_1_based = NA,
        DataProvider = "GEO",
        Maintainer = "Charlotte Soneson <charlottesoneson@gmail.com>",
        RDataClass = c("matrix", "GRanges", "DFrame"),
        DispatchClass = "Rds",
        stringsAsFactors = FALSE
    ),
    row.names = FALSE
)
