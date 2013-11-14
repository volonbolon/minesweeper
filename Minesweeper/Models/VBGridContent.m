//
//  VBMineCoordinate.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBGridContent.h"

@implementation VBGridContent

- (id)initWithOrderedPair:(VBOrderedPair *)orderedPair {
    
    self = [super init];
    
    if ( self != nil ) {
        
        _orderedPair = orderedPair;
        _mine = NO;
        _weight = 0;
        _revealed = NO;
        
    }
    
    return self;
    
}

@end
