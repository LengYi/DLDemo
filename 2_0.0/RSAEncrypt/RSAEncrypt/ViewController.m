//
//  ViewController.m
//  RSAEncrypt
//
//  Created by ice on 2017/6/5.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "RSAEncrypt.h"
#import "RSAEncrypt+SecKey.h"
#import "NSString+Encrypto.h"

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
@property (nonatomic,strong) NSData *publicModData;  // 公钥模数
@property (nonatomic,strong) NSData *publicExpData;  // 公钥指数

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _originStr = @"我是明文加密我,蹂躏我吧!%#￥8*~·@ Hello Kity!!! 66666";
    
    [self createOpensslActionView];
    [self createSecKeyActionView];
    [self createConsoleLabel];
}

- (void)createOpensslActionView{
    NSArray *arr = @[@"生成秘钥 RSA->PEM",
                     @"公私钥 PEM->Base64",
                     @"公私钥 Base64->RSA",
                     @"模指生成公钥",
                     @"私钥加密->公钥解密",
                     @"公钥加密->私钥解密",];
    
    CGFloat width = 180;
    CGFloat height = 30;
    CGFloat offsetX = 10;
    CGFloat offsetY = 10;
    for (int i = 0;i < arr.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 50 + i * (height + offsetY), width, height)];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressOpensslAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)createSecKeyActionView{
    NSArray *arr = @[@"生成秘钥 REF->NSData",
                     @"秘钥 Base64->SecKeyRef",
                     @"私钥加签->公钥验签",
                     @"公钥加密->私钥解密"];
    
    CGFloat width = 180;
    CGFloat height = 30;
    CGFloat offsetX = [UIScreen mainScreen].bounds.size.width - 10 - width;
    CGFloat offsetY = 10;

    for (int i = 0;i < arr.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 50 + i * (height + offsetY), width, height)];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
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
            if (!_privateKeyPem || !_publickKeyPem) {
                [self showText:@"请先操作 生成秘钥 RSA->PEM"];
            }else{
                _privateKeyBase64 = [RSAEncrypt base64EncodeFromPem:_privateKeyPem];
                _publickKeyBase64 = [RSAEncrypt base64EncodeFromPem:_publickKeyPem];
                
                NSString *logText = [NSString stringWithFormat:@"openssl 公私钥 base64读取成功！\n privateBase64==>:\n%@\n publickBase64==>:\n%@\n",_privateKeyBase64,_publickKeyBase64];
                [self showText:logText];
            }
        }
            break;
        case 2:{// 公私钥 PEM->RSA
            if (!_privateKeyPem || !_publickKeyPem) {
                [self showText:@"请先操作 公私钥 PEM->Base64"];
            }else{
                _privateKey = [RSAEncrypt RSAPrivateKeyFromBase64:_privateKeyPem];
                if (_privateKey) {
                    [self showText:@"openssl 读取私钥pem成功"];
                }
                
                _publicKey = [RSAEncrypt RSAPublicKeyFromBase64:_publickKeyPem];
                if (_publicKey) {
                    [self showText:@"openssl 读取公钥pem成功"];
                }
            }
        }
            break;
        case 3:{// 模指生成公钥
            if (!_publicExpData || !_publicModData) {
                [self showText:@"请先操作 生成秘钥 REF->NSData"];
            }else{
                _publicKey = [RSAEncrypt publicKeyFormMod:_publicModData exp:_publicExpData];
                
                //公钥加密->Base64
                NSData *plainData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptWithPublicKey:_publicKey plainData:plainData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                //私钥解密
                 NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPrivateKeyRef:_privateKeyRef cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                
                if (deStr && [deStr isEqualToString:_originStr]) {
                    NSString *logText = [NSString stringWithFormat:@"SecKeyRef公钥 模值转换成 RSA公钥 \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    [self showText:logText];
                }else{
                    [self showText:@"SecKeyRef公钥 模值转换成 RSA公钥,  RSA公钥加密,SecKeyRef私钥解密失败!!!"];
                }
            }
        }
            break;
        case 4:{// 私钥加密->公钥解密
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
        case 5:{// 公钥加密->私钥解密
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
            
            NSData *privateData = [RSAEncrypt privateKeyBitsFromSecKey:_privateKeyRef];
            NSData *publicData = [RSAEncrypt publicKeyBitsFromSecKey:_publicKeyRef];
            
            _publicModData = [RSAEncrypt getPublicKeyMod:publicData];
            _publicExpData = [RSAEncrypt getPublicKeyExp:publicData];
            
            _privateKeyPem = [RSAEncrypt privateKeyBase64FromSecKey:_privateKeyRef];
            _publickKeyPem = [RSAEncrypt publicKeyBase64FromSecKey:_publicKeyRef];
            
            NSString *logText = [NSString stringWithFormat:@"SecKey 生成密钥成功!\n _publickKeyPem:\n%@\n _publickKeyBase64:\n%@\n",_privateKeyPem,_publickKeyPem];
            [self showText:logText];
        }
            
            break;
        case 1:{// 秘钥 Base64->SecKeyRef
            BOOL flag = false;
            if ((!_privateKeyPem || !_publickKeyPem) && flag) {
                [self showText:@"请先操作 读取私钥 PEM->Base64"];
            }else{
                // Base64秘钥->SecKeyRef格式
                NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"txt"];
                NSString *publicPath = [[NSBundle mainBundle] pathForResource:@"public" ofType:@"txt"];
                _privateKeyBase64 = [NSString stringWithContentsOfFile:privatePath encoding:NSUTF8StringEncoding error:nil];
                _publickKeyBase64 = [NSString stringWithContentsOfFile:publicPath encoding:NSUTF8StringEncoding error:nil];
//
//                _privateKeyBase64 = [[_privateKeyBase64 componentsSeparatedByString:@"-----"] objectAtIndex:2];
//                _publickKeyBase64 = [[_publickKeyBase64 componentsSeparatedByString:@"-----"] objectAtIndex:2];
                
//                NSData *privateData = [[NSData alloc] initWithBase64EncodedString:_privateKeyBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                NSData *publicData = [[NSData alloc] initWithBase64EncodedString:_publickKeyBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];

               // publicData = [self stripPublicKeyHeader:publicData];
                
                _privateKeyRef = [RSAEncrypt privateSecKeyFromBase64:_privateKeyBase64];
                //_publicKeyRef = [RSAEncrypt getPublicKeyWithMod:_publicModData exp:_publicExpData];
                _publicKeyRef = [RSAEncrypt publicSecKeyFromBase64:_publickKeyBase64];
                
                if(!_privateKeyRef){
                    NSLog(@"私钥为空");
                    return;
                }
                
                if (!_publicKeyRef) {
                    NSLog(@"公钥为空");
                    return;
                }
                
                // 公钥加密->私钥解密
                NSData *originData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *enData = [RSAEncrypt encryptwithPublicKeyRef:_publicKeyRef plainData:originData];
                NSString *enBase64Str = [enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:enBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *deData = [RSAEncrypt decryptWithPrivateKeyRef:_privateKeyRef cipherData:cipherData];
                NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
                if (deStr && [deStr isEqualToString:_originStr]) {
                    NSString *logText = [NSString stringWithFormat:@"SecKey 秘钥 Base64->SecKeyRef \n 1.原始明文:\n%@\n 2.加密结果:\n%@\n 3.解密结果:\n%@\n",_originStr,enBase64Str,deStr];
                    
                    [self showText:logText];
                }
            }
            break;
        }
        case 2:{// 私钥加签->公钥验签(SHA256)
            if (!_privateKeyRef) {
                [self showText:@"请先操作 生成秘钥 REF->NSData"];
            }else{
                NSData *originData = [_originStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *signedData = [RSAEncrypt signData:originData withKeyRef:_privateKeyRef];
                NSString *signedDataBase64Str = [signedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                BOOL very = [RSAEncrypt vertifyData:originData signature:signedData withKeyRef:_publicKeyRef];
                NSString *verStr = @"失败";
                if (very) {
                    verStr = @"成功";
                }
                
                NSString *logText = [NSString stringWithFormat:@"SecKey 私钥加签->公钥验签(SHA256) \n 1.原始明文:\n%@\n 2.加签结果:\n%@\n 3.验签结果:\n%@\n",_originStr,signedDataBase64Str,verStr];
                [self showText:logText];
            }
        }
            break;
        case 3:{// 公钥加密->私钥解密
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
    NSLog(@"%@",logText);
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


- (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    unsigned long len = [d_key length];
    if (!len) return(nil);
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    if (c_key[idx++] != 0x30) return(nil);
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    idx += 15;
    if (c_key[idx++] != 0x03) return(nil);
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    if (c_key[idx++] != '\0') return(nil);
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str    options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@end
