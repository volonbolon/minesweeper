//
//  VBMineGrid.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBMineGrid.h"
#import "VBMineGrid_Private.h"
#import "VBMineGrid+Helpers.h"
#import "VBGridContent.h"
#import "VBOrderedPair.h"

@implementation VBMineGrid
- (id)initWithRows:(NSUInteger)rowsCount
           columns:(NSUInteger)columnsCount {
    
    self = [super init];
    
    if ( self != nil ) {
        
        _rows = [[NSMutableArray alloc] initWithCapacity:rowsCount];
        for ( NSUInteger r = 0; r < rowsCount; r++ ) {
            
            @autoreleasepool {
                
                NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:columnsCount];
                
                for ( NSUInteger c = 0; c < columnsCount; c++ ) {
                    
                    VBOrderedPair *orderedPair = [[VBOrderedPair alloc] initWithX:r y:c];
                    
                    VBGridContent *content = [[VBGridContent alloc] initWithOrderedPair:orderedPair];
                    
                    [columns addObject:content];
                    
                }
                
                [_rows addObject:columns];
                
            }
            
        }
        
        _cellsToRevealTally = rowsCount * columnsCount;
        
    }
    
    return self;
    
}

- (id)valueAtCoordinate:(VBOrderedPair *)coordinate {
    
    return [(NSArray *)[[self rows] objectAtIndex:[coordinate x]] objectAtIndex:[coordinate y]];
    
}


- (void)plantMines:(NSUInteger)numberOfMinesToPlant {

    NSSet *minesCoordinates = [self minesCoordinates:numberOfMinesToPlant];
    
    NSMutableSet *mines = [[NSMutableSet alloc] initWithCapacity:numberOfMinesToPlant];
    
    for ( VBOrderedPair *op in minesCoordinates ) {

        VBGridContent *gc = [self valueAtCoordinate:op];
        [gc setMine:YES];
        
        [self weightNeighbours:op];
        
        [mines addObject:gc];
    
    }
    
    [self setCellsToRevealTally:[self cellsToRevealTally]-numberOfMinesToPlant];
    
    [self setMines:mines];

}

- (NSSet *)clearCellsFromCoordinate:(VBOrderedPair *)coordinate {
    
    // we go dfs here. 
    NSMutableSet *clearCells = [[NSMutableSet alloc] init];
    NSMutableArray *cache = [[NSMutableArray alloc] init];
    [cache addObject:coordinate];
    while ( [cache count] > 0 ) {
        
        VBOrderedPair *cachedCoordinate = [cache lastObject];
        [cache removeLastObject];
        
        if ( ![clearCells containsObject:cachedCoordinate] ) {
            
            [clearCells addObject:cachedCoordinate];
            
            NSSet *neighbours = [self neighbours:cachedCoordinate];
            for ( VBOrderedPair *op in neighbours ) {
                
                VBGridContent *gc = [self valueAtCoordinate:op];
                if ( [gc weight] == 0 ) {
                    
                    [cache addObject:op];
                    
                }
                
            }
            
        }
        
    }
    
    return clearCells;
    
}

- (NSSet *)revealFromCoordinate:(VBOrderedPair *)coordinate {
    
    NSSet *revelealedCoordinate = nil;
    VBGridContent *valueAtCoordinate = [self valueAtCoordinate:coordinate];

    if ( [valueAtCoordinate isMine] || [valueAtCoordinate weight] > 0 ) {
    
        revelealedCoordinate = [[NSSet alloc] initWithObjects:[valueAtCoordinate orderedPair], nil];
        [self setCellsToRevealTally:[self cellsToRevealTally]-1];
        
    } else {
        
        revelealedCoordinate = [self clearCellsFromCoordinate:coordinate];
        [self setCellsToRevealTally:[self cellsToRevealTally]-[revelealedCoordinate count]];
        
    }
    
    return revelealedCoordinate;
    
}

#pragma mark - Private
- (NSSet *)minesCoordinates:(NSUInteger )numberOfMines {
    
    NSMutableSet *mines = [[NSMutableSet alloc] initWithCapacity:numberOfMines];
    
    while ( [mines count] < numberOfMines ) {
        
        @autoreleasepool {
            
            VBOrderedPair *op = [self randomCoordinate];
            
            [mines addObject:op];
        
        }
        
    }
    
    return mines;
    
}


- (void)weightNeighbours:(VBOrderedPair *)coordinate {
    
    NSSet *coordinatesToInspect = [self neighbours:coordinate];
    
    for ( VBOrderedPair *coordinate in coordinatesToInspect ) {
        
        VBGridContent *gc = [self valueAtCoordinate:coordinate];
        if ( ![gc isMine] ) {
            
            [gc setWeight:[gc weight]+1];
            
        }

    }
    
}

- (BOOL)validateGrid {
    
    return [self cellsToRevealTally]==0;
    
}

@end
