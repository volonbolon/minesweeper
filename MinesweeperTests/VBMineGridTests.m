//
//  VBMineGridTests.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VBMineGrid.h"
#import "VBMineGrid_Private.h"
#import "VBMineGrid+Helpers.h"
#import "VBGridContent.h"
#import "VBOrderedPair.h"
#import <OCMock/OCMock.h>

@interface VBMineGridTests : XCTestCase
- (NSSet *)produceTestMinesCoordinates;
@end

@implementation VBMineGridTests
//     0   1   2   3   4   5   6   7
// 0 | 1 | 1 | 2 | o | 1 |   |   |   |
// 1 | 1 | o | 2 | 1 | 2 | 1 | 1 |   |
// 2 | 1 | 1 | 2 | 1 | 2 | o | 1 |   |
// 3 | 2 | 2 | 2 | o | 2 | 1 | 1 |   |
// 4 | o | o | 2 | 1 | 1 |   | 1 | 1 |
// 5 | 2 | 3 | 2 | 1 | 1 | 1 | 2 | o |
// 6 |   | 1 | o | 2 | 2 | o | 2 | 1 |
// 7 |   | 1 | 1 | 2 | o | 2 | 1 |   |

// {(1,1),(3,0),(5,2),(3,3),(0,4),(1,4),(7,5),(2,6),(5,6),(4,7)}

- (NSSet *)produceTestMinesCoordinates {
    
    VBOrderedPair *op0 = [[VBOrderedPair alloc] initWithX:1 y:1];
    VBOrderedPair *op1 = [[VBOrderedPair alloc] initWithX:3 y:0];
    VBOrderedPair *op2 = [[VBOrderedPair alloc] initWithX:5 y:2];
    VBOrderedPair *op3 = [[VBOrderedPair alloc] initWithX:3 y:3];
    VBOrderedPair *op4 = [[VBOrderedPair alloc] initWithX:0 y:4];
    VBOrderedPair *op5 = [[VBOrderedPair alloc] initWithX:1 y:4];
    VBOrderedPair *op6 = [[VBOrderedPair alloc] initWithX:7 y:5];
    VBOrderedPair *op7 = [[VBOrderedPair alloc] initWithX:2 y:6];
    VBOrderedPair *op8 = [[VBOrderedPair alloc] initWithX:5 y:6];
    VBOrderedPair *op9 = [[VBOrderedPair alloc] initWithX:4 y:7];
    
    NSSet *coordinates = [NSSet setWithArray:@[op0, op1, op2, op3, op4, op5, op6, op7, op8, op9]];
    
    return coordinates;
    
}

- (void)testCanInitWithRowAndColumns {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    XCTAssertTrue([[mineGrid rows] count]==rows, @"The grid should contain %d rows, %d found", rows, [[mineGrid rows] count]);
    
    for ( NSArray *row in [mineGrid rows] ) {
        
        XCTAssertTrue([row count]==columns, @"The row should contain %d columns, %d found", columns, [row count]);
        
    }
    
}

- (void)testMinesCoordinate {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    VBOrderedPair *op1 = [[VBOrderedPair alloc] initWithX:2
                                                        y:2];
    VBOrderedPair *op2 = [[VBOrderedPair alloc] initWithX:2
                                                        y:2];
    VBOrderedPair *op3 = [[VBOrderedPair alloc] initWithX:3
                                                        y:4];
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    [[[partialMineGrid expect] andReturn:op1] randomCoordinate];
    [[[partialMineGrid expect] andReturn:op2] randomCoordinate];
    [[[partialMineGrid expect] andReturn:op3] randomCoordinate];
    
    NSSet *set = [mineGrid minesCoordinates:2];
    
    XCTAssertTrue([set count]==2, @"set should be composed by 2 elements, %d found", [set count]);
    
    [partialMineGrid verify];
    
}


- (void)testPlantMines {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    [[[partialMineGrid expect] andReturn:[self produceTestMinesCoordinates]] minesCoordinates:10];
    
    [[partialMineGrid expect] setMines:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj isKindOfClass:[NSSet class]] && [(NSSet *)obj count]==10;
    }]];
    
    [mineGrid plantMines:10];
    
    VBOrderedPair *x1y1 = [[VBOrderedPair alloc] initWithX:1 y:1];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x1y1] isMine], @"item at (1,1) should be a mine");
    
    VBOrderedPair *x3y0 = [[VBOrderedPair alloc] initWithX:3 y:0];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x3y0] isMine], @"item at (3,0) should be a mine");
    
    VBOrderedPair *x5y2 = [[VBOrderedPair alloc] initWithX:5 y:2];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x5y2] isMine], @"item at (5,2) should be a mine");
    
    VBOrderedPair *x3y3 = [[VBOrderedPair alloc] initWithX:3 y:3];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x3y3] isMine], @"item at (3,3) should be a mine");
    
    VBOrderedPair *x0y4 = [[VBOrderedPair alloc] initWithX:0 y:4];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x0y4] isMine], @"item at (0,4) should be a mine");
    
    VBOrderedPair *x1y4 = [[VBOrderedPair alloc] initWithX:1 y:4];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x1y4] isMine], @"item at (1,4) should be a mine");
    
    VBOrderedPair *x7y5 = [[VBOrderedPair alloc] initWithX:7 y:5];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x7y5] isMine], @"item at (7,5) should be a mine");
    
    VBOrderedPair *x2y6 = [[VBOrderedPair alloc] initWithX:2 y:6];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x2y6] isMine], @"item at (2,6) should be a mine");
    
    VBOrderedPair *x5y6 = [[VBOrderedPair alloc] initWithX:5 y:6];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x5y6] isMine], @"item at (5,6) should be a mine");
    
    VBOrderedPair *x4y7 = [[VBOrderedPair alloc] initWithX:4 y:7];
    XCTAssertTrue([(VBGridContent *)[mineGrid valueAtCoordinate:x4y7] isMine], @"item at (4,7) should be a mine");
    
    [partialMineGrid verify];
    
}

- (void)testWeight {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    [[[partialMineGrid expect] andReturn:[self produceTestMinesCoordinates]] minesCoordinates:10];
    
    [mineGrid plantMines:10];
    
    VBOrderedPair *x0y0 = [[VBOrderedPair alloc] initWithX:0 y:0];
    VBGridContent *gc1 = [mineGrid valueAtCoordinate:x0y0];
    XCTAssertTrue([gc1 weight]==1, @"gc1 should be 1, %d found", [gc1 weight]);

    VBOrderedPair *x0y3 = [[VBOrderedPair alloc] initWithX:0 y:3];
    VBGridContent *gc2 = [mineGrid valueAtCoordinate:x0y3];
    XCTAssertTrue([gc2 weight]==2, @"gc2 should be 2, %d found", [gc2 weight]);
    
    VBOrderedPair *x1y5 = [[VBOrderedPair alloc] initWithX:1 y:5];
    VBGridContent *gc3 = [mineGrid valueAtCoordinate:x1y5];
    XCTAssertTrue([gc3 weight]==3, @"gc3 should be 3, %d found", [gc3 weight]);
    
    VBOrderedPair *x7y0 = [[VBOrderedPair alloc] initWithX:7 y:0];
    VBGridContent *gc4 = [mineGrid valueAtCoordinate:x7y0];
    XCTAssertTrue([gc4 weight]==0, @"gc4 should be 0, %d found", [gc4 weight]);

    [partialMineGrid verify];
    
}

- (void)testRevealFromCoordinateWithMine {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    [[[partialMineGrid expect] andReturn:[self produceTestMinesCoordinates]] minesCoordinates:10];
    
    [mineGrid plantMines:10];
    
    VBOrderedPair *x3y0 = [[VBOrderedPair alloc] initWithX:3 y:0];
    NSSet *set = [mineGrid revealFromCoordinate:x3y0];
    
    XCTAssertTrue([set count]==1, @"set should contain only the mine");
    VBGridContent *gc = [mineGrid valueAtCoordinate:[set anyObject]];
    XCTAssertTrue([gc isMine], @"set content should be a mine");
    
    [partialMineGrid verify];
    
}

- (void)testRevealFromCoordinateWithWeightedCell {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    [[[partialMineGrid expect] andReturn:[self produceTestMinesCoordinates]] minesCoordinates:10];
    
    [mineGrid plantMines:10];
    
    VBOrderedPair *x5y1 = [[VBOrderedPair alloc] initWithX:5 y:1];
    NSSet *set = [mineGrid revealFromCoordinate:x5y1];
    
    XCTAssertTrue([set count]==1, @"set should contain only the mine");
    VBGridContent *gc = [mineGrid valueAtCoordinate:[set anyObject]];
    XCTAssertTrue([gc weight]>0, @"set weight should be bigger than zero");
    XCTAssertFalse([gc isMine], @"set content should not be a mine");
    
    [partialMineGrid verify];
    
}

- (void)testClearCellsFromCoordinate {
    
    NSUInteger columns = 8;
    NSUInteger rows = 8;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    [[[partialMineGrid expect] andReturn:[self produceTestMinesCoordinates]] minesCoordinates:10];
    
    [mineGrid plantMines:10];
    
    VBOrderedPair *x7y2 = [[VBOrderedPair alloc] initWithX:7 y:2];
    NSSet *set = [mineGrid revealFromCoordinate:x7y2];
    XCTAssertTrue([set count]==6, @"set should contain six elements");
    
    XCTAssertTrue([set containsObject:x7y2], @"should contains pair (7,2)");
    
    VBOrderedPair *x5y0 = [[VBOrderedPair alloc] initWithX:5 y:0];
    XCTAssertTrue([set containsObject:x5y0], @"should contains pair (5,0)");
    
    VBOrderedPair *x7y0 = [[VBOrderedPair alloc] initWithX:7 y:0];
    XCTAssertTrue([set containsObject:x7y0], @"should contains pair (7,0)");
    
    VBOrderedPair *x7y1 = [[VBOrderedPair alloc] initWithX:7 y:1];
    XCTAssertTrue([set containsObject:x7y1], @"should contains pair (7,1)");
    
    VBOrderedPair *x7y3 = [[VBOrderedPair alloc] initWithX:7 y:3];
    XCTAssertTrue([set containsObject:x7y3], @"should contains pair (7,3)");
    
    [partialMineGrid verify];
    
}

//     0   1   2   3
// 0 |   |   | 1 | o |
// 1 |   |   | 1 | 1 |
// 2 |   |   | 1 | 1 |
// 3 |   |   | 1 | o |

- (void)testValidate {
 
    NSUInteger columns = 4;
    NSUInteger rows = 4;
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:columns
                                                    columns:rows];
    XCTAssertNotNil(mineGrid, @"mineGrid should not be nil");
    
    id partialMineGrid = [OCMockObject partialMockForObject:mineGrid];
    
    VBOrderedPair *op1 = [[VBOrderedPair alloc] initWithX:3 y:0];
    VBOrderedPair *op3 = [[VBOrderedPair alloc] initWithX:3 y:3];
    
    NSSet *coordinates = [[NSSet alloc] initWithObjects:op1, op3, nil];
    
    [[[partialMineGrid expect] andReturn:coordinates] minesCoordinates:2];
    
    [mineGrid plantMines:2];
    
    XCTAssertFalse([mineGrid validateGrid], @"validateGrid should return false");
    
    VBOrderedPair *x0y0 = [[VBOrderedPair alloc] initWithX:0 y:0];
    [mineGrid revealFromCoordinate:x0y0];
    
    VBOrderedPair *x2y0 = [[VBOrderedPair alloc] initWithX:2 y:0];
    [mineGrid revealFromCoordinate:x2y0];
    
    VBOrderedPair *x2y1 = [[VBOrderedPair alloc] initWithX:2 y:1];
    [mineGrid revealFromCoordinate:x2y1];
    
    VBOrderedPair *x2y2 = [[VBOrderedPair alloc] initWithX:2 y:2];
    [mineGrid revealFromCoordinate:x2y2];
    
    VBOrderedPair *x2y3 = [[VBOrderedPair alloc] initWithX:2 y:3];
    [mineGrid revealFromCoordinate:x2y3];
    
    VBOrderedPair *x3y1 = [[VBOrderedPair alloc] initWithX:3 y:1];
    [mineGrid revealFromCoordinate:x3y1];
    
    VBOrderedPair *x3y2 = [[VBOrderedPair alloc] initWithX:3 y:2];
    [mineGrid revealFromCoordinate:x3y2];
    
    XCTAssertTrue([mineGrid validateGrid], @"validateGrid should return false");
    
    [partialMineGrid verify];
    
}

@end
