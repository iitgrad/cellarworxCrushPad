//
//  CCWeighTagPickerCell.h
//  Crush
//
//  Created by Kevin McQuown on 7/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCWeighTagPickerCell : UITableViewCell {

	IBOutlet UILabel *number;
    IBOutlet UILabel *description;
    IBOutlet UILabel *tons;
}
@property (nonatomic, retain) IBOutlet UILabel *number;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UILabel *tons;

@end
