//
//  VBMineGrid.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBGridContent;
@class VBOrderedPair;
@interface VBMineGrid : NSObject

@property (strong) NSSet *mines;

- (id)initWithRows:(NSUInteger)rows
           columns:(NSUInteger)columns;
- (void)plantMines:(NSUInteger)numberOfMinesToPlant;
- (NSSet *)revealFromCoordinate:(VBOrderedPair *)coordinate;
- (BOOL)validateGrid;
- (id)valueAtCoordinate:(VBOrderedPair *)coordinate;
@end
