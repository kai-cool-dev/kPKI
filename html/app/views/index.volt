<!DOCTYPE html>
<html>
	<head>
		<title>kPKI GUI</title>
		{{ stylesheet_link('css/bootstrap.min.css') }}
		{{ stylesheet_link('css/fontawesome.min.css') }}
		{{ stylesheet_link('css/style.css') }}
	</head>
	<body>

		{{ content() }}

		{{ javascript_include('js/jquery-3.3.1.min.js') }}
		{{ javascript_include('js/bootstrap.min.js') }}
		{{ javascript_include('js/app.js') }}
	</body>
</html>
