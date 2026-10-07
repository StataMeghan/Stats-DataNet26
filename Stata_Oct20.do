/*
	Teaching with Stata
	Stats&DataNet Webinar
	October 20, 2026
	Meghan K. Cain, Ph.D.
	mcain@stata.com
*/

clear
import excel "STATA Lizards Data.xlsx", firstrow case(lower)

**# Data cleaning
rename massg mass
rename svlmm svl
label variable svl "Snout-vent length (mm)"
rename hindlimblengthmm hindlimb
rename hindspanmm hindspan
rename forelimbmm forelimb
rename forespanmm forespan
rename gapewidthmm gape
rename headdepthmm head
rename toepadwidthmm toepad
rename taillengthmm tail
rename island island_str
rename habitat habitat_str
encode island_str, generate(island)
encode habitat_str, generate(habitat)

generate total = svl + tail
label variable total "Total length (mm)"

notes: "See lizard_data.do"
note: Created on TS
label data "Assignment 10/5"

compress
save lizards, replace

**# Descriptive statistics
describe
codebook
list island habitat hind* for* in 1/10
list island habitat hind* for* if mass>3 in 1/10
list island habitat hind* for* if island_str=="Exuma"
list island habitat hind* for* if island==2
list habitat hind* for* if island==2 & mass>3
summarize
summarize mass, detail

**# Graphs
**## Bar graphs
graph bar (count), over(habitat_str, label(angle(forty_five))) ///
	over(island_str) asyvars 		///
	blabel(bar) ytitle("Number of lizards") ytitle(, size(large)) ///
	title("Number of lizards by island and habitat type")
graph save bargraph, replace
graph export bargraph.png, width(1000) replace
graph use bargraph

graph bar (count), ///
         over(habitat_str, label(angle(forty_five))) /// 
         over(island_str) ///
         asyvars blabel(bar) /// asyvars makes habitat color-coded
         ytitle("Number of lizards") ytitle(, size(large)) ///
         title("Number of lizards by island and habitat type") ///
         play(counts)

graph bar (mean) mass, over(habitat_str) over(island_str) asyvars

graph bar (mean) hind* for*, over(habitat_str, ///
	relabel(1 "Hindlimb" 2 "Hindspan" 3 "Forelimb" 4 "Forspan") ///
	label(angle(forty_five))) groupyvars by(island_str) subtitle(, nobox)


**## Histogram
histogram mass
histogram mass, bin(10)
histogram mass, bin(20)
histogram mass, width(1)
histogram mass, width(.2)
histogram mass, discrete
histogram mass, discrete normal kdensity kdenopts(lcolor(blue))
histogram mass, discrete normal kdensity kdenopts(lcolor(blue)) by(habitat)

**## Dot plots
dotplot mass, over(habitat)
** ssc install stripplot
stripplot mass, over(habitat) stack
stripplot mass, over(habitat) stack msymbol(circle)
generate lizard = "🦎"
stripplot mass, over(habitat) stack msymbol(none) mlabel(lizard) mlabposition(0)

**## Box plots
graph box mass, over(habitat)

**# Classification
**## Cutoffs
stripplot mass, over(habitat) stack msymbol(none) mlabel(lizard) ///
	mlabposition(0) xline(6.25)
stripplot mass, over(habitat) stack msymbol(none) mlabel(lizard) mlabposition(0)
* Graph Editor to move line and label, any other modifications, record and play

generate class_pred = cond(mass<=6.25,2,1)
label values class_pred habitat
tabulate class_pred habitat

generate class_correct = cond(class_pred==habitat,1,0)
summarize class_correct

* try with different cut-offs *
replace class_pred = cond(mass<=5.25,2,1)
replace class_correct = cond(class_pred==habitat,1,0)
summarize class_correct
tabulate class_pred habitat
* * * 

**## Scatterplots
twoway (scatter mass head)
twoway (scatter mass head) (lfit mass head, lwidth(medthick))
regress mass head
* Graph Editor to add labels Mass = -6 + 2 x Head depth + {&epsilon} and R{sup:2} = 0.44

twoway (scatter mass head) (lfit mass head, lwidth(medthick)), by(habitat)

twoway (scatter mass head, colorvar(i.habitat) zlabel(,valuelabel))

twoway (scatter mass head, colorvar(habitat) colordiscrete coloruseplegend) (lfit mass head if habitat_str=="Disturbed", lwidth(medthick)) (lfit mass head if habitat_str=="Natural", lwidth(medthick))

twoway (scatter mass head, colorvar(habitat) colordiscrete coloruseplegend colorlist(stc1 stc2)) (lfit mass head if habitat_str=="Disturbed", lwidth(medthick) lcolor(stc1)) (lfit mass head if habitat_str=="Natural", lwidth(medthick) lcolor(stc2))
* Graph Editor to clean up legend, record and then play below
twoway (scatter mass head, colorvar(habitat) colordiscrete coloruseplegend colorlist(stc1 stc2)) (lfit mass head if habitat_str=="Disturbed", lwidth(medthick) lcolor(stc1)) (lfit mass head if habitat_str=="Natural", lwidth(medthick) lcolor(stc2)), play(scatter)

twoway (scatter mass head, colorvar(habitat) colordiscrete coloruseplegend colorlist(stc1 stc2)) (lfit mass head if habitat_str=="Disturbed", lwidth(medthick) lcolor(stc1)) (lfit mass head if habitat_str=="Natural", lwidth(medthick) lcolor(stc2)) (scatteri 3.6 5.5, msize(2) mcolor(black)), play(scatter)


**# Regression
bysort habitat: regress mass head
generate mass_predicted =  -5.374016 +  2.13304*head
replace mass_predicted = -3.088168 + 1.415259*head if habitat==2
generate mass_residual = mass - mass_predicted

regress mass c.head##habitat
predict mass_pred2
predict mass_resid2, residual

browse mass*

margins habitat, at(head=(2/7)) plot

rvfplot
rvpplot head
lvr2plot
generate id = _n
lvr2plot, mlabel(id)

graph matrix mass hindlimb-head

