## validate with `ExperimentHubData::makeExperimentHubMetadata()`
## (above pkg directory)
write.csv(
    file = "../extdata/metadata-tabula-muris-senis-droplet.csv",
    data.frame(
        Title = sprintf("Tabula Muris Senis droplet %s", c("counts", "rowData", "colData")),
        Description = sprintf("%s for the Tabula Muris Senis droplet scRNA-seq dataset",
                              c("Full rectangular, block-compressed format, 1GB block size h5 file", "Row (gene) metadata", "Column (sample) metadata")),
        RDataPath = file.path("TabulaMurisSenisData", "tabula-muris-senis-droplet",
                              c("counts.h5", "rowData.rds", "colData.rds")),
        BiocVersion = "3.12",
        Genome = "GRCm38",
        SourceType = c("", "", ""),
        SourceUrl = rep("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM4505404", 3),
        SourceVersion = "",
        Species = "Mus musculus",
        TaxonomyId = "10090",
        Coordinate_1_based = NA,
        DataProvider = "GEO",
        Maintainer = "Charlotte Soneson <charlottesoneson@gmail.com>",
        RDataClass = "character",
        DispatchClass = c("H5File", "Rds", "Rds"),
        stringsAsFactors = FALSE
    ),
    row.names = FALSE
)
