//
//  CDHomeworkDetailViewController.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 10.04.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDHomeworkDetailViewController.h"

@interface CDHomeworkDetailViewController ()

@end

@implementation CDHomeworkDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.courseLabel.text = self.courseName;
    self.homeworkLabel.text = self.homeworkName;
    if ((nil != self.isHardDeadline) && ([self.isHardDeadline isEqualToNumber:@1])) {
        self.dueLabel.text = @"DEADLINE";
        self.dueLabel.textColor = [UIColor whiteColor];
        self.dueLabel.backgroundColor = [UIColor lightGrayColor];
        self.dueLabel.layer.borderWidth = 0.0f;
    } else {
        self.dueLabel.text = @"DUE";
        self.dueLabel.textColor = [UIColor lightGrayColor];
        self.dueLabel.backgroundColor = [UIColor clearColor];
        self.dueLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.dueLabel.layer.borderWidth = 0.25f;
    }
    self.descriptionText.text = self.homeworkDescription;
    [self.descriptionText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.courseImage setImageWithURL:[NSURL URLWithString:self.courseImageURL] placeholderImage:[UIImage imageNamed:@"coursera-large.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            self.courseLabel.text = self.courseName;
            self.homeworkLabel.text = self.homeworkName;
            [self.courseLabel setNeedsLayout];
            [self.courseLabel layoutIfNeeded];
            height += [self.courseLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            [self.homeworkLabel setNeedsLayout];
            [self.homeworkLabel layoutIfNeeded];
            height += [self.homeworkLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            height += 30+20+8+20+30;
            break;
        case 1:
            self.dateLabel.text = self.dueDate;
            [self.dateLabel setNeedsLayout];
            [self.dateLabel layoutIfNeeded];
            height += [self.dateLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            self.timeLabel.text = self.dueTime;
            [self.timeLabel setNeedsLayout];
            [self.timeLabel layoutIfNeeded];
            height += [self.timeLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            height += 15+4+15;
            break;
        case 2:
            height += [self.descriptionText sizeThatFits:CGSizeMake(self.descriptionText.frame.size.width,CGFLOAT_MAX)].height;
            height += 4+4;
            break;
        default:
            break;
    }

    NSLog(@"height = %1.0f", height);
    return height;
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
