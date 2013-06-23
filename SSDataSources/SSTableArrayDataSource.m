//
//  SSTableArrayDataSource.m
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"
#import <CoreData/CoreData.h>

@interface SSTableArrayDataSource ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SSTableArrayDataSource

@synthesize items;

- (instancetype)initWithItems:(NSArray *)anItems {
  
  if( ( self = [self init] ) ) {
    self.items = ( anItems
                   ? [NSMutableArray arrayWithArray:anItems]
                   : [NSMutableArray array] );
  }
  
  return self;
}

- (void)dealloc {
  self.items = nil;
}

#pragma mark - updating items

- (void)clearItems {
    [self.items removeAllObjects];
    
    [self.tableView reloadData];
}

- (void)removeAllItems {
    [self clearItems];
}

- (void)updateItems:(NSArray *)newItems {
    self.items = [NSMutableArray arrayWithArray:newItems];
    
    [self.tableView reloadData];
}

- (NSArray *)allItems {
    return self.items;
}

- (void)appendItems:(NSArray *)newItems {
    NSUInteger count = [self numberOfItems];
    
    [self.items addObjectsFromArray:newItems];
    
    if( self.tableView )
        [self.tableView insertRowsAtIndexPaths:[[self class] indexPathArrayWithRange:
                                                NSMakeRange(count, [newItems count])]
                              withRowAnimation:self.rowAnimation];
}

- (void)insertItems:(NSArray *)newItems atIndexes:(NSIndexSet *)indexes {    
    [self.items insertObjects:newItems atIndexes:indexes];
    
    if( self.tableView )
        [self.tableView insertRowsAtIndexPaths:[[self class] indexPathArrayWithIndexSet:indexes]
                              withRowAnimation:self.rowAnimation];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item {
    [self.items replaceObjectAtIndex:index withObject:item];

    if( self.tableView )
        [self.tableView reloadRowsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]
                              withRowAnimation:self.rowAnimation];
}

- (void)removeItemsInRange:(NSRange)range {    
    [self.items removeObjectsInRange:range];
    
    if( self.tableView )
        [self.tableView deleteRowsAtIndexPaths:[[self class] indexPathArrayWithRange:range]
                              withRowAnimation:self.rowAnimation];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
    
    if( self.tableView )
        [self.tableView deleteRowsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]
                              withRowAnimation:self.rowAnimation];
}

#pragma mark - item access

- (NSUInteger)numberOfItems {
  return [self.items count];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.row < (NSInteger)[self.items count] )
      return self.items[(NSUInteger)indexPath.row];
    
    return nil;
}

- (NSIndexPath *)indexPathForItem:(id)item {
  NSUInteger row = [self.items indexOfObjectIdenticalTo:item];
  
  if( row == NSNotFound )
    return nil;
  
  return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)itemId {
  NSUInteger row = [self.items indexOfObjectPassingTest:^BOOL( NSManagedObject *object,
                                                               NSUInteger index,
                                                               BOOL *stop ) {
    return [[object objectID] isEqual:itemId];
  }];
  
  if( row == NSNotFound )
    return nil;
  
  return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)[self.items count];
}

@end
