//
//  ViewController.m
//  SCBlueToothKit
//
//  Created by 叔 陈 on 16/3/9.
//  Copyright © 2016年 叔 陈. All rights reserved.
//

#import "ViewController.h"
#import "BTManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (weak, nonatomic) IBOutlet UIButton *startSendingButton;
@property (weak, nonatomic) IBOutlet UIButton *startReceivingButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logTextView.text = @"Initializing...";
    self.logTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonPressed:(id)sender {
    NSString *t_message = [NSString stringWithFormat:@"%@ - %f",@"This is a test message",[NSDate timeIntervalSinceReferenceDate]];
    _logTextView.text = [NSString stringWithFormat:@"%@\nSending: %@",self.logTextView.text,t_message];
    [_logTextView scrollRectToVisible:CGRectMake(0.0f, self.logTextView.contentSize.height - 1.0f, 1.0f, 1.0f) animated:YES];
    
    [[BTManager sharedInstance] setDataToSend:[t_message dataUsingEncoding:NSUTF8StringEncoding]];
    [[BTManager sharedInstance] sendData];
}

- (IBAction)receivingButtonPressed:(id)sender {
    if([[BTManager sharedInstance] isReceivingOrScanning]) {
        [self.startReceivingButton setTitle:@"Start Receiving" forState:UIControlStateNormal];
        self.logTextView.text = @"End receiving packet...";
        [[BTManager sharedInstance] stopScanning];
    } else {
        [self.startReceivingButton setTitle:@"End Receiving" forState:UIControlStateNormal];
        self.logTextView.text = @"Ready to receive packet...";
        [[BTManager sharedInstance] startCentralServiceWithCallBack:^(NSData *receivedData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _logTextView.text = [NSString stringWithFormat:@"%@\nReceive: %@",self.logTextView.text,[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]];
                [_logTextView scrollRectToVisible:CGRectMake(0.0f, self.logTextView.contentSize.height - 1.0f, 1.0f, 1.0f) animated:YES];
            });
        }];
    }
}

- (IBAction)sendingButtonPressed:(id)sender {
    if([[BTManager sharedInstance] isReceivingOrScanning]) {
        [self.startSendingButton setTitle:@"Start Sending" forState:UIControlStateNormal];
        self.logTextView.text = @"End sending packet...";
        [[BTManager sharedInstance] stopAdvertising];
    } else {
        [self.startSendingButton setTitle:@"End Sending" forState:UIControlStateNormal];
        self.logTextView.text = @"Ready to send packet...";
        [[BTManager sharedInstance] startPeripheralService];
    }
}

@end
