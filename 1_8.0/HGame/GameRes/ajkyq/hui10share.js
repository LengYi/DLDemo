window.shareGame = function (_o) {
        var o = eval('(' + _o + ')');
        console.log(myScore);
        var u = '/ajkyq/',
            n = '爱就块一起',
            i = o.i || '/gameshare.png',
            s = myScore,
            p = gamep,
            stxt = '通过了第' + s + '关';
            f = o.f;
        
        var _des = '';
        if(s && (p || p === 0)) {
            // _des = '我在' + n + '游戏中得了' + s + '分，击败全国' + p + '%的人';
            _des = '我在' + n + '游戏中' + stxt + '，击败蜜兔' + p + '%的人，快来挑战我吧！';
        } else if (s && !p) {
            _des = '我在' + n + '游戏中' + stxt + '，快来挑战我吧！';
        } else if (!s && p) {
            // _des = '我在' + n + '游戏中，击败了全国' + p + '%的人，快来挑战我吧！';
            // _des = '我在' + n + '游戏中，击败了全国' + p + '%的人，快来挑战我吧！';
            _des = '我在玩' + n + '，就差你了, 快来陪我一起玩吧！';
        } else {
            _des = '我在玩' + n + '，就差你了, 快来陪我一起玩吧！';
        }

        var params = {
            url: // 'http://www.hui10games.com/gameshare?'
                 'http://game.webtest.hui10.com/gameshare?'
                    /*+ 'u=' + u
                    + '&n=' + n
                    + '&i=' + i
                    + '&s=' + s
                    + '&stxt=' + stxt
                    + '&p=' + p
                    + '&f=' + f*/
                    + 'u=' + encodeURIComponent(u)
                    + '&n=' + encodeURIComponent(n) 
                    + '&i=' + encodeURIComponent(i) 
                    + '&s=' + encodeURIComponent(s)
                    + '&stxt=' + encodeURIComponent(stxt)
                    + '&p=' + encodeURIComponent(p) 
                    + '&f=' + encodeURIComponent(f)
            ,
            icon: 'http://game.webtest.hui10.com/gameshare.png',
            des: _des,
            title: n
        }

        if (window.injs) {
            if (JSON.stringify) {
                window.injs.runOnAndroidJavaScript(JSON.stringify(params));
                // window.changeScreenOrientation('false');
            } else {

            }
        }
        if (window.BeginShare) {
            if (JSON.stringify) {
                window.BeginShare(JSON.stringify(params));
            } else {

            }
        }
        // console.log(decodeURIComponent(params.des));
        console.log(params.des);
        var ua = navigator.userAgent.toLowerCase();	
        if (/iphone|ipad|ipod/.test(ua)) {
            return JSON.stringify(params);
        } else if (/android/.test(ua)) {

        } else {
            
        }
    }
