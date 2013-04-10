$(function(){
	var $ = jQuery,
		body = $('body');

	$('.tabs').tabs();


	$('.nav .search a, .nav .facetrace a').on('click', function(e){
		$('.popup').remove();
		var popup = $('<div class="popup"><a class="close" href="#">loka</a></div>'),
			link = $(this).attr('href');

		$.ajax({
			url: link
		}).done(function(html){
			popup.append(html);
			body.append(popup);
		});
		return false;
	});
	
	body.delegate('form', 'submit', function(e){
		var popup = $('.popup'),
			form = $(this),
			link = $(this).attr('action');

		popup.find('.content, h2').remove();

		$.ajax({
			type: "POST",
			url: link,
			data: form.serialize()
		}).done(function(html){
			popup.prepend(html);
		});
		
		form.find('input').val("");
		return false;
	});

	body.delegate('.close', 'click', function(){
		$(this).parents('.popup').remove();
	});

});