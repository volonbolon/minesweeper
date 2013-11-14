//
//  VBMineGrid+Helpers.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBMineGrid+Helpers.h"
#import "VBMineGrid_Private.h"
#import "VBOrderedPair.h"

@implementation VBMineGrid (Helpers)
- (VBOrderedPair *)randomCoordinate {
    
    static NSUInteger columnMax = NSUIntegerMax;
    if ( columnMax == NSUIntegerMax ) {
        
        columnMax = [[[self rows] lastObject] count];
        
    }
    
    static NSUInteger rowMax = NSUIntegerMax;
    if ( rowMax == NSUIntegerMax ) {
        
        rowMax = [[self rows] count];
        
    }
    
    u_int32_t x = arc4random_uniform(columnMax);
    u_int32_t y = arc4random_uniform(rowMax);
    
    VBOrderedPair *orderedPair = [[VBOrderedPair alloc] initWithX:x
                                                                y:y];
    
    return orderedPair;
    
}

- (void)setValue:(id)value atCoordinate:(VBOrderedPair *)coordinate {
    
    [(NSMutableArray *)[[self rows] objectAtIndex:[coordinate y]] setObject:value
                                                         atIndexedSubscript:[coordinate x]];
    
}

- (NSSet *)neighbours:(VBOrderedPair *)coordinate {
    
    NSMutableSet *neighbours = [[NSMutableSet alloc] initWithCapacity:8];
    
    NSUInteger coordinateColumn = [coordinate x];
    NSUInteger coordinateRow = [coordinate y];
    
    BOOL xm1ym1ShouldBeInspected = coordinateColumn >= 1 && coordinateRow >= 1;
    BOOL xym1ShouldBeInspected = coordinateRow >= 1;
    BOOL x1ym1ShouldBeInspected = coordinateRow >= 1 && [[[self rows] objectAtIndex:coordinateRow-1] count]>coordinateColumn+1;
    BOOL xm1ShouldBeInspected = coordinateColumn >= 1;
    BOOL x1ShouldBeInspected = [[[self rows] objectAtIndex:coordinateRow] count]>coordinateColumn+1;
    BOOL xm1y1ShouldBeInspected = coordinateColumn >= 1 && [[self rows] count]>coordinateRow+1;
    BOOL xy1ShouldBeInspected = [[self rows] count] > coordinateRow+1;
    BOOL x1y1ShouldBeInspected = xy1ShouldBeInspected && [[[self rows] objectAtIndex:coordinateRow+1] count]>coordinateColumn+1;
    
    if ( xm1ym1ShouldBeInspected ) {
        
        VBOrderedPair *xm1ym1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn-1
                                                                         y:coordinateRow-1];
        
        [neighbours addObject:xm1ym1Coordinate];
        
    }
    
    if ( xym1ShouldBeInspected ) {
        
        VBOrderedPair *xym1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn
                                                                       y:coordinateRow-1];
        
        [neighbours addObject:xym1Coordinate];
        
    }
    
    if ( x1ym1ShouldBeInspected ) {
        
        VBOrderedPair *x1ym1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn+1
                                                                        y:coordinateRow-1];
        
        [neighbours addObject:x1ym1Coordinate];
        
    }
    
    if ( xm1ShouldBeInspected ) {
        
        VBOrderedPair *xm1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn-1
                                                                      y:coordinateRow];
        
        [neighbours addObject:xm1Coordinate];
        
    }
    
    if ( x1ShouldBeInspected ) {
        
        VBOrderedPair *x1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn+1
                                                                     y:coordinateRow];
        
        [neighbours addObject:x1Coordinate];
        
    }
    
    if ( xm1y1ShouldBeInspected ) {
        
        VBOrderedPair *xm1y1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn-1
                                                                        y:coordinateRow+1];
        
        [neighbours addObject:xm1y1Coordinate];
        
    }
    
    if ( xy1ShouldBeInspected ) {
        
        VBOrderedPair *xy1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn
                                                                      y:coordinateRow+1];
        
        [neighbours addObject:xy1Coordinate];
        
    }
    
    if ( x1y1ShouldBeInspected ) {
        
        VBOrderedPair *xm1ym1Coordinate = [[VBOrderedPair alloc] initWithX:coordinateColumn+1
                                                                         y:coordinateRow+1];
        
        [neighbours addObject:xm1ym1Coordinate];
        
    }
    
    return neighbours;
    
}


@end