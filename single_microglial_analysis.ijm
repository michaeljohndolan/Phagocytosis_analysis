//Code to calculate the average phrhodo signal and area for each microglia 
run("Clear Results");

//Get Main directory 
maindir=getDirectory("Choose the parent phagocytosis directory"); 

//Make a list of all files under analysis 
list=getFileList(maindir+"PhRhodo"); 


for (i=0; i<list.length; i++) {

	//Open the microglial Ilastik segmentations and preprocess 
	open(maindir+"Microglia/SimpleSegmentation/"+list[i]);
	rename("microglia");
	run("16-bit");
	setThreshold(1, 1);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	run("Fill Holes");
	
	//Produce the ROIs for intensity analysis 
	run("ROI Manager..."); //Start up the ROI manager 
	run("Analyze Particles...", "size=200-Infinity show=Overlay add in_situ");
	saveAs("Tiff", maindir+"masks/"+list[i]);
	rename("microglia");
	close("microglia");

	//Open up the PhRhodo channel 
	open(maindir+"PhRhodo/"+list[i]); 
	rename(list[i]);

	//Import the ROIs from the microglia mask to phrhodo channel
	//set measurements and measure intensity (area done separately) 
	run("From ROI Manager");
	run("Set Measurements...", "mean display redirect=None decimal=3"); 
	roiManager("Measure");
	
	//Delete the accumulated ROIs and close the image 
	roiManager("Delete");
	close(list[i]); 
}




