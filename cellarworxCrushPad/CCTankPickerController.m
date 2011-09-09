//
//  TankPicker.m
//  Crush
//
//  Created by Kevin McQuown on 7/7/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCTankPickerController.h"
#import "CCAsset.h"
#import "CrushHelper.h"

@implementation CCTankPickerController

@synthesize	nameLabel;
@synthesize capacityLabel;
@synthesize capacityByTonsLabel;
@synthesize capacityByBBLSLabel;
@synthesize locationLabel;
@synthesize descriptionLabel;
@synthesize ownerLabel;
@synthesize chosenButton;

@synthesize picker;
@synthesize segmentedControl;
@synthesize tankAssets;
@synthesize tbinAssets;
@synthesize portaAssets;
@synthesize workOrder;
@synthesize column1,column2;
@synthesize byCapacity;
@synthesize delegate;

-(void) sortAssets:(NSMutableArray *)theAssets
{
/*	[theAssets sortUsingComparator:^(id left, id right) {
        CCAsset *leftAsset=(CCAsset *)left;
        CCAsset *rightAsset=(CCAsset *)right;
        
        NSArray *leftVesselNameComponents=[[leftAsset name] componentsSeparatedByString:@"-"];
        NSUInteger leftVesselNumber=[[leftVesselNameComponents objectAtIndex:1] intValue];
        NSArray *rightVesselNameComponents=[[rightAsset name] componentsSeparatedByString:@"-"];
        NSUInteger rightVesselNumber=[[rightVesselNameComponents objectAtIndex:1] intValue];
        if (leftVesselNumber<rightVesselNumber) return NSOrderedAscending;
		if (leftVesselNumber==rightVesselNumber) return NSOrderedSame;
        return NSOrderedDescending;
    }];	
 */
}
-(id) initWithWO:(CCWorkOrder *)wo
{
	self=[super initWithNibName:@"TankPickerController" bundle:nil];
	self.workOrder=wo;
	tankAssets=[[NSMutableArray alloc] init];
	tbinAssets=[[NSMutableArray alloc] init];
	portaAssets=[[NSMutableArray alloc] init];

	return self;
}
-(void)updateLowerPanelValues:(int)newRow
{
	int row;
	if (newRow<0)
		row=0;
	else 
	    row=[picker selectedRowInComponent:1];
	nameLabel.text=[[column2 objectAtIndex:row] name];
	capacityLabel.text=[NSString stringWithFormat:@"%d",[[[column2 objectAtIndex:row] capacity] intValue]];
	capacityByTonsLabel.text=[NSString stringWithFormat:@"%2.1f",[[[column2 objectAtIndex:row] capacity] intValue]/160.0];
	capacityByBBLSLabel.text=[NSString stringWithFormat:@"%d",[[[column2 objectAtIndex:row] capacity] intValue]/60];
	ownerLabel.text=[[column2 objectAtIndex:row] owner];
	descriptionLabel.text=[[column2 objectAtIndex:row] desc];
	locationLabel.text=[[column2 objectAtIndex:row] location];
}

-(void)buildPickerWithRange:(int)range andWithModifier:(int)modifer
{
	int maxIndexAdded=-1;
	float theRange=range/modifer;
	NSArray *theAssets;
	switch (assetTypeShowing) {
		case 0:
			theAssets=tankAssets;
			break;
		case 1:
			theAssets=tbinAssets;
			break;
		case 2:
			theAssets=portaAssets;
			break;
		default:
			break;
	}
	for (CCAsset *a in theAssets)
	{
		int index=(int)(([a.capacity floatValue]/modifer) / theRange);
		if (index>maxIndexAdded)
		{
			maxIndexAdded=index;
			NSString *range=[[NSString alloc] initWithFormat:@"%d - %d",index*(int)theRange,index*(int)theRange+(int)theRange];
			NSMutableArray *tanks=[[NSMutableArray alloc] init];
			[tanks addObject:a];
			NSDictionary *result=[[NSDictionary alloc] initWithObjectsAndKeys:range,@"range",tanks,@"tanks",nil];
			[column1 addObject:result];		
			[result release]; 
			[tanks release];
			[range release];
		}
		else {
			[[[column1 objectAtIndex:[column1 count]-1] objectForKey:@"tanks"] addObject:a];
		}
		
	}
	[column2 addObjectsFromArray:[[column1 objectAtIndex:0] objectForKey:@"tanks"]];
	[picker selectRow:0 inComponent:0 animated:YES];
	[picker selectRow:0 inComponent:1 animated:YES];
	[picker reloadAllComponents];	
	[self updateLowerPanelValues:0];
}

-(void)segmentTouched
{
	[column1 removeAllObjects];
	[column2 removeAllObjects];
	NSNumber *num=[[NSNumber alloc] initWithInt:[segmentedControl selectedSegmentIndex]];
	[[NSUserDefaults standardUserDefaults] setObject:num forKey:@"tankPickerLastSegmentPicked"];
	
	switch ([segmentedControl selectedSegmentIndex]) {
		case 0:
			[self buildPickerWithRange:500 andWithModifier:1];
			break;
		case 1:
			[self buildPickerWithRange:500 andWithModifier:147];
			break;
		case 2:
			[self buildPickerWithRange:500 andWithModifier:60];
			break;
			
		default:
			break;
	}
	[num release];
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
		{
			UIBarButtonItem *assetTypeButton=[[UIBarButtonItem alloc] initWithTitle:@"Tanks" style:UIBarButtonItemStyleBordered target:self action:@selector(changeAssetType)];
			self.navigationItem.rightBarButtonItem=assetTypeButton;			
			[assetTypeButton release];
		}
			break;
		case 1:
		{
			UIBarButtonItem *assetTypeButton=[[UIBarButtonItem alloc] initWithTitle:@"T-Bins" style:UIBarButtonItemStyleBordered target:self action:@selector(changeAssetType)];
			self.navigationItem.rightBarButtonItem=assetTypeButton;			
			[assetTypeButton release];
		}
			break;
		case 2:
		{
			UIBarButtonItem *assetTypeButton=[[UIBarButtonItem alloc] initWithTitle:@"Porta" style:UIBarButtonItemStyleBordered target:self action:@selector(changeAssetType)];
			self.navigationItem.rightBarButtonItem=assetTypeButton;			
			[assetTypeButton release];
		}
			break;
		default:
			break;
	}

	assetTypeShowing=buttonIndex;
	
	[self segmentTouched];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component==0)
	{
		[column2 removeAllObjects];
		[column2 addObjectsFromArray:[[column1 objectAtIndex:row] objectForKey:@"tanks"]];
		[picker selectRow:0 inComponent:1 animated:YES];
		[picker reloadComponent:1];		
		[self updateLowerPanelValues:-1];
	}
	else {
		[self updateLowerPanelValues:0];
	}

}

-(void) changeAssetType
{
	UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Choose Asset Type" delegate:self cancelButtonTitle:@"No Change" destructiveButtonTitle:nil otherButtonTitles:@"Tanks",@"TBins",@"Porta Tanks",nil];
	[sheet showInView:self.tabBarController.view];
	[sheet release];
}

-(void) viewDidLoad
{
	UIBarButtonItem *assetTypeButton=[[UIBarButtonItem alloc] initWithTitle:@"Tanks" style:UIBarButtonItemStyleBordered target:self action:@selector(changeAssetType)];
	self.navigationItem.rightBarButtonItem=assetTypeButton;
	[assetTypeButton release];
	
	UIImage *buttonImageNormal=[UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal=[buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[chosenButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImagePressed=[UIImage imageNamed:@"blueButton.png"];
	UIImage *stretchableButtonImagePressed=[buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[chosenButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];

	NSArray *buttonNames=[[NSArray alloc] initWithObjects:@"Gallons",@"Tons",@"Barrels",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
	[segmentedControl setEnabled:YES forSegmentAtIndex:0];
	segmentedControl.momentary=NO;
	segmentedControl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
	@try {
		segmentedControl.selectedSegmentIndex=[[[NSUserDefaults standardUserDefaults] objectForKey:@"tankPickerLastSegmentPicked"] intValue];
	}
	@catch (NSException * e) {
		segmentedControl.selectedSegmentIndex=0;
	}
	[segmentedControl addTarget:self action:@selector(segmentTouched) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView=segmentedControl;
	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *theAssets=[CrushHelper fetchAssetList];
//		dispatch_async(dispatch_get_main_queue(),^{
			for (NSDictionary *a in theAssets)
			{
				CCAsset *asset=[[CCAsset alloc] initWithDictionary:a];
				NSArray *assetNameComponents=[[asset name] componentsSeparatedByString:@"-"];
				NSString *assetName=[assetNameComponents objectAtIndex:0];
				if ([assetName isEqualToString:@"TANK"]) {
					[tankAssets addObject:asset];
				}
				else if ([assetName isEqualToString:@"TBIN"]) {
					[tbinAssets addObject:asset];
				}
				else if ([assetName isEqualToString:@"PORTA"]) {
					[portaAssets addObject:asset];
				}
				[asset release];
			}
			
			[self sortAssets:tankAssets];
			[self sortAssets:tbinAssets];
			[self sortAssets:portaAssets];
			
			assetTypeShowing=0;
			
			self.column1=[[NSMutableArray alloc] init];
			self.column2=[[NSMutableArray alloc] init];
			
			[self segmentTouched];			
//		});
//	});
	
}
-(void)viewWillAppear:(BOOL) animated
{
	[super viewWillAppear:animated];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
	return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return [column1 count];
			break;
		case 1:
			return [column2 count];
			break;
		default:
			break;
	}
	return 0;
}

// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return 145;
			break;
		case 1:
			return 155;
			break;
		default:
			break;
	}
	return 0;
}

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return [[column1 objectAtIndex:row] objectForKey:@"range"];
			break;
		case 1:
		{
			return [NSString stringWithFormat:@"%@",[[column2 objectAtIndex:row] name]];
		}
			break;
		default:
			break;
	}
	return @"";
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
// returns the number of 'columns' to display.


-(void)tankPicked
{
	[self.delegate AssetChosen:[column2 objectAtIndex:[picker selectedRowInComponent:1]]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [picker release];
    [tankAssets release];
	[tbinAssets release];
	[portaAssets release];
    [nameLabel release];
    [capacityLabel release];
    [capacityByTonsLabel release];
    [capacityByBBLSLabel release];
    [locationLabel release];
    [descriptionLabel release];
    [ownerLabel release];
    [chosenButton release];
    [byCapacity release];
    [column1 release];
    [column2 release];
    [workOrder release];
    [segmentedControl release];
    [super dealloc];
}


@end
