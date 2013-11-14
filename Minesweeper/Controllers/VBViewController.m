//
//  VBViewController.m
//  Minesweeper
//
//  Created by Ariel Rodriguez on 12/11/13.
//  Copyright (c) 2013 VolonBolon. All rights reserved.
//

#import "VBViewController.h"
#import "VBGridCell.h"
#import "VBMineGrid.h"
#import "VBGridContent.h"
#import "VBOrderedPair.h"

@interface VBViewController ()
@property (strong) VBMineGrid *mineGrid;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (getter = isCheating) BOOL cheat;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (void)configureNewGrid;
- (IBAction)configureNewGame:(id)sender;
- (IBAction)validateGame:(id)sender;
- (IBAction)enableCheat:(id)sender;
- (void)gridCellButtonTapped:(id)sender;
- (void)presentLostAlertView;
@end

@implementation VBViewController
- (void)configureNewGrid {
    
    VBMineGrid *mineGrid = [[VBMineGrid alloc] initWithRows:8
                                                    columns:8];
    
    [mineGrid plantMines:10];
    
    [self setMineGrid:mineGrid];
    
    [self setCheat:NO];
    
}

- (void)awakeFromNib {
    
    [self configureNewGrid];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 8;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"VBCollectionViewCell";
    
    VBGridCell *cell = (VBGridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                           forIndexPath:indexPath];
    
    
    VBGridContent *gc = [[self mineGrid] valueAtCoordinate:[VBOrderedPair orderedPairWithIndexPath:indexPath]];

    NSString *weightLabelText = nil;
    if ( [gc isMine] ) {
        
        weightLabelText = @"B";
        
    } else if ( [gc weight] > 0 ) {
        
        weightLabelText = [NSString stringWithFormat:@"%d", [gc weight]];
        
    }

    
    [[(VBGridCell *)cell weightLabel] setText:weightLabelText];

    if ( [gc isRevealed] ) {
        
        [[cell button] setHidden:YES];
        [[cell weightLabel] setHidden:NO];
        
    } else {
        
        if ( [self isCheating] ) {
            
            [[cell button] setTitle:weightLabelText
                           forState:UIControlStateNormal];
            
        }
        
        [[cell weightLabel] setHidden:YES];
        [[cell button] setHidden:NO];
        [[cell button] addTarget:self
                          action:@selector(gridCellButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
    
}

- (void)gridCellButtonTapped:(id)sender {
    
    UICollectionView *gridView = [self gridView];
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:[button bounds].origin
                                           toView:gridView];
    NSIndexPath *indexPath = [gridView indexPathForItemAtPoint:correctedPoint];
    
    VBOrderedPair *orderedPair = [VBOrderedPair orderedPairWithIndexPath:indexPath];
    NSSet *set = [[self mineGrid] revealFromCoordinate:orderedPair];
    
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] initWithCapacity:[set count]];
    for ( VBOrderedPair *op in set ) {
        
        @autoreleasepool {
            
            VBGridContent *gc = [[self mineGrid] valueAtCoordinate:op];
            [gc setRevealed:YES];
            
            if ( [gc isMine] ) {
                
                [self presentLostAlertView];
                
            }
            
            [indexPathsToReload addObject:[op indexPathFromOrderedPair]];
            
        }
        
    }
    
    [gridView reloadItemsAtIndexPaths:indexPathsToReload];
    
}

- (IBAction)configureNewGame:(id)sender {
    
    [self configureNewGrid];
    
    [[self gridView] reloadData];
    
}

- (IBAction)validateGame:(id)sender {
    
    if ( [[self mineGrid] validateGrid] ) {
        
        UIAlertView *validateAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You won!", nil)
                                                                    message:NSLocalizedString(@"You are a master!", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
        [validateAlertView show];
        
    } else {
        
        [self presentLostAlertView];
        
    }
    
}

- (IBAction)enableCheat:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to cheat", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"No, of course not", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Yupe, don't tell anyone", nil)
                                                    otherButtonTitles:nil];
    
    [actionSheet showFromToolbar:[self toolbar]];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex == [actionSheet destructiveButtonIndex] ) {
        
        [self setCheat:YES];
        NSSet *mines = [[self mineGrid] mines];
        
        NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] initWithCapacity:[mines count]];
        
        for ( VBGridContent *gc in mines ) {
            
            [indexPathsToReload addObject:[[gc orderedPair] indexPathFromOrderedPair]];
            
        }
        
        [[self gridView] reloadItemsAtIndexPaths:indexPathsToReload];
        
    }
    
}

#pragma  mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self configureNewGrid];
    [[self gridView] reloadData];
    
}

#pragma mark - Private

- (void)presentLostAlertView {
    
    UIAlertView *validateAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You Lost!", nil)
                                                                message:NSLocalizedString(@"Sorry", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
    [validateAlertView show];
    
}

@end
