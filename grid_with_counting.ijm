/* May 2021
 * Erwan Grandgirard  
 * grandgie@igbmc.fr 
*/

//Init
print("\\Clear");
run("Fresh Start");

run("Bio-Formats Macro Extensions");	//enable macro functions for Bio-formats Plugin
print("select folder with your Data")
dir1 = getDirectory("Choose a Directory");
print("Select the Save Folder")
dir2 = getDirectory("Choose a Directory");
list = getFileList(dir1);
setBatchMode(false);
// PROCESS LIF FILES
for (i = 0; i < list.length; i++) {
		processFile(list[i]);
}

/// Requires run("Bio-Formats Macro Extensions");
function processFile(fileToProcess){
	path=dir1+fileToProcess;
	Ext.setId(path);
	Ext.getCurrentFile(fileToProcess);
	Ext.getSeriesCount(seriesCount); // this gets the number of series
	print("Processing the file = " + fileToProcess);
	// see http://imagej.1557.x6.nabble.com/multiple-series-with-bioformats-importer-td5003491.html
	for (j=0; j<seriesCount; j++) {
        Ext.setSeries(j);
        Ext.getSeriesName(seriesName);
		run("Bio-Formats Importer", "open=&path color_mode=Default view=Hyperstack stack_order=XYCZT series_"+j+1); 
		fileNameWithoutExtension = File.nameWithoutExtension;
		//print(fileNameWithoutExtension);
		raw=getImageID();
		run("Z Project...", "projection=[Max Intensity]");
		image_Z_Proj="Z_Proj_"+fileNameWithoutExtension;
		//selectWindow(image_Z_Proj);
		//saveAs("tiff", dir2+image_Z_Proj);
		//rename(image_Z_Proj);
		//fileNameWithoutExtension = File.nameWithoutExtension;
		z_proj=getImageID();
		setTool("rotrect");
		selectImage(z_proj);
		makeRotatedRectangle(494, 324, 660, 510, 664);
	waitForUser("select your rectangle Area");
	roiManager("add");
	roiManager("save", dir2+"Rectangle area"+".roi");
	//run("From ROI Manager");
	//image_with_rectangle="Area_"+fileNameWithoutExtension;
	//selectWindow(image_with_rectangle);
	//saveAs("tiff", dir2+image_with_rectangle);
	//run("Hide Overlay");
	roiManager("Select", 0);		
	run("Duplicate...", "title=Area duplicate");
	run("Tile");
	roiManager("reset");
	selectWindow("Area");
	getDimensions(width, height, channels, slices, frames);
	wait(200);
		if(width<height){
			run("Rotate 90 Degrees Right");
		}
	
	Dialog.create("column");
	Dialog.addNumber("numbers of sectors", 10);
	Dialog.show();
	nb = Dialog.getNumber();
	W = getWidth();
	H =getHeight();
	bounding= (W/nb);
	bounding=round(bounding);
	selectWindow("Area");
	Stack.setChannel(2);
		for (i = 0;  i< nb; i++) {
			makeRectangle(i*bounding,0 , bounding, H);
		roiManager("add");
		}
	roiManager("show all");
	run("Set... ", "zoom=200");
	run("Enhance Contrast", "saturated=0.35");
	Table.create("Result/Roi");
	
	n = roiManager('count');
		for (i = 0; i < n; i++) {
    	roiManager('select', i);
    	run("Find Maxima...", "prominence=10 output=[Point Selection]");
    	roiManager("add");
    	wait(100);
    	roiManager("select", n);
    	setTool("multipoint");
    	waitForUser("ROI", "Atl+clic = delete");
    	roiManager("save selected", dir2+"roi"+i+".roi");
    	roiManager("select", n);
    	run("Measure");
    	n_roi=nResults;
    	Table.set("Roi"+i, i, n_roi);
    	roiManager("select", n);
    	roiManager("delete");
    	run("Clear Results");
    	
    	}
    
	}
}	


