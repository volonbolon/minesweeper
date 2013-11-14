//
//  VBMineGrid_Private.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBMineGrid.h"

@class VBGridContent;
@class VBOrderedPair;
@interface VBMineGrid ()
@property (strong) NSMutableArray *rows;
@property (strong) NSSet *revealedCoordinates;
@property NSUInteger cellsToRevealTally;

- (NSSet *)minesCoordinates:(NSUInteger )numberOfMines;
- (void)weightNeighbours:(VBOrderedPair *)coordinate;
- (NSSet *)clearCellsFromCoordinate:(VBOrderedPair *)coordinate;

@end
