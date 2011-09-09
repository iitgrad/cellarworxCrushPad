//
//  DatePickerController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/16/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "DatePickerController.h"


@implementation DatePickerController
@synthesize datePicker;
@synthesize delegate;
@synthesize currentDate;
@synthesize chosen;
@synthesize segment;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(id) initWithDate:(NSDate *)theDate{
	
	self.currentDate=[[NSDate alloc] initWithDate:theDate];
	return self;
}

-(void) dateSet
{
	[self.delegate datePicked:self];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self.datePicker setDate:currentDate animated:YES];
	
	UIImage *buttonImageNormal=[UIImage imageNamed:@"blueButton.png"];
	UIImage *stretchableButtonImageNormal=[buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[chosen setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImagePressed=[UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImagePressed=[buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[chosen setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	
	NSArray *buttonNames=[[NSArray alloc] initWithObjects:@"Dates",@"DateTime",@"Times",nil];
	segment = [[UISegmentedControl alloc] initWithItems:buttonNames];
	[buttonNames release];
	[segment setEnabled:YES forSegmentAtIndex:1];
	segment.momentary=NO;
	segment.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	segment.segmentedControlStyle=UISegmentedControlStyleBar;
	segment.selectedSegmentIndex=1;
	self.navigationItem.titleView=segment;

	[segment addTarget:self action:@selector(segmentTouched:) forControlEvents:UIControlEventValueChanged];

    [super viewDidLoad];
}

-(void) segmentTouched:(id) sender
{
	switch ([sender selectedSegmentIndex])
	{
		case 0:
			[datePicker setDatePickerMode:UIDatePickerModeDate];
			break;
		case 1:
			[datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
			break;
		case 2:
			[datePicker setDatePickerMode:UIDatePickerModeTime];
			break;
	}
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
    [datePicker release];
    [segment release];
    [currentDate release];
    [chosen release];
    [super dealloc];
}


@end
