#' List available tissues for the Tabula Muris Senis datasets
#'
#' @param dataset Either 'Droplet' or 'FACS'
#'
#' @export
#'
listTabulaMurisSenisTissues <- function(dataset) {
    if (dataset == "Droplet") {
        c("All", "Large_Intestine", "Pancreas", "Trachea", "Skin",
          "Fat", "Thymus", "Liver", "Heart_and_Aorta",
          "Mammary_Gland", "Bladder", "Lung", "Kidney",
          "Limb_Muscle", "Spleen", "Tongue", "Marrow")
    } else if (dataset == "FACS") {
        c("All", "Aorta", "Kidney", "Diaphragm", "BAT", "Spleen",
          "Limb_Muscle", "Liver", "MAT", "Thymus", "Trachea",
          "GAT", "SCAT", "Bladder", "Lung", "Mammary_Gland",
          "Pancreas", "Skin", "Tongue", "Brain_Non-Myeloid",
          "Heart", "Brain_Myeloid", "Large_Intestine", "Marrow")
    } else {
        stop("Invalid 'dataset' (must be either 'Droplet' or 'FACS')")
    }
}
