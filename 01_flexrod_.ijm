//macro generating undulating filament in 3D
//(in XY plane)

//FILAMENT
//length of a segment between nodes, in pixels
nSegmL = 2;
//total number of nodes in the filament
nNodes  = 40;

//period of filament undulation (in frames)
nPeriod = 34;
//degree of filament undulation, larger values correspond to more twitching 
flexRig = 0.04;
//INTENSITY
//final max brighness of the filament (approximately) 
nSignal = 600;
//constant background
nBG = 100;
//SD of noise
nNoise = 12;

//total number of timepoints in the generated data
nTimePoints  = 1024;
//number of z-slices
Zslices = 11;
//width height of the output
outW = 140;
outH = 100;

//Position of the filament's static end
xPos = 20;
yPos = 50;
zPos = round(Zslices*0.5);

//Final gaussian blurring SD in each axis (in pixels)
blurSDX = 2.0;
blurSDY = 2.0;
blurSDZ = 2.0;


newImage("HyperStack", "32-bit grayscale-mode", outW, outH, 1, Zslices, nTimePoints);
//newImage("Untitled", "16-bit black", 100, 100, nTimePoints);
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
//run("Fill", "slice");
xpoints = newArray(nNodes);
ypoints = newArray(nNodes);

xpoints[0] = xPos;
ypoints[0] = yPos;


for(t=1;t<nTimePoints+1;t++)
{
	Stack.setFrame(t);
	Stack.setSlice(zPos);
	//setSlice(t);
	currAngle = 0.0;

	for (i = 1; i < nNodes; i++)
	{
		dAngle = flexRig*Math.sin(i*PI/(nNodes)+2*PI*t/nPeriod);	
		
		currAngle += dAngle;
		
		dx = nSegmL*Math.cos(currAngle);
		dy = nSegmL *Math.sin(currAngle);
		//print(currAngle, " ", dx, " ", dy);
		xpoints[i] = xpoints[i-1] + dx;
		ypoints[i] = ypoints[i-1] + dy;
	}
	
	makeSelection("polyline", xpoints, ypoints);
	run("Fill", "slice");
}
run("Gaussian Blur 3D...", "x="+toString(blurSDX)+" y="+toString(blurSDY)+" z="+toString(blurSDZ));
nSignScale = nSignal/0.04;
run("Multiply...", "value="+toString(nSignScale)+" stack");
setMinAndMax(0, 65500);
run("Add...", "value="+toString(nBG)+" stack");
run("16-bit");
run("Add Specified Noise...", "stack standard="+toString(nNoise));