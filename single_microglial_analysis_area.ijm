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
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Erode");
	run("Dilate");
	run("Fill Holes");
	
	//Produce the ROIs for intensity analysis 
	run("ROI Manager..."); //Start up the ROI manager 
	run("Analyze Particles...", "size=500-Infinity show=Overlay add in_situ");
	close("microglia");

	//Open up the PhRhodo channel 
	open(maindir+"PhRhodo/"+list[i]);
	setThreshold(6500, 65535);
	run("Create Mask");
	rename(list[i]);
	 
	//Import the ROIs from the microglia mask to phrhodo channel
	//set measurements and measure intensity (area done separately) 
	run("From ROI Manager");
	run("Set Measurements...", "area area_fraction display redirect=None decimal=3"); 
	roiManager("Measure");

	//Delete the accumulated ROIs and close the image 
	roiManager("Delete");
	close(list[i]); 
}


