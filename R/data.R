#' Demo time series dataset 1
#'
#' A sample dataset for exploring the DORA app,
#' containing object interaction bouts across an hour for 50 infants.
#'
#' @format A data frame with 16032 rows and 12 columns:
#' \describe{
#'   \item{id_onset}{Start onset for each participant in milliseconds}
#'   \item{id_offset}{End offset for each participant in milliseconds}
#'   \item{id}{Participant identifier}
#'   \item{agomo}{Participant age in months}
#'   \item{sex}{Participant sex, m = male; f = female}
#'   \item{onset}{The onset or start of every object interaction bout in milliseconds}
#'   \item{onset}{The offset or end of every object interaction bout in milliseconds}
#' }
#' @source Real example data 1
"object_play"
#' Demo time series dataset 2
#'
#' A sample dataset for exploring the DORA app,
#' containing physiology and behavior of mothers
#' and their 5-7 year old children across a 5-minute
#' stress task.
#' @format A data frame with 16705 rows and 18 columns:
#' \describe{
#'   \item{DyadID}{Dyad identifier}
#'   \item{dc_time}{Timestamp in seconds}
#'   \item{mom_IBI_Lego}{Continuous inter-beat intervals for mothers}
#'   \item{child_IBI_Lego}{Continuous inter-beat intervals for children}
#'   \item{mom_RSA_Lego}{Continuous respiratory sinus arrhythmia for mothers}
#'   \item{child_RSA_Lego}{Continuous respiratory sinus arrhythmia for children}
#'   \item{mom_HbO_dlpfc_l}{Oxygenated hemoglobin aggregated across the left dorsolateral prefrontal cortex for mothers}
#'   \item{mom_HbO_dlpfc_r}{Oxygenated hemoglobin aggregated across the right dorsolateral prefrontal cortex for mothers}
#'   \item{mom_HbR_dlpfc_l}{Deoxygenated hemoglobin aggregated across the left dorsolateral prefrontal cortex for mothers}
#'   \item{mom_HbR_dlpfc_r}{Deoxygenated hemoglobin aggregated across the right dorsolateral prefrontal cortex for mothers}
#'   \item{child_HbO_dlpfc_l}{Oxygenated hemoglobin aggregated across the left dorsolateral prefrontal cortex for children}
#'   \item{child_HbO_dlpfc_r}{Oxygenated hemoglobin aggregated across the right dorsolateral prefrontal cortex for children}
#'   \item{child_HbR_dlpfc_l}{Deoxygenated hemoglobin aggregated across the left dorsolateral prefrontal cortex for children}
#'   \item{child_HbR_dlpfc_r}{Deoxygenated hemoglobin aggregated across the right dorsolateral prefrontal cortex for children}
#'   \item{NA_child}{Children's negative affect; coded as 1 when present and 0 when not present}
#'   \item{PA_child}{Children's positive affect; coded as 1 when present and 0 when not present}
#'   \item{NA_Parent}{Mothers' negative affect; coded as 1 when present and 0 when not present}
#'   \item{PA_Parent}{Mothers' positive affect; coded as 1 when present and 0 when not present}
#' }
#' @source Real example data 2
"biobehavioral_interactions"
#' Demo time series dataset 3
#'
#' A sample dataset for exploring the DORA app,
#' containing music listening bouts...
#'
#' @format A data frame with X rows and Y columns:
#' \describe{
#'   \item{subjID}{Subject ID}
#'   \item{DayInSeconds}{time of day in cumulative seconds from midnight=0 of the start of the music bout}
#'   \item{ClocktimeSeconds}{time of day in H:M:S of the start of the music bout}
#'   \item{DLPspan}{was this music bout during the time span between when the DLP was first turned on and when it was last turned off ("DLP span")? 1=yes, 0=no}
#' }
#' @source Real example data 3
"music_bouts"
#' Demo time series dataset 4
#'
#' A sample dataset for exploring the DORA app,
#' containing object interaction bouts across an hour for 50 infants.
#'
#' @format A data frame with X rows and Y columns:
#' \describe{
#'   \item{id}{Participant identifier}
#'   \item{agegrp}{he age group that the subject is in. Format should be digits only (0, 4, 8, 12, 16, 20, 24).}
#'   \item{sex}{Sex of participant; m = male, f = female}
#'   \item{marital}{The marital status of the subject’s mother. s = single, m = married, w = widowed, d, = divorced, p = separated }
#' }
#' @source Real example data 4
"cradling_diaries"
