window.gameResult = function () {
  var str = '';
  if (myScore == 0) {
    str = '中途退出了游戏';
  }
  if(myScore > 0 ) {
    str = '我在《爱就块一起》游戏中通过了第' + myScore + '关';
  }
  if (window.injs) {
    window.injs.returnPKGrade(JSON.stringify(str));
  }
  return str;
};
