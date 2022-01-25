
<!-- README.md is generated from README.Rmd. Please edit that file -->

# safe.run

<!-- badges: start -->

<!-- badges: end -->

The goal of safe.run is to …

## Installation

You can install the released version of safe.run from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("safe.run")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cjyetman/safe.run")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(safe.run)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!

# FIXME integrate text into skeleton above

# safe.run

no, so here’s the deal…. when you select multiple lines of commands in
the editor of RStudio and click command-return (or whatever that is on
Windows), it will essentially paste each line of the selected text into
the console and run them sequentially. The problem with that is… if one
of the command fails or errors, RStudio doesn’t care and then it will
continue copy-pasting-running all the lines after that. Often, that’s
not a big deal, but…. often (especially with not very cautious R users)
it means that a bunch of lines of code that shouldn’t run, do run… and
the result of that can be… They start looking for the problem from the
bottom of the console starting with the last error instead of the first
error (I know, they shouldn’t, but they do… even I do it when I’m being
sloppy, especially when it’s a lot of output). That leads to users
wondering why a particular function failed and believing that something
is wrong with one of the last lines in the code chunk they ran, and they
start messing with how those commands are written, when in reality they
simply failed because some object or setting that was not set properly
in one of the lines before it didn’t get set properly because a previous
command failed. Sometimes, that can lead to the environment filling up
with a bunch of objects that are improperly specified. and worst, if
there’s a command in there that is “expensive” (time, over-writing
files, etc.), it will run even if the setup for it above failed for
instance… x \<- 2 stopifnot(x == 1) message(“the next command will take
a long time, but is only relevant if x==1”) Sys.sleep(10)
message(“finished\!\!\!”) if you select all of those lines and click
command-return, they will all run, you’ll get the error and the message,
but then it will continue and run the rest anyway. It’s an absurd, but
very simple example. Imagine the Sys.sleep(10) command actually ran a
time-consuming process that would overwrite a bunch of important output
files. There’s a simple way of getting around that… something that I
used to do manually all the time… wrap the code chunk in { } so it runs
as a function. So that’s all this thing would do… take whatever is
selected as a string, prepend a { to the beginning, append a } to the
end, and then send the whole chunk at once to the console. So now, save
this function into your environment… \# Safe Execute Current Selection
safe\_execute \<- function() { context \<-
rstudioapi::getActiveDocumentContext() command \<- paste0(‘{’,
context\(selection[[1]]\)text, ‘}’) rstudioapi::sendToConsole(command) }
then select the original code chunk im your editor again, and this time
run safe\_execute() in the console. So the idea is to simply wrap that
into a R package that registers this function as an addin, and then
suggest to the users to remap the default key command command-return to
the addin’s safe\_excute function.
