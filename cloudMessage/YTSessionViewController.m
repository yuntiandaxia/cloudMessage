//
//  sessionViewController.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/25.
//  Copyright © 2016年 iMac mini. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "YTSessionViewController.h"
//#import "YTChatTextCell.h"
#import "YTChatBaseCell.h"
#import "YTChatMessage.h"
#import "YTToolBarView.h"
#import "YTRecordIndicatorView.h"
#import "YTAudioRecorder.h"
#import "YTAudioPlayer.h"
#import "YTVideoViewController.h"
#import "YTShareMoreView.h"

@interface YTSessionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,AudioRecorderDelegate>

@property (nonatomic,strong) UITableView   *chatTableView;
@property (nonatomic,strong) YTToolBarView *toolBarView;
@property (nonatomic,strong) YTRecordIndicatorView *recordIndicatorView; //录音时动画
@property (nonatomic,strong) YTAudioRecorder       *iRecorder;           //开始录音
@property (nonatomic,strong) YTAudioPlayer         *voicePlay;

@property (nonatomic,strong) YTVideoViewController *videoController;     //播放视频使用。

@property (nonatomic,strong) YTShareMoreView       *shareMoreView;

@end


@implementation YTSessionViewController

#define listCount 6

static NSString *identify = @"YTChatTableViewCell";

CGFloat toolBarMinHeight = 44.0;
CGFloat indicatorViewH   = 120;

NSLayoutConstraint *toolBarConstraint;

//初始化一个数组
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

//soundID
SystemSoundID soundID;

-(void)setupMessage:(NSInteger)count{
    NSArray *randomMessage;
    randomMessage = @[@"你好，很高兴认识你",
                      @"古庙依青嶂，行宫枕碧流。水声山色锁妆楼。往事思悠悠。云雨朝还暮，烟花春复秋。啼猿何必近孤舟。行客自多愁",
                      @"黄河西来决昆仑，咆哮万里触龙门。波滔天，尧咨嗟。大禹理百川，儿啼不窥家。杀湍湮洪水，九州始蚕麻。其害乃去，茫然风沙。被发之叟狂而痴，清晨临流欲奚为。旁人不惜妻止之，公无渡河苦渡之。虎可搏，河难凭，公果溺死流海湄。有长鲸白齿若雪山，公乎公乎挂罥于其间。箜篌所悲竟",
                      @"浊波浩浩东倾，今来古往无终极。经天亘地，滔滔流出，昆仑东北。神浪狂飙，奔腾触裂，轰雷沃日。看中原形胜，千年王气。雄壮势、隆今昔。鼓茫茫万里，棹歌声、响凝空碧。壮游汗漫，山川绵邈，飘飘吟迹。我欲乘槎，直穷银汉，问津深入。唤君平一笑，谁夸汉客，取支机石。",
                      @"黄河九天上，人鬼瞰重关。长风怒卷高浪，飞洒日光寒。峻似吕梁千仞，壮似钱塘八月，直下洗尘寰。万象入横溃，依旧一峰闲。仰危巢，双鹄过，杳难攀。人间此险何用，万古袐神奸。不用燃犀下照，未必佽飞强射，有力障狂澜。唤取骑鲸客，挝鼓过银山。",
                      @"测试",
                      @"春江潮水连海平，海上明月共潮生。滟滟随波千万里，何处春江无月明!江流宛转绕芳甸，月照花林皆似霰;空里流霜不觉飞，汀上白沙看不见。江天一色无纤尘，皎皎空中孤月轮。江畔何人初见月？江月何年初照人？人生代代无穷已，江月年年望相似。(望相似 一作：只相似)不知江月待何",
                      @"\n"];
    
    for (int i=0; i<count; i++) {
        YTChatMessage *messageList = [YTChatMessage new];
        messageList.messageType  = arc4random_uniform(2); //随机数吗？//YTMessageMediaTypePhoto;
        messageList.messageModel = arc4random_uniform(2);
        messageList.timestamp     = [NSDate new];
        if (messageList.messageModel) {
            messageList.iconName = [UIImage imageNamed:@"0.jpg"];
        }else{
            messageList.iconName = [UIImage imageNamed:@"1.jpg"];//[NSString stringWithFormat:@"1.jpg"];
        }
        messageList.strText      = randomMessage[i];
        //NSLog(@"%@",messageList.strText);
        NSString *name = [[NSString alloc] initWithFormat:@"%d.jpg",rand()%23];
        messageList.photoMessage = [UIImage imageNamed:name];
        messageList.voicePath    = nil;
        messageList.videoPath    = nil;
        messageList.emotionPath  = nil;
        
        messageList.shouldShowTimestamp = arc4random_uniform(2);
        messageList.isSendSuccess       = arc4random_uniform(2);
        
        [self.dataArray addObject:messageList];
    }
    YTChatMessage *messageList = [YTChatMessage new];
    messageList.messageType  = YTMessageMediaTypeVideo;
    messageList.messageModel = arc4random_uniform(2);
    if (messageList.messageModel) {
        messageList.iconName = [UIImage imageNamed:@"0.jpg"];
    }else{
        messageList.iconName = [UIImage imageNamed:@"1.jpg"];//[NSString stringWithFormat:@"1.jpg"];
    }
    //先获取沙盒中得路径。
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"test.m4v"];
//    NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
    
    //NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"m4v"]];
    //NSLog(@"video.url=%@",fileURL);
    //messageList.videoUrl = fileURL; //[NSURL URLWithString:fileURL];
    messageList.videoUrl = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
    [self.dataArray addObject:messageList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"云天科技";
    
    [self setupMessage:listCount];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect rect = self.view.frame;
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-toolBarMinHeight) style:UITableViewStylePlain];
    [self.chatTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.chatTableView setDelegate:self];
    [self.chatTableView setDataSource:self];
    [self.chatTableView setContentInset:UIEdgeInsetsMake(0, 0, toolBarMinHeight/2, 0)];
    [self.chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.chatTableView setAllowsSelectionDuringEditing:true];
    [self.view addSubview:self.chatTableView];
    
    //关键两句？
    //self.chatTableView.rowHeight          = UITableViewAutomaticDimension;
    //self.chatTableView.estimatedRowHeight = 44.0;
    
    //对chatTableView加上文本、图片、音频、视频等属性。
    [self.chatTableView registerClass:[YTChatBaseCell class] forCellReuseIdentifier:NSStringFromClass(YTChatBaseCell.self)];
    
    //添加音频输入时候的动画,先不显示
    self.recordIndicatorView = [[YTRecordIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x-indicatorViewH/2, self.view.center.y-indicatorViewH/3, indicatorViewH, indicatorViewH)];
    
    //添加表情
    
    
    //添加更多
    //self.shareMoreView = [[YTShareMoreView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 196)];
    self.shareMoreView = [[YTShareMoreView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 196) target:self action:@selector(shareMoreViewClick:)];
    
    //底部输入栏,设置语音按钮、录音按钮动作以及输入代理
    self.toolBarView = [[YTToolBarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-toolBarMinHeight, self.view.frame.size.width, toolBarMinHeight)];
    
    [self.toolBarView.voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置录音过程。
    [self.toolBarView.recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchDown];//UIControlEventTouchUpInside
    
    //UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
   //[self.toolBarView.recordButton addGestureRecognizer:presss];
    [self.toolBarView.textView setDelegate:self];
    [self.view addSubview:self.toolBarView];
    
    //点击表情按钮动作。
    [self.toolBarView.emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //点击更多按钮动作。
    [self.toolBarView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加键盘
    //[[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil];
    NSNotificationCenter *keyBoard = [NSNotificationCenter defaultCenter];
    //[keyBoard addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [keyBoard addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //[keyBoard addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击键盘消失
    [self.chatTableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)]];
}

-(void)viewDidDisappear{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

-(void)keyboardWillShow:(NSNotification *)info{
    NSDictionary *dict    = info.userInfo;
    CGRect keyboardBounds = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGRect keyboardBounds = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    double duration       = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //坐标系转换
    CGRect keyboardBoundsRect = [self.view convertRect:keyboardBounds toView:nil];
    //得到键盘高度
    double offsetY = keyboardBoundsRect.size.height;
    //得到键盘动画曲线信息
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16;
    if (offsetY == [[UIScreen mainScreen] bounds].size.height) {
        [UIView animateWithDuration:duration delay:0 options:options animations:^{ self.view.transform = CGAffineTransformMakeTranslation(0, 0);} completion:nil];
    }else{
    //添加动画
        [UIView animateWithDuration:duration delay:0 options:options animations:^{self.view.transform = CGAffineTransformMakeTranslation(0, -offsetY);} completion:nil];
    }
    //NSLog(@"显示键盘！");
}

-(void)keyboardWillHide:(NSNotification *)info{
    NSDictionary *dict = info.userInfo;
    double duration    = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16;
    //CGAffineTransformIdentity是置位，可将改变的transform还原
    [UIView animateWithDuration:duration delay:0 options:options animations:^{ self.view.transform = CGAffineTransformIdentity; } completion:nil];
    NSLog(@"隐藏键盘！");
}

//
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y > 2.0) {
        [self.toolBarView.textView becomeFirstResponder];
    }else if (velocity.y < -0.1 ){
        [self.toolBarView.textView resignFirstResponder];
    }
}
/*
 * 功能：点击view区域，键盘消失。必须加上动作参数。
 */
-(void)tapToClose:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:true];
    [self.toolBarView resignFirstResponder];
}

-(void)scrollToBottom{
    NSInteger numberOfRows = [self.chatTableView numberOfRowsInSection:0];
    if (numberOfRows > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

-(void)reloadChatTableView{
    NSInteger count = self.dataArray.count;
    //NSLog(@"%@",self.dataArray);
    NSMutableArray *indexPaths = [NSMutableArray array];
    //for (int i=0; i<count; i++) {
    [indexPaths addObject:[NSIndexPath indexPathForRow:count-1 inSection:0]];
    //}
    [self.chatTableView beginUpdates];
    [self.chatTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.chatTableView endUpdates];
    [self scrollToBottom];
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text  isEqualToString: @"\n"]) {
        
        NSString *str = [self.toolBarView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([str lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
            return true;
        }
        
        YTChatMessage *messageNew = [YTChatMessage new];
        messageNew.strText = str;
        messageNew.messageModel = YTMessageSendToOthers;
        messageNew.iconName = [UIImage imageNamed:@"1"];
        [self.dataArray addObject:messageNew];
        
        [self reloadChatTableView];
        
        //播放声音
        [self getSendSoundID];
        AudioServicesPlayAlertSound(soundID);
        //清空内容
        self.toolBarView.textView.text = @"";
        //关闭键盘
        [self.view endEditing:true];
        //[self.toolBarView resignFirstResponder];
    }
    return true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTChatBaseCell *cell = [YTChatBaseCell new];
    return [cell getMessageHeight:self.dataArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //YTChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    YTChatBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[YTChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //[self.tableView registerClass:[YTChatTextCell self] forCellReuseIdentifier:identifier_new];
    }
    //设置数据
    [cell setMessage:self.dataArray[indexPath.row]];
    
    //去掉点击cell变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //双击或者长按显示复制、转发菜单
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuAction:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [cell.backgroundImageView addGestureRecognizer:doubleTapGesture];
    [cell.backgroundImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuAction:)]];
    
    //点击cell则播放语音、音频、视频等
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCellAction:)];
    [tapGesture setNumberOfTapsRequired:1];
    [cell.backgroundImageView addGestureRecognizer:tapGesture];
    return cell;
}


// 用于UIMenuController显示，缺一不可
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)showMenuAction:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    [self becomeFirstResponder]; //必须添加上，否则不显示
    
    BOOL twoTaps   = (tapGestureRecognizer.numberOfTapsRequired == 2);
    BOOL doubleTap = (twoTaps  && tapGestureRecognizer.state == UIGestureRecognizerStateEnded);
    BOOL longPress = (!twoTaps && tapGestureRecognizer.state == UIGestureRecognizerStateBegan);
    
    if (doubleTap || longPress)
    {
        //选中当前cell
        NSIndexPath *pressIndexPath = [self.chatTableView indexPathForRowAtPoint:[tapGestureRecognizer locationInView:self.chatTableView]];
        [self.chatTableView selectRowAtIndexPath:pressIndexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        //绘制MenuController
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIView *localImageView = [tapGestureRecognizer view];
        
        [menuController setTargetRect:localImageView.frame inView:localImageView.superview];
        UIMenuItem *menuItem01 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        UIMenuItem *menuItem02 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transtionAction:)];
        UIMenuItem *menuItem03 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction:)];
        UIMenuItem *menuItem04 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(moreAction:)];
        UIMenuItem *menuItem05 = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(moreAction:)];
        
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem01,menuItem02,menuItem03,menuItem04,menuItem05, nil]];
        [menuController setMenuVisible:true animated:true];
    }
}

-(void)copyAction:(UIMenuController *)menuController{
    NSIndexPath *selectedIndexPath = self.chatTableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        YTChatMessage *msg = [YTChatMessage new];
        msg = self.dataArray[selectedIndexPath.row];
        [UIPasteboard generalPasteboard].string = msg.strText;
    }
}

-(void)clickCellAction:(UITapGestureRecognizer *)tapGesture{
    BOOL taps = (tapGesture.numberOfTapsRequired == 1);
    BOOL singleTap = (taps && tapGesture.state == UIGestureRecognizerStateEnded);
    
    if (singleTap)
    {
        //手势选中当前cell
        NSIndexPath *pressIndexPath = [self.chatTableView indexPathForRowAtPoint:[tapGesture locationInView:self.chatTableView]];
        YTChatBaseCell *pressCell = [self.chatTableView cellForRowAtIndexPath:pressIndexPath];
        
        YTChatMessage *msg = self.dataArray[pressIndexPath.row];
        
        if (msg.messageType == YTMessageMediaTypeVoice) {
            
            self.voicePlay = [[YTAudioPlayer alloc] init];
            [pressCell beginAnimation];
            [self.voicePlay startPlaying:msg];
            //[pressCell setSelected:YES animated:true];
            
            //GCD延迟操作。
            dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)msg.voiceDuration.integerValue*NSEC_PER_SEC);
            dispatch_after(when, dispatch_get_main_queue(), ^(void){
                [pressCell stopAnimation];
            });
        }else if (msg.messageType == YTMessageMediaTypeVideo) {
            //NSLog(@"播放了视频！");
            if(self.videoController != nil){
                self.videoController = nil;
            }
            self.videoController = [[YTVideoViewController alloc] initWithVideoUrl:msg.videoUrl];
            //[self.videoController setPlayUrl:msg.videoUrl];
            //[self.navigationController pushViewController:self.videoController animated:YES];
            [self presentViewController:self.videoController animated:YES completion:nil];
        }
    }
}

//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    BOOL bol;
//    if (self.chatTableView.indexPathForSelectedRow == nil) {
//        bol = (action == @selector(copyAction:));
//        return bol;
//    }else{
//        bol = [super canPerformAction:action withSender:sender];
//        return bol;
//    }
//}

-(void)transtionAction:(UIMenuController *)menuController{
    NSLog(@"This is a transform");
}

-(void)deleteAction:(UIMenuController *)menuController{
    NSIndexPath *selectedIndexPath = self.chatTableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        [self.dataArray removeObjectAtIndex:selectedIndexPath.row];
        [self.chatTableView reloadData];
    }
}

-(void)moreAction:(UIMenuController *)menuController{
    NSLog(@"This is a More");
}


/**
 * MARK: 各种动作的编写,包括声音按钮出现录音按钮条、点击表情按钮出现表情包、点击更多按钮出现更多功能。
 *
 */
-(void)voiceButtonClick:(UIButton *)button{
    if (self.toolBarView.recordButton.hidden == false) {
        [self.toolBarView showRecordButton:false];
    }else{
        [self.toolBarView showRecordButton:true];
        [self.toolBarView becomeFirstResponder];
        [self.view endEditing:true];
    }
}

/**
 * MARK:-点击recordButton后的事件，这里不能直接点击应该？
 */
-(void)recordButtonClick:(UIButton *)button{
    [button setTitle:@"松开  结束" forState:UIControlStateNormal];//UIControlStateHighlighted
    
    [button addTarget:self action:@selector(recordCompletion:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(recordDragOut:) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    
    self.recordIndicatorView = [[YTRecordIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x-indicatorViewH/2, self.view.center.y-indicatorViewH/3, indicatorViewH, indicatorViewH)];
    //[self.recordIndicatorView updateLevelMetra:rand()%8];
    [self.view addSubview:self.recordIndicatorView];
    
    //开始录音
    double currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSString *path = [NSString stringWithFormat:@"%f.wav",currentTime];
    YTAudioRecorder *record = [[YTAudioRecorder alloc] initWithPath:path];
    self.iRecorder = record;
    [self.iRecorder startRecord:self.recordIndicatorView];
}

-(void)recordCompletion:(UIButton *)button{
    [button setTitle:@"按住  说话" forState:UIControlStateNormal];
    //停止录音
    [self.iRecorder stopRecord];
    
    //取消动画
    [self.recordIndicatorView removeFromSuperview];
    self.recordIndicatorView = nil;
    
    if (self.iRecorder.timeInterval != nil) {
        YTChatMessage *messageVoice = [YTChatMessage new];
        messageVoice.messageModel  = YTMessageSendToOthers;
        messageVoice.messageType   = YTMessageMediaTypeVoice;
        messageVoice.voiceUrl      = [self.iRecorder recorder].url;
        messageVoice.voiceDuration = [self.iRecorder timeInterval];
        //NSLog(@"%@",messageVoice.voiceDuration);
        messageVoice.iconName      = [UIImage imageNamed:@"1"];
        
        [self.dataArray addObject:messageVoice];
        [self reloadChatTableView];
        
        //播放声音
        [self getSendSoundID];
        AudioServicesPlayAlertSound(soundID);
    }
}

-(void)recordDragOut:(UIButton *)button{
    [button setTitle:@"按住  说话" forState:UIControlStateNormal];
    [self.recordIndicatorView showText:@"松开手指，取消发送" textColor:[UIColor redColor]];
}

-(void)recordCancel:(UIButton *)button{
    [button setTitle:@"按住  说话" forState:UIControlStateNormal];
    //停止录音
    [self.iRecorder stopRecord];
    
    //取消动画
    [self.recordIndicatorView removeFromSuperview];
    self.recordIndicatorView = nil;
}

//点击表情按钮。
-(void)emotionButtonClick:(UIButton *)button{
    //NSLog(@"点击了表情按钮");
    if (self.toolBarView.emotionButton.tag == 1) {
        [self.toolBarView showEmotion:YES];
        //self.toolBarView.textView.inputView = self.emojiView;
    }else{
        [self.toolBarView showEmotion:NO];
        self.toolBarView.textView.inputView = nil;
    }
    [self.toolBarView.textView becomeFirstResponder];
    [self.toolBarView.textView reloadInputViews];
}

//点击更多按钮。
-(void)moreButtonClick:(UIButton *)button{
    if (self.toolBarView.moreButton.tag == 2) {
        [self.toolBarView showMore:YES];
        self.toolBarView.textView.inputView = self.shareMoreView;
    }else{
        [self.toolBarView showMore:NO];
        self.toolBarView.textView.inputView = nil;
    }
    [self.toolBarView.textView becomeFirstResponder];
    [self.toolBarView.textView reloadInputViews];
}

-(void)shareMoreViewClick:(UIButton *)button{
    //YTMoreButtonType btnType = button.tag;
    if (button.tag == 1) {
        NSLog(@"this is 111");
    }else if(button.tag == 2){
        NSLog(@"this is 222");
    }else if(button.tag == 3){
        NSLog(@"this is 333");
    }else if(button.tag == 4){
        NSLog(@"this is 444");
    }else{
        NSLog(@"this is test!");
    }
}


//MARK:-AudioRecorderDelegate    //注释掉的原因是没有搞懂参数传递和代理协议的区别。
//-(void)audioRecorderUpdateMetra:(float)metra{
//    if (self.recordIndicatorView != nil) {
//        [self.recordIndicatorView updateLevelMetra:metra];
//    }
//}

//MARK:-set press action
//-(void)longPress:(UILongPressGestureRecognizer *)press{
//    switch (press.state) {
//        case UIGestureRecognizerStateBegan:
//            NSLog(@"begin to record!");
//            break;
//        case UIGestureRecognizerStateChanged:
//            NSLog(@"松开手指，取消发送！");
//            break;
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
//            NSLog(@"取消发送");
//            break;
//        case UIGestureRecognizerStateFailed:
//            NSLog(@"发送失败");
//            break;
//        default:
//            break;
//    }
//}

//MARK:-获取音频ID
-(int)getSendSoundID{
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MessageOutgoing" ofType:@"aiff"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL),&soundID);
    return soundID;
}

-(int)getReceiveSoundID{
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MessageIncoming" ofType:@"aiff"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL),&soundID);
    return soundID;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end






































