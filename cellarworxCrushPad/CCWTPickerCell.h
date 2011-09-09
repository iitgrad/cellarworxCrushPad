//
//  CCWTPickerCell.h
//  Crush
//
//  Created by Kevin McQuown on 7/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCWTPickerCell : UITableViewCell {

	IBOutlet UILabel *tons;
	IBOutlet UILabel *description;
	IBOutlet UILabel *number;
}
@property (nonatomic, retain) IBOutlet UILabel *tons;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UILabel *number;

@end
