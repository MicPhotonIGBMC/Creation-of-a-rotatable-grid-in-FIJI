/* May 2021
 * Erwan Grandgirard  
 * grandgie@igbmc.fr 
*/

//Init
roiManager("reset");

setTool("rotrect");
makeRotatedRectangle(100, 100,200, 200, 100);
waitForUser("select your rectangle Area");

run("Duplicate...", "title=Area");
Dialog.create("column");
Dialog.addNumber("numbers of sectors", 10);
Dialog.show();
nb = Dialog.getNumber();
W = getWidth();
H =getHeight();
bounding= (W/nb);
bounding=round(bounding);
selectWindow("Area");
for (i = 0;  i< nb; i++) {
	
	makeRectangle(i*bounding,0 , bounding, H);
	roiManager("add");
}
roiManager("show all");