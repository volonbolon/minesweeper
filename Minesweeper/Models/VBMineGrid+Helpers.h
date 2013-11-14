//
//  VBMineGrid+Helpers.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBMineGrid.h"

@class VBOrderedPair;
@interface VBMineGrid (Helpers)

- (VBOrderedPair *)randomCoordinate;
- (void)setValue:(id)value
    atCoordinate:(VBOrderedPair *)coordinate;
- (NSSet *)neighbours:(VBOrderedPair *)coordinate;
@end
