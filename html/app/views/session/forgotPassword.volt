<div class="row">
	<div class="col-lg-12">
		{{ content() }}
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h2>Forgot password?</h2>
	</div>
</div>

{{ form() }}
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
		{{ form.render('Send') }}
	</div>
</div>
</form>
