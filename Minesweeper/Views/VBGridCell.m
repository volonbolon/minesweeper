//
//  VBGridCell.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 13/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBGridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VBGridCell

- (void)prepareForReuse {
    
    [[self button] setHidden:NO];
    [[self weightLabel] setHidden:YES];
    [[self button] setTitle:nil
                   forState:UIControlStateNormal];
    
}

@end
