//
//  CCSCPColorPickerController.m
//  Crush
//
//  Created by Kevin McQuown on 7/21/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSCPColorPickerController.h"
#import "CrushHelper.h"

@implementation CCSCPColorPickerController
@synthesize colorPicker;
@synthesize colorCount;
@synthesize delegate;
@synthesize color1, color2;

#pragma mark -
#pragma mark Helper functions

-(NSUInteger) getRowFromColor:(UIColor *)theColor
{
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"RED"]) return 0;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"BLUE"]) return 1;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"PURPLE"]) return 2;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"ORANGE"]) return 3;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"GREEN"]) return 4;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"BROWN"]) return 5;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"YELLOW"]) return 6;
	if ([[CrushHelper getColorStringFromColor:theColor] isEqualToString:@"WHITE"]) return 7;
	return 0;
}

-(UIColor *)getColorFromComponent:(int)component
{
	switch ([colorPicker selectedRowInComponent:component]) {
		case 0:
			return [UIColor redColor];
			break;
		case 1:
			return [UIColor blueColor];
			break;
		case 2:
			return [UIColor purpleColor];
			break;
		case 3:
			return [UIColor orangeColor];
			break;
		case 4:
			return [UIColor greenColor];
			break;
		case 5:
			return [UIColor brownColor];
			break;
		case 6:
			return [UIColor yellowColor];
			break;
		case 7:
			return [UIColor whiteColor];
			break;
		default:
			break;
	}
	return [UIColor grayColor];
}

#pragma mark -
#pragma mark View lifecylce

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setColor1:(UIColor *)theColor1 setColor2:(UIColor *)theColor2 {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.color1=theColor1;
		self.color2=theColor2;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (color2!=nil)
		[colorCount setSelectedSegmentIndex:1];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (color2==nil)
	{
		[colorPicker selectRow:[self getRowFromColor:color1] inComponent:0 animated:YES];
		[colorCount setSelectedSegmentIndex:0];		
	}
	else 
	{
		[colorPicker selectRow:[self getRowFromColor:color2] inComponent:1 animated:YES];
		[colorCount setSelectedSegmentIndex:1];		
	}	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(UIColor *)color1
{
	return [self getColorFromComponent:0];
}

-(UIColor *)color2
{
	if ([colorCount selectedSegmentIndex]==1) {
		return [self getColorFromComponent:1];
	}
	return nil;
}

#pragma mark -
#pragma mark button methods
-(void) cancel:(id)sender
{
	[self.delegate cancelled:self];
}
-(void) submit:(id)sender
{
	[self.delegate colorsChosen:self];
}
-(IBAction) segmentChanged:(id)sender
{
	[colorPicker reloadAllComponents];
}

#pragma mark -
#pragma mark pickerview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	switch ([colorCount selectedSegmentIndex]) {
		case 0:
			return 1;
			break;
		case 1:
			return 2;
			break;
		default:
			break;
	}
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 8;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	switch ([colorCount selectedSegmentIndex]) {
		case 0:
			return 300;
			break;
		case 1:
			return 150;
			break;
		default:
			break;
	}
	return 300;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[self.colorPicker selectRow:row inComponent:component animated:YES];
}
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UIView *theView=view;
	if (theView==nil) {
		theView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, [self pickerView:colorPicker widthForComponent:component] , 40)] autorelease];
	}
	switch (row) {
		case 0:
			[theView setBackgroundColor:[UIColor redColor]];
			break;
		case 1:
			[theView setBackgroundColor:[UIColor blueColor]];
			break;
		case 2:
			[theView setBackgroundColor:[UIColor purpleColor]];
			break;
		case 3:
			[theView setBackgroundColor:[UIColor orangeColor]];
			break;
		case 4:
			[theView setBackgroundColor:[UIColor greenColor]];
			break;
		case 5:
			[theView setBackgroundColor:[UIColor brownColor]];
			break;
		case 6:
			[theView setBackgroundColor:[UIColor yellowColor]];
			break;
		case 7:
			[theView setBackgroundColor:[UIColor whiteColor]];
			break;
		default:
			break;
	}
	return theView;
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
	[color1 release];
	[color2	release];
	[colorPicker release];
    [super dealloc];
}


@end
