//
//  ViewController.m
//  RSAEncrypt
//
//  Created by ice on 2017/6/5.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "RSAEncryptManager.h"
#import "RSAEncrypt.h"
#import "RSAEncrypt+SecKey.h"

@interface ViewController ()
@property (nonatomic,strong) UITextView *textView;

/*-----------------OpenSSL----------------*/

@property (nonatomic,assign) RSA *publicKey;    // RSA 公钥
@property (nonatomic,assign) RSA *privateKey;   // RSA 私钥

@property (nonatomic,strong) NSString *privateKeyPem;
@property (nonatomic,strong) NSString *publickKeyPem;

@property (nonatomic,strong) NSString *privateKeyBase64;
@property (nonatomic,strong) NSString *publickKeyBase64;


/*-----------------SecKeyRef----------------*/
@property (nonatomic,assign) SecKeyRef privateKeyRef; // SecKey 私钥
@property (nonatomic,assign) SecKeyRef publicKeyRef;  // SecKey 公钥

@property (nonatomic,strong) NSString *originStr;   // 待加密的明文

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _originStr = @"我是明文加密我,蹂躏我吧! Hello Kity!!! 66666";
    
    [self createOpensslActionView];
    [self createSecKeyActionView];
    [self createConsoleLabel];
}

- (void)createOpensslActionView{
    NSArray *arr = @[@"生成秘钥 RSA->PEM",
                     @"私钥 PEM->Base64",
                     @"公钥 PEM->Base64",
                     @"私钥 Base64->RSA",
                     @"公钥 Base64->RSA",
                     @"模指生成公钥",
                     @"私钥加密->公钥解密",
                     @"公钥加密->私钥解密",
                     @"秘钥 Base64->SecKeyRef"];
    
    CGFloat width = 210;
    CGFloat height = 30;
    CGFloat offsetX = 10;
    CGFloat offsetY = 10;
    for (int i = 0;i < arr.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 50 + i * (height + offsetY), width, height)];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressOpensslAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)createSecKeyActionView{
    NSArray *arr = @[@"生成秘钥 REF->NSData",
                     @"读取私钥(PEM)",
                     @"读取公钥(PEM)",
                     @"模指生成公钥",
                     @"私钥加密->公钥解密",
                     @"公钥加密->私钥解密"];
    
    CGFloat width = 210;
    CGFloat height = 30;
    CGFloat offsetX = [UIScreen mainScreen].bounds.size.width - 10 - width;
    CGFloat offsetY = 10;

    for (int i = 0;i < arr.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 50 + i * (height + offsetY), width, height)];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressSecKeyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)createConsoleLabel{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat offsetY = 50 + 9 * 40;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, offsetY, size.width, size.height - offsetY)];
    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
}

- (void)pressOpensslAction:(UIButton *)btn{
    switch (btn.tag - 100) {
        case 0:{ // 生成秘钥 RSA->PEM
            [RSAEncrypt generateKeyWithSize:2048
                                 privateKey:&_privateKey
                                  publicKey:&_publicKey];
            // 生成的公钥私钥转换成PEM格式
            _privateKeyPem = [RSAEncrypt pemFormatPrivateKey:_privateKey];
            _publickKeyPem = [RSAEncrypt pemFormatPublicKey:_publicKey];
            
            NSString *logText = [NSString stringWithFormat:@"openssl 生成密钥成功！\n privateKeyPem:\n%@\n publickKeyPem:\n%@\n",_privateKeyPem,_publickKeyPem];
            [self showText:logText];
            
        }
            break;
        case 1:{ // 读取私钥 PEM->Base64
            if (!_privateKeyPem) {
                [self showText:@"请先操作 生成秘钥 RSA->PEM"];
            }else{
                _privateKeyBase64 = [RSAEncrypt base64EncodeFromPem:_privateKeyPem];
                
                NSString *logText = [NSString stringWithFormat:@"openssl 私钥 base64读取成功！\n privateBase64:\n%@\n",_privateKeyBase64];
                [self showText:logText];
            }
        }
            break;
        case 2:{ // 读取公钥 PEM->Base64
            if (!_publickKeyPem) {
                [self showText:@"请先操作 生成秘钥 RSA->PEM"];
            }else{
                _publickKeyBase64 = [RSAEncrypt base64EncodeFromPem:_publickKeyPem];
                
                NSString *logText = [NSString stringWithFormat:@"openssl 公钥 base64读取成功！\n publickBase64:\n%@\n",_publickKeyBase64];
                [self showText:logText];
            }
        }
            break;
        case 3:{// 读取私钥 Base64->RSA
            if (!_privateKeyBase64) {
                [self showText:@"请先操作 读取私钥 PEM->Base64"];
            }else{
                _privateKey = [RSAEncrypt RSAPrivateKeyFromBase64:_privateKeyBase64];
                if (_privateKey) {
                    [self showText:@"openssl 读取私钥pem成功"];
                }
            }
        }
            break;
        case 4:{// 读取公钥 Base64->PEM
            if(!_publickKeyBase64){
                [self showText:@"请先操作 读取公钥 PEM->Base64"];
            }else{
                _publicKey = [RSAEncrypt RSAPublicKeyFromBase64:_publickKeyBase64];
                if (_publicKey) {
                    [self showText:@"openssl 读取公钥pem成功"];
                }
            }
        }
            break;
        case 5:{
            
        }
            break;
        case 6:{// 私钥加密->公钥解密
            if (!_privateKey) {
                [self showText:@"请先操作 生成秘钥 RSA->PEM"];
            }else{
                //私钥加密->Base64
                NSData *plainData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptWithPrivateRSA:_privateKey plainData:plainData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                //Base64->公钥解密
                NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPublicKey:_publicKey cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                
                if (deStr && [deStr isEqualToString:_originStr]) {
                    NSString *logText = [NSString stringWithFormat:@"openssl 私钥加密->公钥解密 \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    [self showText:logText];
                }else{
                    [self showText:@"私钥加密->公钥解密 失败!!!"];
                }
            }
        }
            break;
        case 7:{// 公钥加密->私钥解密
            if (!_publicKey) {
                [self showText:@"请先操作 生成秘钥 RSA->PEM"];
            }else{
                //公钥加密->Base64
                NSData *plainData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptWithPublicKey:_publicKey plainData:plainData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                //Base64->私钥解密
                NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPrivateKey:_privateKey cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                if (deStr && [deStr isEqualToString:_originStr]){
                    NSString *logText = [NSString stringWithFormat:@"openssl 公钥加密->私钥解密 \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    
                    [self showText:logText];
                }else{
                    [self showText:@"公钥加密->私钥解密 失败!!!"];
                }
            }
        }
            break;
        case 8:{// 秘钥 Base64->SecKeyRef
            if (!_privateKeyBase64) {
                [self showText:@"请先操作 读取私钥 PEM->Base64"];
            }else{
                NSData *data = [[NSData alloc] initWithBase64EncodedString:_privateKeyBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                SecKeyRef privateKeyRef = [RSAEncrypt privateSecKeyFromKeyBits:data];
                if (privateKeyRef) {
                    NSData *newData = [RSAEncrypt privateKeyBitsFromSecKey:privateKeyRef];
                    NSString *base64 = [self base64EncodingWithData:newData];
                    if(base64 && [base64 isEqualToString:_privateKeyBase64]){
                        [self showText:@"私钥 Base64->SecKeyRef 转换成功"];
                    }
                }
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)pressSecKeyAction:(UIButton *)btn{
    switch (btn.tag - 100) {
        case 0:{// 生成秘钥 REF->NSData
            [RSAEncrypt generateSecKeyWithSize:2048
                                    privateKey:&_privateKeyRef
                                     publicKey:&_publicKeyRef];
            
            NSData *privateKeyData = [RSAEncrypt privateKeyBitsFromSecKey:_privateKeyRef];
            NSData *publicKeyData = [RSAEncrypt publicKeyBitsFromSecKey:_publicKeyRef];
            
            NSString *logText = [NSString stringWithFormat:@"SecKey 生成密钥成功!\n publicKeyData:\n%@\n privateKeyData:\n%@\n",publicKeyData,privateKeyData];
            [self showText:logText];
        }
            
            break;
        case 4:{// 私钥加密->公钥解密
            if (!_privateKeyRef) {
                [self showText:@"请先操作 生成秘钥 REF->NSData"];
            }else{
                NSData *originData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptwithPublicKeyRef:_privateKeyRef plainData:originData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPrivateKeyRef:_publicKeyRef cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                if (deStr && [deStr isEqualToString:_originStr]) {
                    NSString *logText = [NSString stringWithFormat:@"SecKey 私钥加密->公钥解密 \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    
                    [self showText:logText];
                }
            }
        }
            break;
        case 5:{// 公钥加密->私钥解密
            if(!_publicKeyRef){
                [self showText:@"请先操作 生成秘钥 REF->NSData"];
            }else{
                NSData *originData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptwithPublicKeyRef:_publicKeyRef plainData:originData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPrivateKeyRef:_privateKeyRef cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                if (deStr && [deStr isEqualToString:_originStr]) {
                    NSString *logText = [NSString stringWithFormat:@"SecKey 公钥加密->私钥解密 \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    
                    [self showText:logText];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)showText:(NSString *)text{
    NSString *logText = [NSString stringWithFormat:@"%@\n%@\n",_textView.text,text];
    _textView.text = logText;
    
    CGFloat offset = _textView.contentSize.height - _textView.bounds.size.height;
    if (offset > 0)
    {
        [_textView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}



static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)base64EncodingWithData:(NSData *)aData
{
    if ([aData length] == 0)
        return @"";
    
    char *characters = malloc((([aData length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [aData length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [aData length])
            buffer[bufferLength++] = ((char *)[aData bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
