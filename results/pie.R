

anno = read.table("peaks_repr_filtered_annotations.txt", sep="\t", header=T, quote="")
pietable = table(unlist(lapply(strsplit(as.character(anno$Annotation), " \\("),"[[",1))) #take the part before first ' ('
pie(pietable, main="mypeaks annotation")

newtable = table(c("3' UTR","5' UTR","exon","Intergenic","intron","promoter-TSS","TTS"))
newtable[names(newtable)] = 0 #reset everything to 0
newtable[names(pietable)] = pietable
pie(newtable, main="mypeaks annotation")

names(newtable) = paste(names(newtable), "(", round(newtable/sum(newtable)*100), "%, ", newtable, ")", sep="")
pie(newtable, main="mypeaks annotation")

#use colors() to see all possible colors
#rainbow(7) looks ugly
pie(newtable, main="mypeaks annotation", col=rainbow(9))

dev.copy(png, "mypeaks.png", width=800, height=600);dev.off()