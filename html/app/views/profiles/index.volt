<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Search profiles</h2>
  </div>
</div>

<form method="post" action="{{ url("profiles/search") }}" autocomplete="off">
<div class="row">
  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="id-addon">ID</span>
      </div>
      {{ form.render("id") }}
    </div>
  </div>

  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Name</span>
      </div>
      {{ form.render("name") }}
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-6">
    {{ submit_button("Search", "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ link_to("profiles/create", "Create new profile", "class":"btn btn-light form-control") }}
  </div>
</div>
</form>
