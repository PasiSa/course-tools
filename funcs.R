read.roundfb <- function(str, fb, path="")
    {
        fname <- sprintf("%s/../feedback/%s-summary.csv", path, str)
        a <- read.table(fname, sep=";")
        if (dim(a[a$V2 == -1,])[1] > 0)
            {
                a[a$V2 == -1,]$V2 <- NA
            }
        if (dim(a[a$V3 == -1,])[1] > 0)
            {
                a[a$V3 == -1,]$V3 <- NA
            }
        if (dim(a[a$V4 == -1,])[1] > 0)
            {
                a[a$V4 == -1,]$V4 <- NA
            }
        fb[[str]] <- a
        return(fb)
    }

#read.all <- function()
#    {
#        fb <- c()
#        fb <- read.roundfb("01", fb)
#        fb <- read.roundfb("02", fb)
#        return(fb)
#    }

hist.feedback <- function(str, feedback, path)
    {
        mytitle <- sprintf("Round %s: How difficult was this round?", str)
        fname <- sprintf("%s/%s-diff.svg", path, str)
        #png(fname)
        svg(fname, width=7, height=7)
        hist(feedback[[str]]$V2, col="blue", las=1, xlab="1=easy, 5=difficult", main=mytitle)
        dev.off()

        mytitle <- sprintf("Round %s: Learning objectives achieved?", str)
        fname <- sprintf("%s/%s-learn.svg", path,str)
        #png(fname)
        svg(fname, width=7, height=7)
        hist(feedback[[str]]$V3, col="blue", las=1, xlab="1=disagree, 5=agree", main=mytitle)
        dev.off()
    }

cdfpoints <- function(fnin, outpath, round, colname)
    {
        a <- read.csv(fnin, sep=";",
                      header=T, stringsAsFactors=F)

        fnout = sprintf("%s/%s-cdfpoints.svg", outpath, round)
        svg(fnout, width=7, height=7)
            #X1.basics for c++
            plot(ecdf(as.numeric(a[[colname]])), lty=1, main="Cumulative distribution of points achieved", xlab="Number of points")
            dev.off()
    }

read.answersummary <- function(fname)
    {
        #fname <- sprintf("../stats/ans-%s-all.csv", round)
        a <- read.table(fname, sep=";", header=F)
        return(a)
    }

tasksummary <- function(a, tasks, labels, round, path)
    {
        x1 = factor(a[,3], levels=tasks)
        fname <- sprintf("%s/%s-numattempts.svg", path, round)
#        png(fname, width=800, height=600)
        svg(fname, width=7, height=7)
        barplot(summary(x1),
                names.arg = labels,
                cex.names=0.8, col="blue", main="Number of attempts per task")
        dev.off()
    }

ansperstudent <- function(a, tasks, labels, round, path)
    {
        ret = c()
        for (i in tasks) {
            a2 <- a[a[,3]==i,]
            ret[[i]] <- count(a2[,2])$freq
        }

        fname <- sprintf("%s/%s-studattempts.svg", path, round)
        #png(fname, width=800, height=600)
        svg(fname, width=7, height=7)
        par(cex.axis=0.8)
        boxplot(ret, log="y", main="Number of attempts per student",
                names = labels,
                col="light blue", las=1)
        dev.off()
    }

tasks.all <- function()
    {
        a <- read.answersummary("01")  # should be full filename
        tasks = c(" 142.First", " 142.Rectangle",
            " 142.Vector", " 142.StringVector",
            " 142.References", " 142.Broken", " 142.Bank")
        labels = c("First", "Rect", "Vector", "StringVec",
            "References", "Broken", "Bank")
        tasksummary(a, tasks, labels)
        ansperstudent(a, tasks, labels)

        a <- read.answersummary("02")
        tasks=c(" 174.Iterators", " 174.List",
            " 174.Matrix", " 174.Library",
            " 174.Pokemon")
        labels = c("Iterators", "List", "Matrix", "Library", "Pokemon")
        tasksummary(a, tasks, labels, "02")
        ansperstudent(a, tasks, labels, "02")
    }

timebars <- function(path, round, daylabels)
    {
        fname <- sprintf("%s/timedist-%s.csv", path, round)
        a <- read.table(fname, sep=";", header=F)
        fname <- sprintf("%s/%s-timebars.svg", path, round)
        svg(fname,width=14,height=7)
        barplot(tail(a$V2, 7*24), col="blue", main="Number of submissions per hour")
        abline(v=c(1*28.8, 2*28.8, 3*28.8, 4*28.8, 5*28.8, 6*28.8))
        axis(1, at=c(0*28.8, 1*28.8, 2*28.8, 3*28.8, 4*28.8, 5*28.8, 6*28.8, 7*28.8), labels=daylabels)
        dev.off()
    }

all.timebars <- function()
    {
        round <- "01"
        fname <- sprintf("../stats/%s-timebars.svg", round)
        svg(fname,width=14,height=7)
        timebars(round)
        dev.off()

        round <- "02"
        fname <- sprintf("../stats/%s-timebars.svg", round)
        svg(fname,width=14,height=7)
        timebars(round)
        dev.off()

    }

cpp.one <- function(round, tasks, labels, allscoresname, roundname)
    {
        p <- "/Users/psarolah/opetus/cplusplus/cpp2017/stats/"
        fb <- c()
        fb <- read.roundfb(round, fb)
        hist.feedback(round, fb)

        fname = sprintf("%s/ans-%s-all.csv", p, round)
        a <- read.answersummary(fname)
        tasksummary(a, tasks, labels, round, p)
        ansperstudent(a, tasks, labels, round, p)
        fname = sprintf("%s/%s", p, allscoresname)
        cdfpoints(fname, p, round, roundname)
        timebars(p, round,
                 c("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))
    }

cpp.all <- function()
    {
        allscoresname <- "../points/allscores-2017-10-17.csv"

        cpp.one("01", c(" 142.First", " 142.Rectangle",
                        " 142.Vector", " 142.StringVector",
                        " 142.References", " 142.Broken", " 142.Bank"),
                c("First", "Rect", "Vector", "StringVec",
                  "References", "Broken", "Bank"),
                allscoresname, "X1.basics")

        cpp.one("02", c(" 174.Iterators", " 174.List",
                        " 174.Matrix", " 174.Library",
                        " 174.Pokemon"),
                c("Iterators", "List", "Matrix", "Library", "Pokemon"),
                allscoresname, "X2.containers")

        cpp.one("03", c(" 1333.Mammals", " 1333.TrollAndDragon",
                        " 1333.Polynomial", " 1333.Bird",
                        " 1333.Register"),
                c("Mammals", "TrollAndDragon", "Polynomial",
                  "Bird", "Register"),
                allscoresname, "X3.classes")

        cpp.one("04", c(" 1410.ToString", " 1410.Triple",
                        " 1410.Dragons", " 1410.RestrictedPointer"),
                c("ToString", "Triple", "Dragons", "RestrictedPointer"),
                allscoresname, "X4.templates.and.pointers")
    }

sinkut.one <- function(round, tasks, labels, allscoresname, roundname)
    {
        p <- "/Users/psarolah/opetus/sinkut/2017/stats/"
        fname = sprintf("%s/ans-%s-all.csv", p, round)
        a <- read.answersummary(fname)
        tasksummary(a, tasks, labels, round, p)
        ansperstudent(a, tasks, labels, round, p)
        fname = sprintf("%s/%s", p, allscoresname)
        cdfpoints(fname, p, round, roundname)
        timebars(p, round,
                 c("Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue"))
    }

sinkut.all <- function()
    {
        allscoresname <- "allscores-2017-10-05.csv"

        sinkut.one("01", c(" 170.Tavoitteet", " 170.Jaksolliset_signaalit",
                           " 170.Signaalin_energia", " 170.Desibeliasteikot"),
                   c("Tavoitteet", "Jaksolliset", "Energia", "Desibeli"),
                   allscoresname,
                   "viikko.1")

        sinkut.one("02", c(" 177.Erikoissignaalit", " 177.Diskreetti_konvoluutio",
                           " 177.Konvoluutiointegraali", " 177.Konvoluutio_Octave"),
                   c("Erikoissign.", "Diskreetti konv.", "Konv.integraali", "Konv.Octave"),
                   allscoresname,
                   "viikko.2")

        sinkut.one("03", c(" 184.Sisätulo", " 184.Vektorien_ortogonaalisuus",
                           " 184.Signaalien_sisatulo", " 184.Signaalien_ortogonaalisuus",
                           " 184.Signaalin_jakso", " 184.Signaalin_teho"),
                   c("Sisätulo", "Vekt. ortog.", "Sign. sisätulo",
                     "Sign. ortog.", "Sign. jakso", "Sign. teho"),
                   allscoresname,
                   "viikko.3")
    }

c.one <- function(round, tasks, labels, allscoresname, roundname, p)
    {
        #p <- "/Users/psarolah/opetus/c-ohjelmointi/c2018/stats/"
        #p <- path
        fb <- c()
        fb <- read.roundfb(round, fb, p)
        hist.feedback(round, fb, p)

        fname = sprintf("%s/ans-%s-all.csv", p, round)
        a <- read.answersummary(fname)
        tasksummary(a, tasks, labels, round, p)
        ansperstudent(a, tasks, labels, round, p)
        fname = sprintf("%s/%s", p, allscoresname)
        cdfpoints(fname, p, round, roundname)
        timebars(p, round,
                 c("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))
    }

pointdist <- function(allscoresname, p)
    {
        #p <- "/Users/psarolah/opetus/c-ohjelmointi/c2018/stats/"
        #allscoresname <- "../points/allscores-2018-04-05.csv"
        fname = sprintf("%s/%s", p, allscoresname)
        a <- read.csv(fname, sep=";",
                      header=T, stringsAsFactors=F)

        b1 <- c()
        b2 <- c()
        b3 <- c()
        for (i in c(2:11)) {
            b3 <- c(b3, sum(as.numeric(a[[i]])>=100, na.rm=T))
            b2 <- c(b2, sum(as.numeric(a[[i]])>=50, na.rm=T))
            b1 <- c(b1, sum(as.numeric(a[[i]])>0, na.rm=T))
        }
        e <- rbind(b3, b2-b3, b1-b2)

        fname <- sprintf("%s/points-summary.svg", p)
        svg(fname, width=7, height=7)
        barplot(e, col=c("green", "yellow", "red"),
                main="Distribution of points achieved per round",
                names.arg=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "A"),
                legend.text=c("100", ">=50", ">0"),
                ylab="Num. of students", xlab="Round")
        dev.off()
    }

c.fbsummary <- function(p)
    {
        rounds <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10")
        fb <- c()
        for (i in rounds) {
            fb <- read.roundfb(i, fb, p)
        }

        diff <- c()
        learn <- c()
        for (i in rounds) {
            diff <- c(diff, mean(fb[[i]][["V2"]], na.rm = TRUE))
            learn <- c(learn, mean(fb[[i]][["V3"]], na.rm = TRUE))
        }

        hours <- c()
        for (i in rounds) {
            hours[[i]] <- fb[[i]][["V4"]]
        }
        fname <- sprintf("%s/hours-summary.svg", p, round)
        svg(fname, width=7, height=7)
        boxplot(hours, ylim=c(0,30))
        dev.off()

        fname <- sprintf("%s/feedback-summary.svg", p, round)
        svg(fname, width=7, height=7)
        plot(diff, type="o", ylim=c(2.0,4.5), col="blue")
        lines(learn, type="o", col="red", pch=2)
        legend(7,2.5, c("difficulty", "learning"), pch=c(1,2),
               col=c("blue", "red"), lty=c(1,1))
        dev.off()
    }

c.summarystats <- function(allscoresname, path)
    {
#        path <- "/Users/psarolah/opetus/c-ohjelmointi/c2018/stats/"
        c.fbsummary(path)
        pointdist(allscoresname, path)
    }

# setwd("/Users/psarolah/opetus/c-ohjelmointi/c2018/kesa/feedback")
c.all.summer18 <- function()
    {
        allscoresname <- "../points/allscores-2018-08-03-fixed.csv"

        c.summarystats(allscoresname, "/Users/psarolah/opetus/c-ohjelmointi/c2018/kesa/stats/")

        path <- "/Users/psarolah/opetus/c-ohjelmointi/c2018/kesa/stats/"

        c.one("01", c(" 4554.HelloWorld", " 4554.KorjaaLuvut",
                        " 4554.PowerThree", " 4554.FractionSum",
                        " 4554.OmaOhjelma", " 4554.Vektori"),
                c("HelloWorld", "KorjaaLuvut", "PowerThree", "FractionSum",
                  "OmaOhjelma", "Vektori"),
              allscoresname, "X1.perusteet", path)

        c.one("02", c(" 4555.Pii", " 4555.Lohkot",
                        " 4555.Laskin", " 4555.For",
                        " 4555.Kolmio", " 4555.ASCII"),
                c("Pii", "Lohkot", "Laskin", "For",
                  "Kolmio", "ASCII"),
              allscoresname, "X2.syote.ja.tuloste", path)

         c.one("03", c(" 4556.SegFault", " 4556.ReadInt",
                       " 4556.ShowTable", " 4556.Taulukkoja",
                       " 4556.CountChars", " 4556.Jarjestys"),
               c("SegFault", "ReadInt", "ShowTable", "Taulukkoja",
                 "CountChars", "Jarjestys"),
               allscoresname, "X3.osoittimet", path)

         c.one("04", c(" 4557.CountAlpha", " 4557.AddNames",
                        " 4557.CountStr", " 4557.Shout",
                        " 4557.NewString"),
                c("CountAlpha", "AddNames", "CountStr", "Shout",
                  "NewString"),
              allscoresname, "X4.merkkijonot", path)

        c.one("05", c(" 4558.Muistivuoto", " 4558.MyStrcat",
                        " 4558.DynTaulukko", " 4558.LiitaTaulukko",
                        " 4558.Koodisiistija"),
                c("Muistivuoto", "MyStrcat", "DynTaulukko", "LiitaTaulukko",
                  "Koodisiistija"),
              allscoresname, "X5.dynaaminen.muisti", path)

        c.one("06", c(" 4559.Ships", " 4559.BetterShips", " 4559.Zoo",
                        " 4559.Murtoluku", " 4559.Jono"),
                c("Ships", "BetterShips", "Zoo", "Murtoluku", "Jono"),
              allscoresname, "X6.rakenteiset.tietotyypit", path)

        c.one("07", c(" 4560.Jokudata", " 4560.StaticArr",
                        " 4560.GameOfLife", " 4560.StringArray"),
                c("Jokudata", "StaticArr", "GameOfLife", "StringArray"),
              allscoresname, "X7.moniuloitteiset.taulukot", path)

        c.one("08", c(" 4561.Heksamuunnos", " 4561.Bitti-1",
                      " 4561.Bitti-2", " 4561.Bittioperaatiot",
                      " 4561.TCP-otsake", " 4561.XOR-cipher"),
              c("Heksamuunnos", "Bitti-1", "Bitti-2", "Bittioperaatiot",
                "TCP-otsake", "XOR-cipher"),
              allscoresname, "X8.binaarioperaatiot", path)

        c.one("09", c(" 4562.Harjoittelua", " 4562.Hexdump",
                      " 4562.Tilastoja", " 4562.Shop"),
              c("Harjoittelua", "Hexdump", "Tilastoja", "Shop"),
              allscoresname, "X9.i.o.virrat", path)

#        c.one("10", c(" 1726.Makrot", " 1726.Tulostin",
#                      " 1726.Funktio-osoittimet", " 1726.Luolapeli"),
#              c("Makrot", "Tulostin", "Funktio-osoittimet", "Luolapeli"),
#              allscoresname, "a.kehittyneet.piirteet")
    }

# setwd("/Users/psarolah/opetus/c-ohjelmointi/c2018/feedback")
c.all <- function()
    {
        allscoresname <- "../points/allscores-2018-04-05.csv"

        c.summarystats(allscoresname)

        c.one("01", c(" 1692.HelloWorld", " 1692.KorjaaLuvut",
                        " 1692.PowerThree", " 1692.FractionSum",
                        " 1692.OmaOhjelma", " 1692.Vektori"),
                c("HelloWorld", "KorjaaLuvut", "PowerThree", "FractionSum",
                  "OmaOhjelma", "Vektori"),
              allscoresname, "X1.perusteet")

        c.one("02", c(" 1718.Pii", " 1718.Lohkot",
                        " 1718.Laskin", " 1718.For",
                        " 1718.Kolmio", " 1718.ASCII"),
                c("Pii", "Lohkot", "Laskin", "For",
                  "Kolmio", "ASCII"),
              allscoresname, "X2.syote.ja.tuloste")

         c.one("03", c(" 1719.SegFault", " 1719.ReadInt",
                        " 1719.ShowTable", " 1719.Taulukkoja",
                        " 1719.MasterMind", " 1719.Jarjestys"),
                c("SegFault", "ReadInt", "ShowTable", "Taulukkoja",
                  "MasterMind", "Jarjestys"),
              allscoresname, "X3.osoittimet")

        c.one("04", c(" 1720.CountAlpha", " 1720.Kekkonen",
                        " 1720.CountStr", " 1720.NewString",
                        " 1720.Korsoraattori"),
                c("CountAlpha", "Kekkonen", "CountStr", "NewString",
                  "Korsoraattori"),
              allscoresname, "X4.merkkijonot")

        c.one("05", c(" 1721.Muistivuoto", " 1721.MyStrcat",
                        " 1721.DynTaulukko", " 1721.LiitaTaulukko",
                        " 1721.Koodisiistija"),
                c("Muistivuoto", "MyStrcat", "DynTaulukko", "LiitaTaulukko",
                  "Koodisiistija"),
              allscoresname, "X5.dynaaminen.muisti")

        c.one("06", c(" 1722.Rekka", " 1722.Zoo",
                        " 1722.Murtoluku", " 1722.Jono"),
                c("Rekka", "Zoo", "Murtoluku", "Jono"),
              allscoresname, "X6.rakenteiset.tietotyypit")

        c.one("07", c(" 1723.Jokudata", " 1723.StaticArr",
                        " 1723.GameOfLife", " 1723.StringArray"),
                c("Jokudata", "StaticArr", "GameOfLife", "StringArray"),
              allscoresname, "X7.moniuloitteiset.taulukot")

        c.one("08", c(" 1724.Heksamuunnos", " 1724.Bitti-1",
                      " 1724.Bitti-2", " 1724.Bittioperaatiot",
                      " 1724.TCP-otsake", " 1724.XOR-cipher"),
              c("Heksamuunnos", "Bitti-1", "Bitti-2", "Bittioperaatiot",
                "TCP-otsake", "XOR-cipher"),
              allscoresname, "X8.binaarioperaatiot")

        c.one("09", c(" 1725.Harjoittelua", " 1725.Hexdump",
                      " 1725.Tilastoja", " 1725.Shop"),
              c("Harjoittelua", "Hexdump", "Tilastoja", "Shop"),
              allscoresname, "X9.i.o.virrat")

        c.one("10", c(" 1726.Makrot", " 1726.Tulostin",
                      " 1726.Funktio-osoittimet", " 1726.Luolapeli"),
              c("Makrot", "Tulostin", "Funktio-osoittimet", "Luolapeli"),
              allscoresname, "a.kehittyneet.piirteet")
    }

# setwd("/Users/psarolah/opetus/cplusplus/cpp2017/feedback")
# source("/Users/psarolah/opetus/c-ohjelmointi/git-tools/funcs.R")
# library(plyr)
