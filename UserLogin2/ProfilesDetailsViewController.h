//
//  ProfilesDetailsViewController.h
//  UserLogin2
//
//  Created by Md. Nazmus Saadat on 7/13/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ProfilesDetailsViewController : UIViewController <UITextFieldDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
}

@property (nonatomic, assign,readwrite) int userID;

@property (retain, nonatomic) IBOutlet UITextField *oldPwdField;
@property (retain, nonatomic) IBOutlet UITextField *changePwdField;
@property (retain, nonatomic) IBOutlet UITextField *retypePwdField;

@property (retain, nonatomic) IBOutlet UITextField *agentCodeField;
@property (retain, nonatomic) IBOutlet UITextField *agentNameField;
@property (retain, nonatomic) IBOutlet UITextField *agentTypeField;
@property (retain, nonatomic) IBOutlet UITextField *cntcNoField;
@property (retain, nonatomic) IBOutlet UITextField *leaderCodeField;
@property (retain, nonatomic) IBOutlet UITextField *leaderNameField;
@property (retain, nonatomic) IBOutlet UITextField *registrationNoField;
@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;



- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)doSave:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
