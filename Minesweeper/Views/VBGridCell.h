//
//  VBGridCell.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 13/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
