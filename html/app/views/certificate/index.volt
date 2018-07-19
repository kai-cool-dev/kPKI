<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Search certificates</h2>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <p>You can search for certificates, you can leave all fields blank to list all certificates</p>
  </div>
</div>

<form method="post" action="{{ url("certificate/search") }}" autocomplete="off">
<div class="row">
  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="id-addon">Serial Number</span>
      </div>
      {{ form.render("serial_number") }}
    </div>
  </div>

  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Label</span>
      </div>
      {{ form.render("ca_label") }}
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    {{ submit_button("Search", "class": "btn btn-success form-control") }}
  </div>
</div>
</form>
