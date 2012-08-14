//
//  ViewController.h
//  UserLogin2
//
//  Created by Md. Nazmus Saadat on 7/13/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController <UITextFieldDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
}

@property (nonatomic, assign) int statusLogin;
@property (nonatomic, assign) int indexNo;
@property (nonatomic, copy) NSString *agentID;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
@property (retain, nonatomic) IBOutlet UILabel *forgotPwdLabel;

- (IBAction)doLogin:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
