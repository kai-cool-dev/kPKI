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
      {{ form.render("authority_key_identifier") }}
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Reason</span>
        </div>
        {{ form.render("reason") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <button type="submit" class="form-control btn btn-success">Revoke</button>
    </div>
  </div>
</form>
