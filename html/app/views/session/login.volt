<div class="row">
	<div class="col-lg-12">
		{{ content() }}
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h2>Login</h2>
	</div>
</div>

{{ form('class': 'form-search') }}
<div class="row">
	<div class="col-lg-6">
		<div class="input-group mb-3">
		  <div class="input-group-prepend">
		    <span class="input-group-text" id="basic-addon1">E-Mail</span>
		  </div>
	  	{{ form.render('email') }}
		</div>
	</div>
	<div class="col-lg-6">
		<div class="input-group mb-3">
			<div class="input-group-prepend">
				<span class="input-group-text" id="basic-addon1">Password</span>
			</div>
			{{ form.render('password') }}
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		{{ form.render('remember') }}
		{{ form.label('remember') }}
	</div>
</div>

<div class="row">
	<div class="col-lg-4">
		{{ link_to("session/forgotPassword", "Forgot my password", 'class':'btn btn-light form-control') }}
	</div>
	<div class="col-lg-8">
		{{ form.render('Login') }}
	</div>
</div>

{{ form.render('csrf', ['value': security.getToken()]) }}
</form>




		<hr>

		<div class="forgot">

		</div>



</div>
