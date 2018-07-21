<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Revoke Certificate {{ serial_number }}</h2>
  </div>
</div>

<form method="post">
  <div class="row">
    <div class="col-lg-12">
      {{ form.render("serial_number") }}
    </div>
  </div>
</form>
