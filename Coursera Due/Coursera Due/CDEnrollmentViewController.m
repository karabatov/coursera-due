//
//  CDEnrollmentViewController.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 31.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDEnrollmentViewController.h"
#import "AFOAuth2Client/AFOAuth2Client.h"
#import "CDNetworkDataLoader.h"
#import "Enrollment.h"
#import "Topic.h"
#import "Course.h"
#import "Event.h"
#import "CDEnrollmentCell.h"
#import "UIImageView+AFNetworking.h"

@interface CDEnrollmentViewController ()

@end

@implementation CDEnrollmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CDEnrollmentCell *newCell = (CDEnrollmentCell *)cell;
    newCell.eventNameLabel.text = event.eventSummary;
    newCell.dueDateLabel.text = [event.endDate description];
    newCell.courseNameLabel.text = event.courseId.topicId.name;
    NSLog(@"event.isHardDeadline = %@", event.isHardDeadline);
    if (nil != event.isHardDeadline) {
        if (![event.isHardDeadline isEqual:@1]) {
            [newCell.deadlineTypeLabel setHidden:NO];
            newCell.deadlineTypeLabel.text = @"SOFT";
            newCell.deadlineTypeLabel.backgroundColor = [UIColor greenColor];
        } else {
            [newCell.deadlineTypeLabel setHidden:NO];
            newCell.deadlineTypeLabel.text = @"HARD";
            newCell.deadlineTypeLabel.backgroundColor = [UIColor redColor];
        }
    } else {
        [newCell.deadlineTypeLabel setHidden:YES];
    }
    [newCell.courseImage setImageWithURL:[NSURL URLWithString:event.courseId.topicId.largeIcon] placeholderImage:[UIImage imageNamed:@"coursera.png"]];
    NSLog(@"Cell textLabel: %@, Cell detailLabel: %@", newCell.eventNameLabel.text, newCell.dueDateLabel.text);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseCell";

    /*
     Use a default table view cell to display the event's title.
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CDEnrollmentCell *sizingCell;
    static CGFloat height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = (CDEnrollmentCell *)[tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
        // configure the cell
        sizingCell.eventNameLabel.text = @"Some very very very very very very very long name";
        sizingCell.courseNameLabel.text = @"Some very very very very very very very long name";
        sizingCell.dueDateLabel.text = @"Some very very very very very very very long name";

        // force layout
        [sizingCell setNeedsLayout];
        [sizingCell layoutIfNeeded];

        height = 0;

        height += sizingCell.eventNameLabel.bounds.size.height;
        height += sizingCell.courseNameLabel.bounds.size.height;
        height += sizingCell.dueDateLabel.bounds.size.height;
        height += 8;
    });

    //NSLog(@"Cell height = %f", height);

    return height;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)configureFetchedResultsController
{
    /*
     Set up the fetched results controller.
     */

    NSLog(@"In configureFetchedResultsController");

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType tracksChanges:YES];
    self.managedObjectContext = managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Sort using the startDate property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];

    // Filter
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(courseId != nil) && (endDate >= %@)", [[NSDate alloc] init]]];

    // Do not group results into sections
    NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

    return newController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
