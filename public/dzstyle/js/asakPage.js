$(function(){
	$(".Top_Nav").find("li").hover(function(){
		$(this).css("background","url(images/nv_a.png) center").css("background-position","50% 32px");;
	},function(){
		if($(this).attr('class')!='Top_NavClick'){
			$(this).css("background","none");
		}else{
			return null;
		}
	});
	
	
	$('#nameText').focus(function(){
		if($(this).val()=="UID/用户名/Email"){$(this).val('')}
	});
	$('#nameText').blur(function(){
		if($(this).val()==''){$(this).val('UID/用户名/Email')}
	});
	
	
	for(var i = 0 ;i<=$('.Cen_RmWtBotBList li').length-1;i++){
		var _thisStr = $('.Cen_RmWtBotBList li').eq(i).find('a').html();
		$('.Cen_RmWtBotBList li').eq(i).find('a').html(CatStr(_thisStr,20));
	};

	for(var i = 0; i<= $('.Cen_AskeStr').length-1;i++){
		var _thisStr = $('.Cen_AskeStr').eq(i).html();
		$('.Cen_AskeStr').eq(i).html(CatStr(_thisStr,28));
	}
	for(var i = 0; i<= $('.Cen_DaiJJWTStr').length-1;i++){
		var _thisStr = $('.Cen_DaiJJWTStr').eq(i).html();
		$('.Cen_DaiJJWTStr').eq(i).html(CatStr(_thisStr,34));
	}
	for(var i = 0; i<= $('.DLrightMold').find('dd').length-1;i++){
		var _thisStr = $('.DLrightMold').find('dd').eq(i).find('a').html();
		$('.DLrightMold').find('dd').eq(i).find('a').html(CatStr(_thisStr,20));
	}
	
	$(".asksPage_AnswerList ul li b").find('a').click(function(){
		$(this).parent().css("color","#0F0");
		$(this).parent().html("正确答案");
	});
	$('.DLleftPicText').find('p').css('width',(parseInt($('.DLleftPicText').css('width'))-parseInt($('.DLleftPicText').find('img').css('width'))-10)+"px");

	
})
