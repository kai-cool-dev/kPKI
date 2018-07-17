<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Show {{ cert.serial_number }}</h2>
  </div>
</div>

<form method="post" autocomplete="off">
<div class="row">
  <div class="col-lg-6">
    {{ link_to("users", "Go Back", "class":"btn btn-light form-control") }}
  </div>
  <div class="col-lg-3">
    {{ link_to("certificate/revoke/" ~ cert.serial_number, 'Revoke', "class": "btn btn-danger form-control") }}
  </div>
  <div class="col-lg-3">
    {{ submit_button("Save", "class":"btn btn-success form-control") }}
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">CA Label</span>
      </div>
      {{ form.render("ca_label") }}
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">Expiry</span>
      </div>
      <input type="text" class="form-control" disabled value="{{ cert.expiry }}">
    </div>
  </div>
</div>
</form>
<div class="row">
  <div class="col-lg-12">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">Certificate</span>
      </div>
      <textarea rows="30" class="form-control" disabled>{{ cert.pem }}</textarea>
    </div>
  </div>
</div>
