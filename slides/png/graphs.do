use https://www.stata-press.com/data/r19/fifeschool.dta, clear
keep if pid==2 | pid==4 |  pid==90

twoway (scatter attain vrq, msize(2.5) mcolor(black)) (lfit attain vrq, lcolor(black) lwidth(thick)), legend(off) xtitle("X") ytitle("Y")
graph export ols.png


twoway (scatter attain vrq, colorvar(pid) colordiscrete colorlist(stc1 stc2 stc3) msize(2.5) clegend(off)), xtitle("X") ytitle("Y")
graph export scatter_col.png

twoway (scatter attain vrq, colorvar(pid) colordiscrete colorlist(stc1 stc2 stc3) msize(2.5) clegend(off)) (lfit attain vrq, lcolor(black) lwidth(thick)), legend(off) xtitle("X") ytitle("Y")
graph export ols_col.png


twoway (scatter attain vrq, colorvar(pid) colordiscrete colorlist(stc1 stc2 stc3) msize(2.5) clegend(off)) ///
(lfit attain vrq if pid==2, lcolor(stc1) lwidth(thick)) (lfit attain vrq if pid==4, lcolor(stc2) lwidth(thick)) (lfit attain vrq if pid==90, lcolor(stc3) lwidth(thick)), xtitle("X") ytitle("Y")

addlegend: (circle, msize(2.5)) "Cluster 1" || (circle, msize(2.5)) "Cluster 2" || (circle, msize(2.5)) "Cluster 3" 

