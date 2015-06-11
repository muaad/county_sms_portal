$(function() {
	if (window.location.href.includes("conversations")) {
		var source = new EventSource("/messages/events")
		source.addEventListener('message', function(e) {
			var message = $.parseJSON(e.data);
			var msg = '<div class="room-box"><h5 class="text-primary">  <a href="#">    Nairobi  </a></h5><p>' + message.text + '</p></div>'
			$('.view-mail').append(msg);
			$('.view-mail').scrollTop($('.view-mail')[0].scrollHeight);
			// $(".view-mail").animate({ scrollTop: $('.view-mail')[0].scrollHeight}, 1000);
		})


		// $(".view-mail").animate({ scrollTop: $('.view-mail')[0].scrollHeight}, 1000);
		$('.view-mail').scrollTop($('.view-mail')[0].scrollHeight);
		$('#send-button').click(function() {
			var message = $('#txt-area').val();
			var phone = $('#phone').val();
			var msg = '<div class="room-box"><h5 class="text-primary">  <a href="#">    Nairobi  </a></h5><p>' + message + '</p></div>'

			$('.view-mail').append(msg);
			$('#txt-area').val("");
			$('.view-mail').scrollTop($('.view-mail')[0].scrollHeight);

			$.ajax({
			  type: "POST",
			  url: '/outgoing',
			  dataType: 'json',
			  data: {phone_number: phone, message: message},
			  success: function(data, textStatus, jqXhr) {
			    // $('.view-mail').append(msg);
			    // $('#txt-area').val("");
			    // $('.view-mail').scrollTop($('.view-mail')[0].scrollHeight);
			    // $(".view-mail").animate({ scrollTop: $('.view-mail')[0].scrollHeight}, 1000);
			  },
			  error: function (request, status, error) {
			    console.log(request.responseText);
			  }
			});
		})

		$('#txt-area').keypress(function(e) {
			if (e.which == 13) {
				e.preventDefault();
				$('#send-button').click();
			};
		})
	}

	$('.favorite').click(function() {
		var contact = $(this).data('contact');
		var star = $(this);
		console.log(contact);
		$.ajax({
			type: "POST",
			url: "/toggle_favorite",
			dataType: "json",
			data: {contact: contact},
			success: function(data) {
				if (data.status) {
					star.addClass('starred');
				}
				else {
					star.removeClass('starred');
				}
			}
		});
	})
});
