//
//  ProfilesDetailsViewController.h
//  UserLogin2
//
//  Created by Md. Nazmus Saadat on 7/13/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SecurityQuesTbViewController.h"

@interface ProfilesDetailsViewController : UIViewController <UITextFieldDelegate,SecurityQuesTbViewControllerDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *popOverConroller;
    BOOL selectOne;
    BOOL selectTwo;
    BOOL selectThree;
}

@property (nonatomic, assign,readwrite) int userID;

@property (retain, nonatomic) IBOutlet UITextField *oldPwdField;
@property (retain, nonatomic) IBOutlet UITextField *changePwdField;
@property (retain, nonatomic) IBOutlet UITextField *retypePwdField;

@property (retain, nonatomic) IBOutlet UITextField *agentCodeField;
@property (retain, nonatomic) IBOutlet UITextField *agentNameField;
@property (retain, nonatomic) IBOutlet UITextField *cntcNoField;
@property (retain, nonatomic) IBOutlet UITextField *leaderCodeField;
@property (retain, nonatomic) IBOutlet UITextField *leaderNameField;
@property (retain, nonatomic) IBOutlet UITextField *registrationNoField;
@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@property (retain, nonatomic) IBOutlet UILabel *QOneLabel;
@property (retain, nonatomic) IBOutlet UILabel *QTwoLabel;
@property (retain, nonatomic) IBOutlet UILabel *QThreeLabel;
@property (retain, nonatomic) IBOutlet UITextField *ansOneField;
@property (retain, nonatomic) IBOutlet UITextField *ansTwoField;
@property (retain, nonatomic) IBOutlet UITextField *ansThreeField;


//from popover
@property (nonatomic,copy) NSString *questOneCode;
@property (nonatomic,copy) NSString *questTwoCode;
@property (nonatomic,copy) NSString *questThreeCode;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)doSave:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong) UIPopoverController *popOverConroller;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
