$(function(){
	var $ = jQuery,
		body = $('body');

	$('.tabs').tabs();


	$('nav a').not('.home a').on('click', function(e){
		$('.popup').remove();
		var popup = $('<div class="popup"><a class="close" href="#">loka</a></div>'),
			link = $(this).attr('href');
		var html = '<form class="search">' +
				'<label for="name">Nafn</label>' +
				'<input type="text" name="name" />' +
				'<label for="dob">Fæðingardagur</label>' +
				'<input type="date" name="dob">' +
				'<button type="submit">Leita</button>' +
				'</form>';

		/*$.ajax({
			url: link
		}).done(function(html){
			popup.append(html);
			body.append(popup);
		});*/

		popup.append(html);
		body.append(popup);
		return false;
	});

	body.delegate('.close', 'click', function(){
		$(this).parents('.popup').remove();
	});

});