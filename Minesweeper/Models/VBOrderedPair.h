//
//  VBOrderedPair.h
//  Minesweeper
//
//  Created by Ariel Rodriguez on 13/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import <Foundation/Foundation.h>

// I am using a class because it is easier to mock
@interface VBOrderedPair : NSObject
@property NSUInteger x;
@property NSUInteger y;

+ (id)orderedPairWithIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathFromOrderedPair;
- (id)initWithX:(NSUInteger)x y:(NSUInteger)y;

@end
