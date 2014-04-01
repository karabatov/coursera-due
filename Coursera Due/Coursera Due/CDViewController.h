//
//  CDViewController.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 22.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@interface CDViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)subscribeToManagedObjectContextNotifications;
- (void)refreshManagedObjectContext:(NSNotification *)notification;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;

// Methods to override:
// - (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
// - (NSFetchedResultsController *)configureFetchedResultsController

@end