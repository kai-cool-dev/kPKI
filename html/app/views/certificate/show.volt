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
</form>
