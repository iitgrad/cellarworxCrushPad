//
//  NumberPickerController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/16/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "NumberPickerController.h"


@implementation NumberPickerController
@synthesize myPicker;
@synthesize delegate;
@synthesize fieldName;
@synthesize theFormat;
@synthesize stringFormat;
@synthesize chosenButton;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(id) initWithInitialValue:(float)initValue useIncrement:(float)inc  beginningValue:(float)bv endingValue:(float)ev forField:(NSString *)fn withFormat:(NSString *)format widthOfPicker:(NSUInteger)thePickerWidth
{
	start=bv;
	increment=inc;
	end=ev;
	currentValue=initValue;
	fieldName=[[NSString alloc] initWithString:fn];
	stringFormat=format;
	pickerWidth=thePickerWidth;
	return self;
}

-(void) setPressed
{
	float theValue=[self.myPicker selectedRowInComponent:0]*increment+start;
	[self.delegate NumberPicked:self withValue:theValue forField:fieldName];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
//	UIImage *buttonImageNormal=[UIImage imageNamed:@"blueButton.png"];
//	UIImage *stretchableButtonImageNormal=[buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//	[chosenButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
//	
//	UIImage *buttonImagePressed=[UIImage imageNamed:@"whiteButton.png"];
//	UIImage *stretchableButtonImagePressed=[buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//	[chosenButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
		
	NSInteger curIndex=(NSInteger)((currentValue-start)/increment);
	[self.myPicker selectRow:curIndex inComponent:0 animated:YES];
    [super viewDidLoad];
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return (NSInteger)(((end+increment) - start) / increment);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return pickerWidth;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	float val = row*increment+start;
	NSString *theString=[[[NSString alloc] initWithFormat:stringFormat,val] autorelease];
	return theString;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [myPicker release];
    [fieldName release];
    [stringFormat release];
    [chosenButton release];
    [theFormat release];
    
    [super dealloc];
}


@end
