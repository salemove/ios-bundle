#import "ViewController.h"
#import "ios_sdk_widgets_objc/ios_sdk_widgets_objc.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UITextField *siteIdTextField;
@property(nonatomic, weak) IBOutlet UITextField *siteApiKeyIdTextField;
@property(nonatomic, weak) IBOutlet UITextField *siteApiKeySecretTextField;
@property(nonatomic, weak) IBOutlet UITextField *queueIdTextField;

@property(nonatomic, weak) IBOutlet UIButton *configureSdkButton;
@property(nonatomic, weak) IBOutlet UIButton *startChatEngagementButton;

@end

@implementation ViewController {
    BOOL isSDKConfigured;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {

    [self.startChatEngagementButton setEnabled: false];

    UITapGestureRecognizer *hideKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:hideKeyboardGesture];
    isSDKConfigured = false;

    [self updateUi];
}

- (void)updateUi {
    if (isSDKConfigured) {
        [self.siteIdTextField setEnabled: false];
        [self.siteApiKeyIdTextField setEnabled: false];
        [self.siteApiKeySecretTextField setEnabled: false];
        [self.queueIdTextField setEnabled: false];
        [self.configureSdkButton setEnabled: false];
        [self.startChatEngagementButton setEnabled:true];
    } else {
        BOOL isEnabled = ![self.siteIdTextField.text isEqualToString: @""] &&  ![self.siteApiKeyIdTextField.text isEqualToString: @""] &&
        ![self.siteApiKeySecretTextField.text isEqualToString:@""] && ![self.queueIdTextField.text isEqualToString: @""];
        [[self configureSdkButton] setEnabled: isEnabled];
        [self.startChatEngagementButton setEnabled:false];
    }
}

- (void)hideKeyboard {
    [self.view endEditing: true];
}

@end

@implementation ViewController(UITextFieldDelegate)

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateUi];
}

@end

// MARK: - GliaWidgetsSDK interaction

@implementation ViewController(GliaWidgetsSDK)

- (IBAction)configureButtonTap:(UIButton *)sender {
    NSError *executionError;
    [[GliaWidgetsWrapper sharedInstance] configureWithEnv:GliaWidgetsEnvironmentBeta
                                                   siteId:self.siteIdTextField.text
                                               siteApiKey:self.siteApiKeyIdTextField.text
                                         siteApiKeySecret:self.siteApiKeySecretTextField.text
                                                    error:&executionError
                                               onComplete:^(NSError * error) {

        NSString *errorMessage = error == nil ? @"" : [NSString stringWithFormat:@" Error: %@", error];
        NSLog(@"SDK configuration is finished.%@", errorMessage);
        self->isSDKConfigured = error == nil;
        [self updateUi];
    }];

    NSLog(@"Execution error='%@'.", executionError);
}

- (IBAction)startChatEngagementTap:(UIButton *)sender {
    NSError *executionError;
    [[GliaWidgetsWrapper sharedInstance] startEngagementWithKind:GliaWidgetsEngagementKindText
                                                         queueId:[self.queueIdTextField text]
                                                           error:&executionError];
    NSLog(@"Execution error='%@'.", executionError);
}

@end
