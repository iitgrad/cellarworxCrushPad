//
//  CCTankLoadingController.m
//  Crush
//
//  Created by Kevin McQuown on 7/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCTankLoadingController.h"
#import "CCSCP.h"
#import "CrushHelper.h"
#import "CCWT.h"
#import "CCAssetReservation.h"
#import "CCAsset.h"

#define kGallonsPerTon 275

@implementation CCTankLoadingController
@synthesize averageBinWeightLabel;
@synthesize totalWeight;
@synthesize binCountLabel;
@synthesize tonsInVessel;
@synthesize vesselCapacity;
@synthesize vesselName;
@synthesize picker;
@synthesize scp;
@synthesize reservation;
@synthesize delegate;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
			   forSCP:(CCSCP *)theSCP 
	   andReservation:(CCAssetReservation *)theReservation
binsAlreadyAllocated:(NSUInteger)theBinsUsed
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.scp=theSCP;
		self.reservation=theReservation;
		binsUsed=theBinsUsed;
    }
    return self;
}

#pragma mark -
#pragma mark Helper Functions

-(void) setVesselCapacityLabel
{
	NSString *vc=[NSString stringWithFormat:@"%@ - %@ = %@",
				  [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[[reservation asset]capacity]],
				  [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithFloat:(binCount * averageBinWeight)*kGallonsPerTon]],
				  [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithFloat:[[[reservation asset]capacity] floatValue]-
																			 (binCount * averageBinWeight)*kGallonsPerTon]]];
	vesselCapacity.text=vc;	
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	vesselName.text=[[reservation asset] name];
	totalTons=[scp actualTons];
	totalWeight.text=[[CrushHelper numberFormatQtyWithDecimals:1] stringFromNumber:[NSNumber numberWithFloat:totalTons]];
	maxBinCount=0;
	for (CCWT *theWT in scp.weighTags)
	{
		maxBinCount+=[theWT totalBinCount];
	}
	averageBinWeight=totalTons/maxBinCount;
	maxBinCount-=binsUsed;
	binCount=[reservation binCount];
	if ([reservation binCount]==0) {
		NSUInteger numberOfBinsThatWillFitInVessel=([[[reservation asset] capacity] floatValue]/kGallonsPerTon)/averageBinWeight;
		if (numberOfBinsThatWillFitInVessel>maxBinCount) 
			binCount=maxBinCount;
		else
			binCount=numberOfBinsThatWillFitInVessel;
	}
	binCountLabel.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:binCount]];
	averageBinWeightLabel.text=[[CrushHelper numberFormatQtyWithDecimals:3] stringFromNumber:[NSNumber numberWithFloat:averageBinWeight]];

	[self setVesselCapacityLabel];
	
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[picker selectRow:binCount-1 inComponent:0 animated:YES];
	tonsInVessel.text=[[CrushHelper numberFormatQtyWithDecimals:1] stringFromNumber:[NSNumber numberWithFloat:(binCount*averageBinWeight)]];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
#pragma mark -
#pragma mark pickerView Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return maxBinCount;
}

#pragma mark -
#pragma mark pickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 80;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40;
}
 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%2d",row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	binCount=row+1;
	tonsInVessel.text=[[CrushHelper numberFormatQtyWithDecimals:1] stringFromNumber:[NSNumber numberWithFloat:binCount*averageBinWeight]];
	binCountLabel.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:row+1]];

	[self setVesselCapacityLabel];
}

#pragma mark -
#pragma mark IBActions

-(IBAction) binCountSet:(id)sender
{
	[self.delegate setBinsInVessel:binCount forReservation:reservation];
}
-(IBAction) cancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scp release];
	[reservation release];
	[picker release];
	[vesselName release];
	[averageBinWeightLabel release];
	[totalWeight release];
	[binCountLabel release];
	[tonsInVessel release];
	[vesselCapacity release];
    [super dealloc];
}


@end
