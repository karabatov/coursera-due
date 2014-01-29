//
//  CDEnrollmentCell.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 29.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@import UIKit;

@interface CDEnrollmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;

@end
