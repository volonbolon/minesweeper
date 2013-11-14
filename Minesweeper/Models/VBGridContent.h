//
//  VBMineCoordinate.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBOrderedPair;
@interface VBGridContent : NSObject
@property (readonly, strong) VBOrderedPair *orderedPair;
@property (readwrite, getter = isMine) BOOL mine;
@property (readwrite) NSUInteger weight;
@property (readwrite, getter = isRevealed) BOOL revealed;

- (id)initWithOrderedPair:(VBOrderedPair *)orderedPair;
@end
