smooth=0;
w_x=0;
function RenderLoadingBar_Standard(_graphics, _width, _height, _total, _current, _loadingscreen) {
	var canvasobj = document.getElementById("loading_screen");
	var room_width  = _width;
	var room_height = _height;
	var ratio = (room_height/room_width);
	if (typeof(window.innerWidth)=='number') {
		browser_width = window.innerWidth;
		browser_height = window.innerHeight;
	} else if (document.documentElement&&document.documentElement.clientWidth) {
		browser_width = document.documentElement.clientWidth;
		browser_height = document.documentElement.clientHeight;
	} else if (document.body&&document.body.clientWidth) {
		browser_width = document.body.clientWidth;
		browser_height = document.body.clientHeight;
	}
	var multi = (browser_height / room_height);
	var new_width = (room_width * multi);
	var new_height = browser_height;
	if (new_width > browser_width) {
		multi = (browser_width / room_width);
		new_width = (room_width * multi);
		new_height = (room_height * multi);
	}
	canvasobj.width = new_width;
	canvasobj.height = new_height;
	canvasobj.style.left = browser_width/2-new_width/2+"px";
	canvasobj.style.top = browser_height/2-new_height/2+"px";
	if (_loadingscreen) {
		_graphics.drawImage(_loadingscreen, 0, 0, new_width, new_height);
		if (_loadingscreen.style.display == "block") {
			_loadingscreen.style.display = "none";
		}
	}
	
	var progress=(_current/_total)*100;
	if (progress<100)
	{
	if (smooth<progress)
	{
	smooth+=1;
	}
	}
	else
	{
	smooth=100;
	}
	if (w_x<360)
	{
	w_x+=0.0005;
	}
	else
	{
	w_x=0;
	}
	var perc = (bar_img_w/100)*smooth;
	var bar_x = bar_img_x*multi;
	var bar_y = bar_img_y*multi;
	var bar_w = perc*multi;
	var bar_h = bar_img_h*multi;
	var wx_real = w_x * (180 / Math.PI);
	var water_x=(water_img_x+20*sin(wx_real))*multi;
	var water_y=water_img_y*multi;
	var water_h=water_img_h*multi;
	var water_w=water_img_w*multi;
	//var jelly_x = bar_x+bar_w-55*multi;
	//var jelly_y = (bar_img_y-10)*multi;
	//var jelly_h = jelly_img_h*multi;
	//var jelly_w = jelly_img_w*multi;
	var yy = 277 * multi;
	var ww = 93 * multi;
	if (_current != 0) {
		if (loadbarobj) {
			_graphics.drawImage(loadbarobj, 0, 0, perc, bar_img_h, bar_x, bar_y, bar_w, bar_h);
			
		}

	}
	//_graphics.drawImage(jellyobj, jelly_x, jelly_y, jelly_w, jelly_h);
	_graphics.drawImage(water, water_x, water_y, water_w, water_h);
}