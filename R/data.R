#' Demo time series dataset 1
#'
#' A sample dataset for exploring the DORA app,
#' containing object interaction bouts across an hour for 50 infants.
#'
#' @format A data frame with 16032 rows and 58 columns:
#' \describe{
#'   \item{id}{Participant identifier}
#'   \item{id_onset}{Start onset for each participant in milliseconds}
#'   \item{id_offset}{End offset for each participant in milliseconds}
#'   \item{agemo}{Participant age in months}
#'   \item{sex}{Participant sex, m = male; f = female}
#'   \item{onset}{The onset or start of every object interaction bout in milliseconds}
#'   \item{offset}{The offset or end of every object interaction bout in milliseconds}
#'   \item{bobj}{The object engagement status: 'o' = object, '.' = out of view}
#'   \item{objcat}{Category of object interaction (e.g., toy)}
#' }
#' @source Tamis-LeMonda, C., Adolph, K. & Herzberg, O. (2020). Infant exuberant object play at home: Immense amounts of time-distributed, variable practice. Databrary. Retrieved May 14, 2026 from https://databrary.org/volume/1118.
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
#' containing music listening bouts from daylong recordings
#' of 35 infants ages 6-12 months at home. Music bouts were
#' fully double-coded and include 467 hours of everyday music
#' and its features, tunes, and voices.
#' @format A data frame with 4,798 rows and 28 columns:
#' \describe{
#'   \item{subjID}{Subject ID}
#'   \item{DayInSeconds}{time of day in cumulative seconds from midnight=0 of the start of the music bout}
#'   \item{ClocktimeSeconds}{time of day in H:M:S of the start of the music bout}
#'   \item{DLPspan}{was this music bout during the time span between when the DLP was first turned on and when it was last turned off ("DLP span")? 1=yes, 0=no}
#'   \item{DLP_On}{was this music bout from a portion of the recording when the DLPwas  turned on? 1=yes, 0=no}
#'   \item{DLPon_NoPrivNoOut}{was this music bout from a portion of the recording when the DLP was turned on AND not from a  privacy or outside-home section? 1=yes, 0=no}
#'   \item{AudSound_Edited}{was this music bout from a portion of the recording that was coded? 1=yes, 0=no}
#'   \item{MusicBouts}{was this music bout from a portion of the recording that was coded as a music bout? 1=yes, 0=no}
#'   \item{MusicBout_Smoothed}{the number of the music bout based on the ELAN coding (smoothed bouts show the numbers of the first and last ELAN bout in the set separated by "_")}
#'   \item{Goof}{was this music bout coded as a 'goof' bout? 1=yes, 0=no}
#'   \item{Live}{was this music bout coded as 'live'? 1=yes, 0=no}
#'   \item{Recorded}{was this music bout coded as 'recorded'? 1=yes, 0=no}
#'   \item{Vocal}{was this music bout coded as 'vocal'? 1=yes, 0=no}
#'   \item{Instrumental}{was this music bout coded as 'instrumentall'? 1=yes, 0=no}
#'   \item{Voices_Tunes}{Voices and tunes coded in the music bout. Tunes are linked to the voice that produced them with "_".  Multiple voice_tune combinations are separated by "QQQ"}
#'   \item{Voices_Unique}{the unique set of voices coded in the music bout, separated by "QQQ"}
#'   \item{Tunes_Unique}{the unique set of tunes coded in the music bout, separated by "QQQ"}
#'   \item{Tunes_Voc}{the unqiue set of tunes that were produced by a voice in the music bout, separated by "QQQ"}
#'   \item{Tunes_Instr}{the unique set of instrumental tunes in the music bout, separated by "QQQ"}
#'   \item{Goof_firstRow}{was this the first row of a goof bout? 1=yes, 0=no}
#'   \item{MusicBouts_noGoofs}{was this part of a music bout AND not marked as a goof? 1=yes, 0=no}
#'   \item{MBfirstRow}{is this the first row of a music bout? 1=yes, 0=no}
#'   \item{oneVoice}{does this music bout have exactly 1 unique voice? 1=yes, 0=no}
#'   \item{oneTune}{does this music bout have exactly 1 unique tune? 1=yes, 0=no}
#'   \item{LV_1V1T}{was this music bout coded as 'live', 'vocal' (but not as 'vocal' or 'instrumental'), and does it have exactly 1 unique voice and 1 unique tune? 1=yes, 0=no}
#'   \item{RVI_1V1T}{was this music bout coded as 'recorded', 'vocal', & 'instrumental (but not as 'live'), and does it have exactly 1 unique voice and 1 unique tune? 1=yes, 0=no}
#'   \item{DurationSecs}{the duration in seconds of the music bout}
#'   \item{PauseSecs}{the duration in seconds of the interval between the end of this music bout and the beginning of the subsequent music bout}
#' }
#' @source Mendoza, J. K., & Fausey, C. M. (2022, January 14). Everyday Music in Infancy. https://doi.org/10.17605/OSF.IO/EB9PW
"music_bouts"
#' Demo time series dataset 4
#'
#' A sample dataset for exploring the DORA app,
#' containing detailed coding of gahvora cradle use,
#' daily routines, including location and feeding,
#' and structured tasks, including behaviorally-coded
#' object interactions, and AIMS skills for
#' 118 infants (aged 12, 16, 20 months).
#'
#' @format A data frame with 6073 rows and 105 columns:
#' \describe{
#'   \item{id}{Participant identifier}
#'   \item{agegrp}{The age group that the subject is in. Format should be digits only (0, 4, 8, 12, 16, 20, 24).}
#'   \item{sex}{Sex of participant; m = male, f = female}
#'   \item{marital}{The marital status of the subject’s mother. s = single, m = married, w = widowed, d = divorced, p = separated}
#'   \item{region}{The region where data collection occurred (e.g., k = Khatlon, r = Rasht, d = Dushanbe)}
#'   \item{numkids}{The number of children the mother has}
#'   \item{mworktyp}{Mother's work type outside the home}
#'   \item{fworktyp}{Father's work type outside the home}
#'   \item{tempout}{The temperature outdoors (in degrees Celsius)}
#'   \item{tempin}{The temperature indoors (in degrees Celsius)}
#' }
#' @source Karasik, L., Tamis-LeMonda, C. & Adolph, K. (2014). The Ties That Bind: Cradling in Tajikistan. Databrary. Retrieved May 14, 2026 from https://www.databrary.org/volume/11.
"cradling_diaries"
