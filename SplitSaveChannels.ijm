//Code to extract the microglia channel and save it separately for Ilastik processing 

//Get Input directory 
maindir=getDirectory("Choose the parent phagocytosis directory"); 
RawDir=maindir+"RawData/";
list=getFileList(RawDir);

//Open each image and extract the channels 
for (i=0; i<list.length; i++) {
	open(RawDir+"/"+list[i]); //Open each individual simple segmentation 
	run("Split Channels");

	names= getList("image.titles");
	for(j=0;j<names.length;j++){ 
		
		if(startsWith(names[j],"C2" )) {
					selectWindow(names[j]);
					saveAs("Tiff", maindir+"Microglia/"+list[i]);
					print(maindir+"Microglia/"+list[i]);
					close();
					}
		if(startsWith(names[j],"C1" )) {
					selectWindow(names[j]);
					saveAs("Tiff", maindir+"PhRhodo/"+list[i]);
					print(maindir+"PhRhodo/"+list[i]);
					close();
					}
	}
}