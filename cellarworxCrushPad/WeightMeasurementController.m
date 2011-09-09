//
//  WeightMeasurementController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/29/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "WeightMeasurementController.h"
#import "NumberPickerController.h"
#import "TextFieldController.h"
#import "CCWeight.h"
#import "CrushHelper.h"
#import "cellarworxAppDelegate.h"

@implementation WeightMeasurementController
@synthesize weightMeasurementTable;
@synthesize measurement;
@synthesize controllers;
@synthesize delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
			 withData:(CCWeight *)measurementData
  ofMeasurementNumber:(NSUInteger)num
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.measurement=measurementData;
		measurementNumber=num;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) 
		return 3;
	else 
		return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section==0)
	{
		NSString *cellFormatName=@"TheCell";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellFormatName];
		if (cell == nil)
		{
			cell=[[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellFormatName] autorelease];
		}
		
		switch (indexPath.row) {
			case 0:
			{
				cell.textLabel.text=@"Bin Count";
				cell.detailTextLabel.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[measurement bincount]]];
//				cell.detailTextLabel.text=[NSString stringWithFormat:@"%2.0f",[measurement bincount]];
				break;
			}
			case 1:
			{
				cell.textLabel.text=@"Tare";
				cell.detailTextLabel.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[measurement tare]]];
				break;
			}
			case 2:
			{
				cell.textLabel.text=@"Weight";
				cell.detailTextLabel.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[measurement weight]]];
				break;
			}
			default:
				break;
		}
		return cell;		
	}
	else {
		NSString *cellFormatName=@"TheCell";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellFormatName];
		if (cell == nil)
		{
			cell=[[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellFormatName] autorelease];
		}
		cell.textLabel.text=@"Comment:";
		cell.detailTextLabel.text= [[measurement misc] description];
		return cell;
	}

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.weightMeasurementTable deselectRowAtIndexPath:indexPath animated:YES];

	if (![ap staff])
		return;
	
	if (indexPath.section==0)
	{
		switch (indexPath.row) {
			case 0:
			{			
				NumberPickerController *binCount=[[NumberPickerController alloc] initWithInitialValue:[measurement bincount] 
																						 useIncrement:1.0
																					   beginningValue:1.0
																						  endingValue:20.0
																							 forField:@"bincount"
																						   withFormat:@"%1.0f bins"
																						  widthOfPicker:80];
				binCount.delegate=self;
				[self.navigationController pushViewController:binCount animated:YES];
				[binCount release];
				break;
			}
			case 1:
			{
				WeightController *tareValue=[[WeightController alloc] initWithNibName:@"WeightController" 
																			   bundle:nil 
																	  withInitialText:[NSString stringWithFormat:@"%d",[measurement tare]]
																			 forField:@"Tare:"
																		 keyBoardType:UIKeyboardTypeNumberPad];
				tareValue.delegate=self;
				[self.navigationController pushViewController:tareValue animated:YES];
				[tareValue release];
				break;
			}
			case 2:
			{
				WeightController *tareValue=[[WeightController alloc] initWithNibName:@"WeightController" 
																			   bundle:nil 
																	  withInitialText:[NSString stringWithFormat:@"%d",[measurement weight]]
																			 forField:@"Weight:"
																		 keyBoardType:UIKeyboardTypeNumberPad];
				tareValue.delegate=self;
				[self.navigationController pushViewController:tareValue animated:YES];
				[tareValue release];
				break;
			}
			default:
				break;
		}		
	}
	else {
		TextFieldController *controller=[[TextFieldController alloc] initWithNibName:@"TextFieldController" bundle:nil withInitialText:[[measurement misc] description] forField:@"Misc:" keyBoardType:UIKeyboardTypeDefault];
		controller.delegate=self;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}

}

//-(void) SaveMeasurement
//{
//	self.navigationItem.rightBarButtonItem=nil;
//	[self.measurement save];
//	[self.navigationController popViewControllerAnimated:YES];
//}

-(void) TextEntered:(WeightController *)controller forField:(NSString *)fn
{
	if ([fn isEqualToString:@"Tare:"])
		measurement.tare=[controller.theTextField.text intValue];
	if ([fn isEqualToString:@"Weight:"])
		measurement.weight=[controller.theTextField.text intValue];
	if ([fn isEqualToString:@"Misc:"])
		self.measurement.misc=controller.theTextField.text;
	[self.measurement save];
	[self.navigationController popViewControllerAnimated:YES];
	[self.weightMeasurementTable reloadData];

}
		
-(void) NumberPicked:(NumberPickerController *)thePicker withValue:(float)value forField:(NSString *)fieldName
{
	if ([fieldName isEqualToString:@"bincount"])
	{
		measurement.bincount=value;
	}
	[self.measurement save];
	[self.navigationController popViewControllerAnimated:YES];
	[self.weightMeasurementTable reloadData];

}

-(void)addNewMeasurement
{
	[self.delegate updateWeighMeasurement:self.measurement ofMeasurementNumber:measurementNumber];
}

- (void)viewDidLoad
{
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMeasurement)];
	self.navigationItem.rightBarButtonItem=addButton;
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
    [weightMeasurementTable release];
    [measurement release];
    [controllers release];
    [super dealloc];
}


@end
