//
//  ChangePwdViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/19/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ChangePwdViewController : UIViewController{
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (nonatomic, assign,readwrite) int userID;
@property (retain, nonatomic) IBOutlet UITextField *oldPwdField;
@property (retain, nonatomic) IBOutlet UITextField *pwdNewField;

@property (retain, nonatomic) IBOutlet UITextField *retypeNewPwdField;

@property (nonatomic, copy) NSString *passwordDB;
@property (retain, nonatomic) IBOutlet UILabel *msgLabel;

- (IBAction)doCancelChange:(id)sender;
- (IBAction)changePwdBtnPressed:(id)sender;


@end
