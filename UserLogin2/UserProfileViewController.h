//
//  UserProfileViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface UserProfileViewController : UIViewController <UITextFieldDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
}

@property (nonatomic,strong) id idRequest;
@property (nonatomic, assign) int indexNo;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;

//input field
@property (retain, nonatomic) IBOutlet UITextField *agentCodeField;
@property (retain, nonatomic) IBOutlet UITextField *agentNameField;
@property (retain, nonatomic) IBOutlet UITextField *agentTypeField;
@property (retain, nonatomic) IBOutlet UITextField *contactNoField;
@property (retain, nonatomic) IBOutlet UITextField *leaderCodeField;
@property (retain, nonatomic) IBOutlet UITextField *leaderNameField;
@property (retain, nonatomic) IBOutlet UITextField *registerNoField;
@property (retain, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)doCancel:(id)sender;
- (IBAction)doSaveEdit:(id)sender;

//declare output from db
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *contactNo;
@property (nonatomic, copy) NSString *leaderCode;
@property (nonatomic, copy) NSString *leaderName;
@property (nonatomic, copy) NSString *registerNo;
@property (nonatomic, copy) NSString *email;

@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *loginIDLabel;


@end
