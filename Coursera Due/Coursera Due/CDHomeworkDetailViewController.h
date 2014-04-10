//
//  CDHomeworkDetailViewController.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 10.04.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRLabel.h"

@interface CDHomeworkDetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet NRLabel *courseLabel;
@property (weak, nonatomic) IBOutlet NRLabel *homeworkLabel;
@property (weak, nonatomic) IBOutlet NRLabel *dueLabel;
@property (weak, nonatomic) IBOutlet NRLabel *dateLabel;
@property (weak, nonatomic) IBOutlet NRLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;

@property (nonatomic) NSString *courseName;
@property (nonatomic) NSString *homeworkName;
@property (nonatomic) BOOL isHardDeadline;
@property (nonatomic) NSString *dueDate;
@property (nonatomic) NSString *dueTime;
@property (nonatomic) NSString *homeworkDescription;

@end