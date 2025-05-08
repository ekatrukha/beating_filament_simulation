//assumes that an image generated using 01_flexrod macro is opened,
//simulates individual volumetric acquisitions (Z-stacks) over time

//total number of scans, taken at random timepoint
//of the original movie
nTotScans = 100;

saveFolder = getDir("Choose a folder to save the data");
print(saveFolder);
//nCurrTimeFrame = 1;

Stack.getDimensions(width, height, channels, slices, frames);
origID = getImageID();
maxShift = frames - slices-1;

for(nTP = 0; nTP<nTotScans; nTP++)
{
	nCurrTimeFrame = round(1+random*(maxShift-1));
	print(nCurrTimeFrame);

	newImage("Untitled", "16-bit black",height ,slices, width);
	currT = getImageID();
	for(x=0;x<width;x++)
	{
		selectImage(origID);
		run("Select All");
		run("Duplicate...", "duplicate frames="+toString(nCurrTimeFrame));
		currZ = getImageID();
		makeLine(x, 0, x, height);
		run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
		sliceID = getImageID();
		run("Select All");
		run("Copy");
		selectImage(currT);
		setSlice(x+1);
		run("Select All");
		run("Paste");
		selectImage(sliceID);
		close();
		selectImage(currZ);
		close();
		//Stack.setFrame(nCurrTimeFrame);	
		nCurrTimeFrame++;
	}
	//nCurrTimeFrame+=4;
	selectImage(currT);
	saveAs("Tiff", saveFolder+"/volume_"+String.pad(nTP+1, 3) +".tif");
	close();
}
print("done");