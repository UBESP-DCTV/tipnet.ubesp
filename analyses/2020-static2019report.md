---
title: "TIP-Net static report"
subtitle: "2019"
author: "Corrado Lanera -- UBEP/UniPD"
date: "Padova, 2020-09-24"
output:
  bookdown::html_document2:
    toc: true
    toc_float: true
    keep_md: true
    fig_width: 10
    fig_height: 5
    fig_caption: true
---








# Overall TIP-Net



## Anagrafica

> n = pazienti


<!--html_preserve--><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script type="text/javascript">
<!--
    function expand_collapse(id) {
       var e = document.getElementById(id);
       var f = document.getElementById(id+"_earrows");
       if(e.style.display == 'none'){
          e.style.display = 'block';
          f.innerHTML = '&#9650';
       }
       else {
          e.style.display = 'none';
          f.innerHTML = '&#9660';
       }
    }
//-->
</script>
<style>
.earrows {color:silver;font-size:11px;}

fcap {
 font-family: Verdana;
 font-size: 12px;
 color: MidnightBlue
 }

smg {
 font-family: Verdana;
 font-size: 10px;
 color: &#808080;
}

hr.thinhr { margin-top: 0.15em; margin-bottom: 0.15em; }

span.xscript {
position: relative;
}
span.xscript sub {
position: absolute;
left: 0.1em;
bottom: -1ex;
}
</style>
 <font color="MidnightBlue"><div align=center><span style="font-weight:bold">anagrafica %>% inner_join(accettazione) %>% select(gender, etnia) <br><br> 2  Variables   3040  Observations</span></div></font> <hr class="thinhr"> <span style="font-weight:bold">gender</span> <style>
 .hmisctable338957 {
 border: none;
 font-size: 85%;
 }
 .hmisctable338957 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable338957 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable338957">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>3040</td><td>0</td><td>2</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value      maschio femmina
 Frequency     1697    1343
 Proportion   0.558   0.442
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">etnia</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAASFBMVEUAAAADAwMKCgonJydAQEBPT09oaGiGhoaJiYmNjY2oqKiqqqq1tbW2trbFxcXKysrR0dHa2trh4eHj4+Pr6+vv7+/39/f////uFI2pAAAAOElEQVQYlWNg4BVBBwwMfOLogPpiXILogFb28oiKiwmIi3Nyg8V4RdhYRIQY2EU4GIVFmFlF+JkA8NwS+V2rlL4AAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable434911 {
 border: none;
 font-size: 85%;
 }
 .hmisctable434911 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable434911 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable434911">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>3040</td><td>0</td><td>6</td></tr>
 </table>
 <style>
 .hmisctable615567 {
 border: none;
 font-size: 85%;
 }
 .hmisctable615567 td {
 text-align: right;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable615567 th {
 color: Black;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: bold;
 }
 </style>
 <table class="hmisctable615567">
 <tr><td><font color="MidnightBlue">lowest</font> :</td><td>caucasica  </td><td>ispanica   </td><td>asiatica   </td><td>africana   </td><td>araba      </td></tr>
 <tr><td><font color="MidnightBlue">highest</font>:</td><td>ispanica   </td><td>asiatica   </td><td>africana   </td><td>araba      </td><td>etnia mista</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value        caucasica    ispanica    asiatica    africana       araba etnia mista
 Frequency         2516          57         124         102         185          56
 Proportion       0.828       0.019       0.041       0.034       0.061       0.018
 </pre>
 <hr class="thinhr"><!--/html_preserve-->

## Descrittive principali

> n = ingressi



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
&nbsp;                                                                                                                                     N           maschio  (N=1697)               femmina  (N=1343)              Combined  (N=3040)       
---------------------------------------------------------------------------------------------------------------------------------------- ------ ------------------------------- ------------------------------- -------------------------------
eta_giorni                                                                                                                                1516        19.8/ 299.0/1940.0              24.0/ 382.5/2396.0              21.8/ 331.0/2167.5       
                                                                                                                                                        1322.5+/-1888.9                 1523.8+/-2343.4                 1413.9+/-2109.0        

priorita                                                                                                                                  2722                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;1                                                                                                                                 59% ( 901)                      60% ( 720)                      60% (1621)           

&nbsp;&nbsp;&nbsp;&nbsp;2                                                                                                                                 34% ( 513)                      34% ( 408)                      34% ( 921)           

&nbsp;&nbsp;&nbsp;&nbsp;3                                                                                                                                  3% ( 40)                        2% ( 28)                        2% ( 68)            

&nbsp;&nbsp;&nbsp;&nbsp;4a                                                                                                                                 4% ( 62)                        4% ( 47)                        4% ( 109)           

&nbsp;&nbsp;&nbsp;&nbsp;4b                                                                                                                                  0% ( 2)                         0% ( 1)                         0% ( 3)            

ricovero_progr                                                                                                                            2710                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;si                                                                                                                                33% ( 491)                      34% ( 405)                      33% ( 896)           

&nbsp;&nbsp;&nbsp;&nbsp;no                                                                                                                                67% (1019)                      66% ( 795)                      67% (1814)           

tipologia                                                                                                                                 2604                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;chirurgico                                                                                                                        41% ( 593)                      42% ( 490)                      42% (1083)           

&nbsp;&nbsp;&nbsp;&nbsp;medico                                                                                                                            59% ( 852)                      58% ( 669)                      58% (1521)           

&nbsp;&nbsp;&nbsp;&nbsp;soffocamento                                                                                                                        0% ( 0)                         0% ( 0)                         0% ( 0)            

motivo_ricovero                                                                                                                           1519                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;insufficienza&nbsp;respiratoria                                                                                                    50% (426)                       53% (356)                       51% (782)           

&nbsp;&nbsp;&nbsp;&nbsp;alterato&nbsp;sensorio&nbsp;/&nbsp;crisi&nbsp;convulsive                                                                           16% (135)                       15% (102)                       16% (237)           

&nbsp;&nbsp;&nbsp;&nbsp;disordini&nbsp;metabolici&nbsp;/&nbsp;disidratazione                                                                               7% ( 58)                        5% ( 31)                        6% ( 89)            

&nbsp;&nbsp;&nbsp;&nbsp;insufficienza&nbsp;cardiocircolatoria&nbsp;(no&nbsp;shock&nbsp;settico)                                                            4% ( 36)                        6% ( 42)                        5% ( 78)            

&nbsp;&nbsp;&nbsp;&nbsp;insufficienza&nbsp;renale&nbsp;acuta                                                                                               2% ( 17)                         1% ( 9)                        2% ( 26)            

&nbsp;&nbsp;&nbsp;&nbsp;diagnosi&nbsp;sepsi&nbsp;correlata&nbsp;(di&nbsp;natura&nbsp;diversa&nbsp;da&nbsp;respiro&nbsp;cuore&nbsp;snc)                     4% ( 37)                        4% ( 25)                        4% ( 62)            

&nbsp;&nbsp;&nbsp;&nbsp;monitoraggio&nbsp;/&nbsp;osservazione                                                                                              13% (107)                       12% ( 83)                       13% (190)           

&nbsp;&nbsp;&nbsp;&nbsp;programmato&nbsp;per&nbsp;procedure&nbsp;invasive                                                                                  4% ( 32)                        3% ( 18)                        3% ( 50)            

&nbsp;&nbsp;&nbsp;&nbsp;prematurità                                                                                                                         0% ( 0)                         0% ( 2)                         0% ( 2)            

&nbsp;&nbsp;&nbsp;&nbsp;asfissia&nbsp;perinatale                                                                                                            0% ( 1)                         0% ( 0)                         0% ( 1)            

&nbsp;&nbsp;&nbsp;&nbsp;cardiopatia&nbsp;congenita                                                                                                          0% ( 2)                         0% ( 0)                         0% ( 2)            

age_class                                                                                                                                 3040                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;adolescente                                                                                                                        5% ( 90)                        6% ( 78)                        6% ( 168)           

&nbsp;&nbsp;&nbsp;&nbsp;adulto                                                                                                                              0% ( 7)                        1% ( 12)                        1% ( 19)            

&nbsp;&nbsp;&nbsp;&nbsp;giorni&nbsp;negativi                                                                                                                0% ( 0)                         0% ( 1)                         0% ( 1)            

&nbsp;&nbsp;&nbsp;&nbsp;lattanti                                                                                                                          12% ( 203)                      12% ( 157)                      12% ( 360)           

&nbsp;&nbsp;&nbsp;&nbsp;missing                                                                                                                           51% ( 869)                      49% ( 655)                      50% (1524)           

&nbsp;&nbsp;&nbsp;&nbsp;neonati                                                                                                                           13% ( 226)                      14% ( 183)                      13% ( 409)           

&nbsp;&nbsp;&nbsp;&nbsp;prescolare                                                                                                                        11% ( 181)                      11% ( 143)                      11% ( 324)           

&nbsp;&nbsp;&nbsp;&nbsp;scolare                                                                                                                            7% ( 121)                       8% ( 114)                       8% ( 235)           

pim2                                                                                                                                      1153   0.78/ 1.54/ 4.62 6.22+/-14.26   0.71/ 1.35/ 4.78 5.50+/-12.34   0.75/ 1.48/ 4.66 5.89+/-13.42 

pim3                                                                                                                                      1153   0.52/ 1.33/ 3.88 4.87+/-12.46   0.48/ 0.99/ 3.91 4.37+/-10.88   0.50/ 1.22/ 3.91 4.64+/-11.76 

tecnica_1                                                                                                                                 187                                                                                                  

&nbsp;&nbsp;&nbsp;&nbsp;niv                                                                                                                                28% ( 30)                       22% ( 18)                       26% ( 48)           

&nbsp;&nbsp;&nbsp;&nbsp;it                                                                                                                                 72% ( 77)                       78% ( 62)                       74% (139)           

tipo_inf                                                                                                                                  606                                                                                                  

&nbsp;&nbsp;&nbsp;&nbsp;comunità                                                                                                                           79% (274)                       82% (213)                       80% (487)           

&nbsp;&nbsp;&nbsp;&nbsp;nosocomiale&nbsp;(dopo&nbsp;48h&nbsp;da&nbsp;ricovero)                                                                             21% ( 72)                       18% ( 47)                       20% (119)           

durata_degenza                                                                                                                            504      2.0/ 5.0/12.0 10.5+/-16.7       3.0/ 6.0/12.0 15.2+/-34.5       2.0/ 5.0/12.0 12.5+/-25.8   

esito_osp                                                                                                                                 489                                                                                                  

&nbsp;&nbsp;&nbsp;&nbsp;vivo                                                                                                                              100% (257)                      100% (232)                      100% (489)           

&nbsp;&nbsp;&nbsp;&nbsp;morto                                                                                                                               0% ( 0)                         0% ( 0)                         0% ( 0)            

mod_decesso                                                                                                                                70                                                                                                  

&nbsp;&nbsp;&nbsp;&nbsp;morte&nbsp;nonostante&nbsp;rianimazione&nbsp;cardiopolmonare                                                                       56% (23)                        55% (16)                        56% (39)            

&nbsp;&nbsp;&nbsp;&nbsp;sospensione&nbsp;dei&nbsp;trattamenti&nbsp;di&nbsp;supporto&nbsp;vitale                                                             7% ( 3)                        10% ( 3)                         9% ( 6)            

&nbsp;&nbsp;&nbsp;&nbsp;astensione&nbsp;dall'iniziare&nbsp;trattamenti&nbsp;di&nbsp;supporto&nbsp;vitale                                                   10% ( 4)                        14% ( 4)                        11% ( 8)            

&nbsp;&nbsp;&nbsp;&nbsp;decisione&nbsp;di&nbsp;non&nbsp;rianimare                                                                                          17% ( 7)                        17% ( 5)                        17% (12)            

&nbsp;&nbsp;&nbsp;&nbsp;morte&nbsp;cerebrale                                                                                                               10% ( 4)                         3% ( 1)                         7% ( 5)            

esito_tip                                                                                                                                 2838                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;vivo                                                                                                                              97% (1549)                      97% (1207)                      97% (2756)           

&nbsp;&nbsp;&nbsp;&nbsp;morto                                                                                                                              3% ( 46)                        3% ( 36)                        3% ( 82)            

diagnosi                                                                                                                                  1809                                                                                                 

&nbsp;&nbsp;&nbsp;&nbsp;incidenti                                                                                                                          8% ( 77)                        6% ( 50)                        7% ( 127)           

&nbsp;&nbsp;&nbsp;&nbsp;congenito                                                                                                                           0% ( 0)                         0% ( 0)                         0% ( 0)            

&nbsp;&nbsp;&nbsp;&nbsp;acquisito                                                                                                                           0% ( 0)                         0% ( 0)                         0% ( 0)            

&nbsp;&nbsp;&nbsp;&nbsp;neurologico                                                                                                                       24% ( 237)                      22% ( 176)                      23% ( 413)           

&nbsp;&nbsp;&nbsp;&nbsp;via&nbsp;aerea&nbsp;superiore                                                                                                       0% ( 0)                         0% ( 0)                         0% ( 0)            

&nbsp;&nbsp;&nbsp;&nbsp;via&nbsp;aerea&nbsp;inferiore                                                                                                       0% ( 0)                         0% ( 0)                         0% ( 0)            

&nbsp;&nbsp;&nbsp;&nbsp;altro                                                                                                                               0% ( 0)                         0% ( 0)                         0% ( 0)            

&nbsp;&nbsp;&nbsp;&nbsp;renale                                                                                                                             5% ( 47)                        3% ( 24)                        4% ( 71)            

&nbsp;&nbsp;&nbsp;&nbsp;gastrointestinale                                                                                                                  10% ( 99)                       10% ( 81)                      10% ( 180)           

&nbsp;&nbsp;&nbsp;&nbsp;miscellanea                                                                                                                       54% ( 548)                      59% ( 470)                      56% (1018)           
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

