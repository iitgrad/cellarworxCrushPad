//
//  CCTankListController.m
//  Crush
//
//  Created by Kevin McQuown on 6/30/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCTankListController.h"
#import "CCAsset.h"
#import "WOFieldsCell.h"
#import "CrushHelper.h"
#import "CCTankPickerController.h"
#import "NumberPickerController.h"
#import "CCAssetReservation.h"
#import "CCTankLoadingController.h"
#import "cellarworxAppDelegate.h"

@implementation CCTankListController
@synthesize wo;

-(id) initWithAssetReservations:(NSArray *)assetReservations forWO:(CCWorkOrder *)theWO
{
	if (self=[super initWithStyle:UITableViewStyleGrouped])
	{
		self.wo=theWO;
	}
	self.title=@"Assets";
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
	}
	
	cell.textLabel.text=[[[self.wo.assetReservations objectAtIndex:indexPath.row] asset]name];
	NSString *detail=[NSString stringWithFormat:@"%@ - %d %d BINS",[[[self.wo.assetReservations objectAtIndex:indexPath.row] asset] owner],
					  [[[[self.wo.assetReservations objectAtIndex:indexPath.row] asset] capacity] intValue],
					  [[self.wo.assetReservations objectAtIndex:indexPath.row] binCount] ];
	cell.detailTextLabel.text=detail;

	return cell;
}
-(void)setBinsInVessel:(NSUInteger)binCount forReservation:(CCAssetReservation *)reservation
{
	[self dismissModalViewControllerAnimated:YES];
	[reservation setBinCount:binCount];
	[self.tableView reloadData];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[reservation save];
//	});
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([ap staff])
    {
        NSUInteger binsAllocated=0;
        for (int i=0; i<[[wo assetReservations] count]; i++) {
            if (i!=indexPath.row) {
                binsAllocated+=[[[wo assetReservations] objectAtIndex:i] binCount];
            }
        }
        
        CCTankLoadingController *controller=[[CCTankLoadingController alloc] initWithNibName:@"CCTankLoadingController" 
                                                                                      bundle:nil 
                                                                                      forSCP:(CCSCP *)wo 
                                                                              andReservation:[[wo assetReservations] objectAtIndex:indexPath.row] 
                                                                        binsAlreadyAllocated:binsAllocated];
        controller.delegate=self;
        [self presentModalViewController:controller animated:YES];
        [controller release];        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	UIBarButtonItem	*addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRecord)];
	self.navigationItem.rightBarButtonItem=addButton;	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[[self.wo assetReservations] objectAtIndex:indexPath.row] delete];
//		dispatch_async(dispatch_get_main_queue(), ^{
			[[self.wo assetReservations] removeObjectAtIndex:indexPath.row];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];			
//		});
//	});
}

-(void) AssetChosen:(CCAsset *)asset;
{
	CCAssetReservation *assetReservation=[[CCAssetReservation alloc] initWithWO:wo withAsset:asset];
	[self.wo addAssetReservation:assetReservation];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[assetReservation save];
//	});
	[assetReservation release];
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.wo.assetReservations count];
}

//-(BOOL) canAddRecords
//{
//	return YES;
//}

-(void) addRecord 
{
	CCTankPickerController *controller=[[CCTankPickerController alloc] initWithWO:self.wo];
    [controller setContentSizeForViewInPopover:CGSizeMake(320, 480)];
	controller.delegate=self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(BOOL) tableIsEditable
{
	return YES;
}

-(void) dealloc
{
    [wo release];
    [super dealloc];
}
@end
