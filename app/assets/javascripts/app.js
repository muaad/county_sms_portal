(function() {
	var app = angular.module('sms', []);

	app.controller('ContactsController', ['http', function($http) {
		var x = this;
		x.contacts = [];
		$http.get('/contacts.json').succes(function(data) {
			x.contacts = data;
		})
	}]);
})();