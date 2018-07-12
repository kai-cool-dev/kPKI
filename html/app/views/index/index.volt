<div class="row">
	<div class="col-lg-12">
		{{ content() }}
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<header class="jumbotron subhead" id="overview">
			<div class="hero-unit">
				<h1>Welcome!</h1>
				<p class="lead">This is the kPKI GUI with a few tools</p>
				<div align="right">
		      {{ link_to('session/login', 'Login', 'class': 'btn btn-primary form-control') }}
				</div>
			</div>
		</header>
	</div>
</div>

<div class="row">
	<div class="col-lg-6">
		<h3>What is kPKI?</h3>
		<p>kPKI is a wrapper around cfssl with a gui and user management. A permissions management is also included</p>
		<p>So here you can access your CA / Intermediate Authority and manage your server and client certificates</p>
	</div>
	<div class="col-lg-6">
		<h3>What can you do with this software?</h3>
		<p>You can use kPKI for managing your OpenVPN Client Certificates (Export Tool is WIP), your internal server certificates (for your intranet), just for everything you need a CA!</p>
	</div>
</div>

<div class="row">
	<div class="col-lg-6">
		<h3>Who made that crap?</h3>
		<p>I made this software by myself (<a href="https://www.kai.cool" target="_blank">Kai Pazdzewicz</a>) in my spare time, because I needed an internal ca.</p>
	</div>
	<div class="col-lg-6">
		<h3>What are the components of this software?</h3>
		<p>I use the Phalcon PHP Framework and CFSSL as a daemon. CFSSL is great because it offers a handy dandy client, so this software is heavily based on CFSSL.</p>
	</div>
</div>
