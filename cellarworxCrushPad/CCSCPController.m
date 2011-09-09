//
//  CCSCOController.m
//  Crush
//
//  Created by Kevin McQuown on 6/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCSCPController.h"
#import "CCBinController.h"
#import "CCSCP.h"
#import "NumberPickerController.h"
//#import "WOFieldsCell.h"
#import "DescriptionCell.h"
//#import "CCWTController.h"
#import "CCSCP.h"
#import "CCAsset.h"
#import "CCTankListController.h"
#import "CCWT.h"
#import "CCLot.h"
#import "CCSortingTableActivity.h"
#import "CCSortingTable.h"
#import "CCActivity.h"
#import "CCAssetReservation.h"
//#import "CCWOListController.h"
#import "WOPickerController.h"
#import "cellarworxAppDelegate.h"

@implementation CCSCPController
@synthesize scp;
@synthesize titleArea;
@synthesize colorView1;
@synthesize colorView2;
@synthesize currentPopOverController;
@synthesize popOverIndexPath;

-(id) initWithSCP:(CCSCP *)theSCP
{
	self=[super initWithStyle:UITableViewStyleGrouped];		
	self.scp=theSCP;
	pushOnSave=NO;
	return self;
}

-(void) addCreateWTButton
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];	

	if ([ap staff])
	{
		if (self.navigationItem.rightBarButtonItem==nil)
		{
			if ([[scp estTons] intValue]>0) {
				UIBarButtonItem *addButton=[[UIBarButtonItem alloc] initWithTitle:@"Create WT" 
																			style:UIBarButtonItemStylePlain 
																		   target:self 
																		   action:@selector(createWT)];
				[self.navigationItem setRightBarButtonItem:addButton];	
				[addButton release];
			}
		}		
	}		
}

#pragma mark -
#pragma mark lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];	
	[self addCreateWTButton];
	[self.tableView reloadData];
}	

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[CrushHelper setDefaultClientAndVintageFromWO:self.scp];
	
	titleArea=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	[titleArea setUserInteractionEnabled:YES];
	[titleArea setShadowColor:[UIColor blackColor]];
	[titleArea setShadowOffset:CGSizeMake(0, -1)];
	[titleArea setFont:[UIFont boldSystemFontOfSize:18.0]];
	[titleArea setTextAlignment:UITextAlignmentCenter];
	[titleArea setTextColor:[UIColor colorWithWhite:1 alpha:1]];
	[titleArea setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
	titleArea.text=[NSString stringWithFormat:@"SCP: %@",scp.theID];
	self.navigationItem.titleView=titleArea;
	
	UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
	[self.navigationItem.titleView setGestureRecognizers:[NSArray arrayWithObject:tap]];
	[tap release];
		
}
#pragma mark -
#pragma mark gesture recognition

-(void)headerTapped:(UITapGestureRecognizer *)gesture
{
	if (gesture.state==UIGestureRecognizerStateEnded) {
		UIActionSheet *choices=[[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Page Winemaker to Scale",@"Page Winemaker to Sorting",@"Assign SCP to Sorting Line",nil];
		[choices showInView:self.tabBarController.view];
		[choices release];
	}
}

-(void)colorsTapped:(UITapGestureRecognizer *)gesture
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (gesture.state==UIGestureRecognizerStateEnded) {
		if ([ap staff])
		{
			CCSCPColorPickerController *controller=[[CCSCPColorPickerController alloc] 
													initWithNibName:@"CCSCPColorPickerController" 
													bundle:nil
													setColor1:scp.color1
													setColor2:scp.color2];
            [controller setContentSizeForViewInPopover:CGSizeMake(320, 360)];
			controller.delegate=self;
            currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:controller];
            [controller release];
            CGRect theRect=CGRectMake(colorView1.frame.origin.x, colorView1.frame.origin.y, colorView1.bounds.size.width*2, colorView1.bounds.size.height);
            [currentPopOverController presentPopoverFromRect:theRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}	
}
#pragma mark - 
#pragma mark - popOver routines
-(CGRect) CGRectFromIndexPath:(NSIndexPath *)indexPath withOffset:(int)offset
{
    CGRect theRect=[self.tableView rectForRowAtIndexPath:indexPath];
    return CGRectMake(theRect.size.width-offset, theRect.origin.y, 200, [self tableView:self.tableView heightForRowAtIndexPath:indexPath]);
}
                
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:popOverIndexPath] withRowAnimation:UITableViewRowAnimationFade];  
}
#pragma mark -
#pragma mark Network activity
-(void) saveSCP
{
	UIBarButtonItem *savingBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Saving..." style:UIBarButtonItemStyleBordered target:self action:nil];
	self.navigationItem.rightBarButtonItem=savingBarButtonItem;
	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[scp saveWithPushNotification:pushOnSave];
//		dispatch_async(dispatch_get_main_queue(), ^{
			titleArea.text=[NSString stringWithFormat:@"SCP: %@",scp.theID];
			self.navigationItem.rightBarButtonItem=nil;
//			[self addCreateWTButton];
//		});
//	});
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([ap staff])
		return 4;
	else 
		return 3;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	switch (indexPath.section) {
		case 2:
		{
			NSString *desc=[CrushHelper blankIfNull:scp.specialInstructions];
			UIFont *font=[UIFont fontWithName:@"Helvetica" size:kDescriptionFontSize];
			CGSize withinSize=CGSizeMake(320 ,1000);
			CGSize size=[desc sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
			return size.height+45;			
		}
		default:
			return 45;
			break;
	}
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 7;
			break;
		case 1:
            return 4;
		case 2:
			return 1;
		case 3:
			return 2;
			break;

		default:
			break;
	}
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section==0)
		return 50;

	return 30;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *headerView=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	if (section==0) {
		
		float width=(self.tableView.bounds.size.width-80)/2;
		colorView1=[[UIView alloc] initWithFrame:CGRectMake(40, 10, width, 30)];
		[colorView1 setBackgroundColor:scp.color1];
		colorView2=[[UIView alloc] initWithFrame:CGRectMake(40+width, 10, width, 30)];
		if (scp.color2==nil) {
			[colorView2 setBackgroundColor:scp.color1];
		}
		else {
			[colorView2 setBackgroundColor:scp.color2];
		}
		[headerView addSubview:colorView1];
//		[headerView addSubview:colorView2];

		UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorsTapped:)];
		[headerView setGestureRecognizers:[NSArray arrayWithObject:tap]];
		[tap release];
		return headerView;
	}
	return nil;
	if (section==1) {
		UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
		[title setText:@"Handling"];
		[title setAutoresizingMask:UIViewAutoresizingNone];
		[headerView addSubview:title];
		[title release];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	switch (section) {
		case 0:
			return nil;
			break;
		case 1:
			return @"Handling";
			break;
		case 2:
			return @"Special Instructions";
			break;
		case 3:
			return @"";
			break;
		default:
			break;
	}
	return @"No Section Name";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	static NSString *cellFormatName=@"cellFormat";		
//	WOFieldsCell *cell = (WOFieldsCell *)[tableView dequeueReusableCellWithIdentifier:cellFormatName];
//	if (cell == nil)
//	{
//		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"WOFieldsCell" owner:self options:nil];
//		cell = [nib objectAtIndex:0];
//	}
	NSLog(@"section,row: %d,%d",indexPath.section,indexPath.row);
	
	static NSString *cellFormatName=@"cellFormat";		
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellFormatName];
	if (cell==nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellFormatName] autorelease];
	}
	
	switch (indexPath.section) {
		case 0:
		{
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=@"Delivery Date:";
					cell.detailTextLabel.text=[[CrushHelper dateFormatShortStyle] stringFromDate:scp.date];
					break;					
				}
				case 1:
				{
					cell.textLabel.text=@"Lot:";
					if (scp.inLot==nil)
						cell.detailTextLabel.text=scp.lot;
					else 
						cell.detailTextLabel.text=scp.inLot.lotNumber;
					break;					
				}
				case 2:
				{
					cell.textLabel.text=@"Estimated Tons:";
					cell.detailTextLabel.text=[NSString stringWithFormat:@"%3.1f tons",[scp.estTons floatValue]];
					break;					
				}
				case 3:
				{
					cell.textLabel.text=@"Vineyard:";
					cell.detailTextLabel.text=[CrushHelper blankIfNull:scp.vineyard.name];
					break;					
				}
				case 4:
				{
					cell.textLabel.text=@"Varietal:";
					cell.detailTextLabel.text=[CrushHelper blankIfNull:scp.varietal];
					break;					
				}
				case 5:
				{
					cell.textLabel.text=@"Appellation:";
					cell.detailTextLabel.text=[CrushHelper blankIfNull:scp.vineyard.appellation];
					cell.accessoryType=UITableViewCellAccessoryNone;
					break;					
				}
				case 6:
				{
					cell.textLabel.text=@"Vessels:";
					NSMutableString *tanks=[[NSMutableString alloc] init];
					for (CCAssetReservation *reservation in scp.assetReservations)
					{
						[tanks appendFormat:@"%@ ",reservation.asset.name];
					}
					cell.detailTextLabel.text=tanks;
					break;					
				}
				default:
					break;
			}
		}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=@"Hand Sorting:";
					cell.accessoryType=UITableViewCellAccessoryNone;
					UISwitch *sw = [[UISwitch alloc] init];
					cell.accessoryView=sw;
					[sw setOn:scp.handSorting];
					[sw addTarget:self action:@selector(handSortingChanged:) forControlEvents:UIControlEventValueChanged];
					cell.accessoryView=sw;
					cell.detailTextLabel.text=@"";
					break;
				}
				case 1:
				{
					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					cell.textLabel.text=@"Crushing:";
					cell.detailTextLabel.text=[CrushHelper blankIfNull:scp.crushing];
					break;					
				}
				case 2:
				{
					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					cell.textLabel.text=@"Whole Cluster %:";
					cell.detailTextLabel.text=[NSString stringWithFormat:@"%d%%", (int)([scp.wholeClusterPercentage floatValue]*100)];
					break;					
				}
				case 3:
				{
//					if ([self.tableView numberOfRowsInSection:indexPath.section]==5) {
//						cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//						cell.textLabel.text=@"Tank Position:";
//						if (scp.tankPosition == CCTankPositionTop)
//							cell.detailTextLabel.text=@"TOP";
//						else 
//							cell.detailTextLabel.text=@"BOTTOM";
//					}
//					else {
						cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
						cell.textLabel.text=@"Sulphur PPM:";
						cell.detailTextLabel.text=[NSString stringWithFormat:@"%d ppm", scp.sulphurPPM];
//					}
					break;
				}
//				case 4:
//				{
//					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//					cell.textLabel.text=@"Sulphur PPM:";
//					cell.detailTextLabel.text=[NSString stringWithFormat:@"%d ppm", scp.sulphurPPM];
//					break;					
//				}
				default:
					break;
			}
			break;
		case 2:
		{
			static NSString *cellDescriptionName=@"DescriptionCell";
			DescriptionCell *cell2 = (DescriptionCell *)[tableView dequeueReusableCellWithIdentifier:cellDescriptionName];
			if (cell2 == nil)
			{
				NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];
				cell2 = [nib objectAtIndex:0];
			}		
			cell2.theDescription.text=[CrushHelper blankIfNull:self.scp.specialInstructions];
			cell2.theDescription.font=[UIFont fontWithName:@"Helvetica" size:kDescriptionFontSize];
			cell2.accessoryType=UITableViewCellAccessoryDisclosureIndicator;	
			return cell2;
			break;
		}
		case 3:
		{
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text=@"Weigh Tags";
					cell.detailTextLabel.text=[NSString stringWithFormat:@"%1d - %2.1f TONS",[scp.weighTags count],scp.actualTons];
					if ([scp.weighTags count]>0) {
						cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					}
					break;
				case 1:
					cell.textLabel.text=@"Processing Rate";
					cell.detailTextLabel.text=[NSString stringWithFormat:@"%1d tons/hour",scp.processingSpeed];
					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					break;
				default:
					break;
			}
		}
		default:
			break;
	}
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumberFormatter *myFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[myFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    self.popOverIndexPath=indexPath;
    
	switch (indexPath.section)	
	{
		case 0:
		{
			switch (indexPath.row) 
			{
				case 0:
				{
					DatePickerController *theController = [[DatePickerController alloc]
														   initWithDate:[scp date]];
                    [theController setContentSizeForViewInPopover:CGSizeMake(320, 300)];
					theController.delegate=self;
                    currentPopOverController.delegate=self;
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:theController];
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                    
//                    [self.navigationController pushViewController:theController animated:YES];	   
					[theController release];
					break;
				}
					break;
				case 1:
				{
//					LotTableViewController *theController = [[LotTableViewController alloc] initWithPicker:YES theLot:scp.lot withManagedObjectContext:nil];
//					[tableView deselectRowAtIndexPath:indexPath animated:YES];
//					theController.lotTableDelegate=self;
//					[self.navigationController pushViewController:theController animated:YES];
//					[theController release];
					break;
				}
				case 2:
				{
					NumberPickerController *thePicker=[[NumberPickerController alloc] initWithInitialValue:[scp.estTons floatValue] 
																							  useIncrement:0.5 
																							beginningValue:0.5 
																							   endingValue:50.0 
																								  forField:@"esttons" 
																								withFormat:@"%3.1f"
																							 widthOfPicker:80];
                    [thePicker setContentSizeForViewInPopover:CGSizeMake(320, 300)];
					thePicker.delegate=self;
                    currentPopOverController.delegate=self;
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:thePicker];
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                    [thePicker release];
                    
					break;
				}
					break;
				case 3:
				{
					CCVineyardListController *controller=[[CCVineyardListController alloc] initAsPicker:YES withdbid:scp.vineyard.dbid];
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:controller];
					controller.delegate=self;
                    currentPopOverController.delegate=self;
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:300] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
					[controller release];
					break;
				}
				case 4:
				{
					ChecklistController *theController = [[ChecklistController alloc] initWithListName:@"VARIETAL" withChecked:[scp varietal]];

					theController.delegate=self;
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:theController];
                    [currentPopOverController.contentViewController.view setTag:1];
                    currentPopOverController.delegate=self;
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];                    
					[theController release];
					break;
				}
				case 6:
				{
					if ([scp.theID isEqualToString:@"NEW"]) {
						[self.scp save];
					}
					CCTankListController *theController = [[CCTankListController alloc] initWithAssetReservations:scp.assetReservations forWO:scp];
                    UINavigationController *theNavController=[[UINavigationController alloc] initWithRootViewController:theController];
                    [theController setContentSizeForViewInPopover:CGSizeMake(320, 400)];
                    [theController release];
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:theNavController];
                    currentPopOverController.delegate=self;
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];                    
					[theNavController release];
					break;
				}
					
				default:
					break;
			}
			
			break;
		}
		case 1:
		{
			switch (indexPath.row) {
				case 0:
					[tableView deselectRowAtIndexPath:indexPath animated:YES];
					break;
				case 1:
				{
					ChecklistController *theController = [[ChecklistController alloc] initWithListName:@"CRUSHING" withChecked:[scp crushing]];
                    [theController setContentSizeForViewInPopover:CGSizeMake(320, 175)];
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:theController];
                    [theController release];
                    currentPopOverController.delegate=self;
					theController.delegate=self;
                     [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];                                        
					break;
				}
				case 2:
				{
					[tableView deselectRowAtIndexPath:indexPath animated:YES];
					NumberPickerController *thePicker=[[NumberPickerController alloc] initWithInitialValue:[scp.wholeClusterPercentage floatValue]*100 
																							  useIncrement:10 
																							beginningValue:0 
																							   endingValue:100 
																								  forField:@"wholeClusterPercentage" 
																								withFormat:@"%3.0f%%"
																							 widthOfPicker:80];
					
                    [thePicker setContentSizeForViewInPopover:CGSizeMake(320, 300)];
					thePicker.delegate=self;
                    currentPopOverController.delegate=self;
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:thePicker];
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                    [thePicker release];

					break;
				}
				case 3:
				{
					[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

					NumberPickerController *thePicker=[[NumberPickerController alloc] initWithInitialValue:scp.sulphurPPM  
																							  useIncrement:5
																							beginningValue:0 
																							   endingValue:100 
																								  forField:@"sulphurPPM" 
																								withFormat:@"%3.0f ppm"
																							widthOfPicker:120];
					
                    [thePicker setContentSizeForViewInPopover:CGSizeMake(320, 300)];
					thePicker.delegate=self;
                    currentPopOverController.delegate=self;
                    currentPopOverController=[[UIPopoverController alloc] initWithContentViewController:thePicker];
                    [currentPopOverController presentPopoverFromRect:[self CGRectFromIndexPath:indexPath withOffset:200] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                    [thePicker release];
					break;
				}
				default:
					break;
			}
			break;
		}
		case 2:
		{			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			DescriptionController *theController=[[DescriptionController alloc] initWithDescription:self.scp.specialInstructions
																	forField:@"specialInstructions"];			
			
			theController.delegate=self;
			[self.navigationController pushViewController:theController animated:YES];
			[theController release];
			break;
		}
		case 3:
			{
				switch (indexPath.row) {
					case 0:
					{	
						WOPickerController *controller=[[WOPickerController alloc] initWithStyle:UITableViewStyleGrouped allWorkOrders:[scp.inLot weightTagsInLot] checkedWorkOrders:scp.weighTags forSCP:scp];
						controller.delegate=self;
						[self.navigationController pushViewController:controller animated:YES];
						[controller release];
					}
						break;
					case 1:
					{
						[tableView deselectRowAtIndexPath:indexPath animated:YES];
						NumberPickerController *controller=[[NumberPickerController alloc] initWithInitialValue:4 
																								   useIncrement:1 
																								 beginningValue:2 
																									endingValue:6 
																									   forField:@"processingSpeed" 
																									 withFormat:@"%1.0f" 
																								  widthOfPicker:80];
						controller.delegate=self;
						[controller setModalTransitionStyle:UIModalTransitionStylePartialCurl];
						[self.navigationController presentModalViewController:controller animated:YES];
						[controller release];
						break;
					}
				}
			}			
		default:
			break;
	}
}

#pragma mark -
#pragma mark input delegate

-(void) addWeighTag:(CCWT *)wt
{
	[scp.weighTags addObject:wt];
	[self.tableView reloadData];
}
-(void) removeWeighTag:(CCWT *)wt
{
	[scp.weighTags removeObject:wt];
	[self.tableView reloadData];
}

-(void) cancelled:(id) sender
{
    [currentPopOverController dismissPopoverAnimated:YES];
}
-(void) colorsChosen:(id) sender
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;

	CCSCPColorPickerController *thePicker=(CCSCPColorPickerController *)sender;
	scp.color1=[thePicker color1];
	scp.color2=[thePicker color2];
	[self.tableView reloadData];
	pushOnSave=YES;
    [currentPopOverController dismissPopoverAnimated:YES];
}

-(void) handSortingChanged:(id)sender
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
		
	if ([sender isOn])
		self.scp.handSorting=YES;
	else 
		self.scp.handSorting=NO;
}

-(void) datePicked:(DatePickerController *)controller
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	[self.scp setDate:[controller.datePicker date]];
	
//	[self.navigationController popViewControllerAnimated:YES];
    [currentPopOverController dismissPopoverAnimated:YES];
	[self.tableView reloadData];
}

-(void) ChangedDescription:(DescriptionController *)controller newText:(NSString *)theText forField:(NSString *)field 
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	self.scp.specialInstructions=theText;
	[self.navigationController popViewControllerAnimated:YES];
	
	[self.tableView reloadData];
	
}
/*
-(void) LotChecked:(LotTableViewController *)controller checkedItem:(NSString *)item
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	scp.inLot=[scp.inLot.vintage getLotByNumber:item];
	scp.lot=item;

	[self.navigationController popViewControllerAnimated:YES];
	
	[self.tableView reloadData];
}
*/
-(void) PositionChecked:(ChecklistController *)controller checkedItem:(NSString *)item
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	if ([controller.checkListName isEqualToString:@"CLIENTNAME"]) {
		[self.scp setClientname:item];
		//	} else if ([controller.checkListName isEqualToString:@"VINEYARD"]) {
		//		[self.scp setVineyard:item];
	} else if ([controller.checkListName isEqualToString:@"LOT"]) {
		[self.scp setLot:item];
	} else if ([controller.checkListName isEqualToString:@"VARIETAL"]) {
		[self.scp setVarietal:item];
	} else if ([controller.checkListName isEqualToString:@"APPELLATION"]) {
		[self.scp setAppellation:item];
	} else if ([controller.checkListName isEqualToString:@"REGIONCODE"]) {
		[self.scp setRegionCode:item];
	} else if ([controller.checkListName isEqualToString:@"CRUSHING"]) {
		[self.scp setCrushing:item];
	} else if ([controller.checkListName isEqualToString:@"TANKPOSITION"])
	{
		if ([item isEqualToString:@"TOP"]) 
			self.scp.tankPosition=CCTankPositionTop;
		else
			self.scp.tankPosition=CCTankPositionBottom;
	}
	
//	[self.navigationController popViewControllerAnimated:YES];
//	[self.tableView reloadData];
    [currentPopOverController dismissPopoverAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:popOverIndexPath] withRowAnimation:UITableViewRowAnimationFade];  
}

-(void)pickedVineyard:(CCVineyardListController *)controller item:(NSInteger)index
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	self.scp.vineyard=[[CCVineyard alloc] initWithVineyard:[controller.vydList objectAtIndex:index]];
    [currentPopOverController dismissPopoverAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:popOverIndexPath] withRowAnimation:UITableViewRowAnimationFade];  
}

-(void) NumberPicked:(NumberPickerController *)thePicker withValue:(float)value forField:(NSString *)fieldName
{	
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSCP)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	if ([fieldName isEqualToString:@"wholeClusterPercentage"])
	{
		float val=value/100.0;
		self.scp.wholeClusterPercentage=[[NSNumber alloc] initWithFloat:val];
	}
	else if ([fieldName isEqualToString:@"esttons"])
	{
		NSString *newValue=[[[NSString alloc] initWithFormat:@"%8.4f",value] autorelease];
		[self.scp setEstTons:newValue];		
	}
	else if ([fieldName isEqualToString:@"sulphurPPM"])
	{
		[self.scp setSulphurPPM:(int)value];
		pushOnSave=YES;
	}
	else if ([fieldName isEqualToString:@"processingSpeed"])
	{	
		[self.scp setProcessingSpeed:(int)value];
		pushOnSave=YES;
	}
	
    [currentPopOverController dismissPopoverAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:popOverIndexPath] withRowAnimation:UITableViewRowAnimationFade];  
//	[self.navigationController dismissModalViewControllerAnimated:YES];
//	[self.navigationController popViewControllerAnimated:YES];
//	[self.tableView reloadData];
}

#pragma mark -
#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	switch (buttonIndex) {
		case 0:
//			[CrushHelper sendPushToClient:[[ap defaultVintage] client] withMessage:@"You are needed at the Scale.  Grapes have arrived." incrementBadge:YES playSound:YES];
			break;
		case 1:
//			[CrushHelper sendPushToClient:[[ap defaultVintage] client] withMessage:@"You are needed at the Sorting Line." incrementBadge:YES playSound:YES];
			break;
		case 2:
		{	
//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//				CCSortingTableActivity *theActivity=[[CCSortingTableActivity alloc] initWithSCP:scp onDay:[NSDate date]];
//				[[ap sortingTable] addActivity:theActivity];
//				[theActivity release];			
//			});				
		}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark Push Messaging

//-(void) sendPage
//{
//	UIActionSheet *mySheet=[[UIActionSheet alloc] initWithTitle:@"Page Winemaker" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"To Scale",@"To Sorting Line",nil];
//	[mySheet showInView:self.view];
//	[mySheet release];
//}


-(void)changeCompletionStatus
{
	if ([scp.status isEqual:@"COMPLETED"])
		scp.status=@"ASSIGNED";
	else 
		scp.status=@"COMPLETED";
	[self saveSCP];
}

#pragma mark -
#pragma mark memory management
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
    [popOverIndexPath release];
    [currentPopOverController release];
    [colorView1 release];
    [colorView2 release];
	[titleArea release];
    [scp release];
    [super dealloc];
}


@end
