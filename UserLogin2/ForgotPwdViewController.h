//
//  ForgotPwdViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/17/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RetreivePwdTbViewController.h"

@interface ForgotPwdViewController : UIViewController <RetreivePwdTbViewControllerDelegate> {
    UIPopoverController *popOverConroller;
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (nonatomic,strong) UIPopoverController *popOverConroller;
@property (retain, nonatomic) IBOutlet UILabel *questLabel;
@property (retain, nonatomic) IBOutlet UITextField *ansField;
@property (retain, nonatomic) IBOutlet UILabel *statusLabelOne;
@property (retain, nonatomic) IBOutlet UILabel *statusLabelTwo;


//from popover
@property (nonatomic,copy) NSString *questCode;
@property (nonatomic,copy) NSString *questDesc;
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *password;

- (IBAction)doCancelForgot:(id)sender;
- (IBAction)doRetrieve:(id)sender;

@end
