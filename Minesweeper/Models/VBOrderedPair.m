//
//  VBOrderedPair.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 13/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBOrderedPair.h"

@implementation VBOrderedPair
+ (id)orderedPairWithIndexPath:(NSIndexPath *)indexPath {
    
    VBOrderedPair *op = [[VBOrderedPair alloc] initWithX:[indexPath row]
                                                       y:[indexPath section]];
    
    return op;
    
}

- (id)initWithX:(NSUInteger)x y:(NSUInteger)y {
    
    self = [super init];
    
    if ( self != nil ) {
        
        _x = x;
        _y = y;
        
    }
    
    return self;
    
}

- (NSIndexPath *)indexPathFromOrderedPair {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self x]
                                         inSection:[self y]];
    return ip;
    
}

#pragma mark - equality
- (BOOL)isEqualToOrderedPair:(VBOrderedPair *)op {
    
    return [op x]==[self x]&&[op y]==[self y];
    
}

- (BOOL)isEqual:(id)object {
    
    BOOL isEqual = NO;
    
    if ( self == object ) {
        
        isEqual = YES;
        
    } else if ( [object isKindOfClass:[self class]] ) {
        
        isEqual = [self isEqualToOrderedPair:object];
        
    }
    
    return isEqual;
    
}

- (NSUInteger)hash {
    
    return ([self y]<<16)+[self x];
    
}

@end
