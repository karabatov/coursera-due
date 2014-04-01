//
//  CDCourseViewController.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 31.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDCourseViewController.h"
#import "AFOAuth2Client/AFOAuth2Client.h"
#import "CDNetworkDataLoader.h"
#import "Enrollment.h"
#import "Topic.h"
#import "Course.h"
#import "Event.h"
#import "CDEnrollmentCell.h"
#import "UIImageView+AFNetworking.h"

@interface CDCourseViewController ()

@end

@implementation CDCourseViewController

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
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CDEnrollmentCell *newCell = (CDEnrollmentCell *)cell;
    newCell.eventNameLabel.text = course.topicId.name;
    newCell.courseNameLabel.text = [NSString stringWithFormat:@"End date: %@", [self.dateFormatter stringFromDate:course.sessionId.endDate]];

    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(endDate >= %@) && (endDate <= %@)", [NSDate new], course.sessionId.endDate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    NSSet *filteredSet = [course.eventId filteredSetUsingPredicate:filterPredicate];
    NSDate *endDate = [[[filteredSet sortedArrayUsingDescriptors:@[sortDescriptor]] firstObject] valueForKey:@"endDate"];
    if (endDate != nil) {
        newCell.dueDateLabel.text = [NSString stringWithFormat:@"Due %@", [self.dateFormatter stringFromDate:endDate]];
    } else {
        newCell.dueDateLabel.text = @"Yay, nothing due!";
    }

    [newCell.courseImage setImageWithURL:[NSURL URLWithString:course.topicId.largeIcon] placeholderImage:[UIImage imageNamed:@"coursera.png"]];
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
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType tracksChanges:YES];
    self.managedObjectContext = managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Sort using the endDate property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"topicId.name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // Filter
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(sessionId != nil) && (sessionId.endDate >= %@) && (sessionId.startStatus == %@)", [[NSDate alloc] init], @"Present"]];

    // Do not group results into sections
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
