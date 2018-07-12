<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Search users</h2>
  </div>
</div>

<form method="post" action="{{ url("users/search") }}" autocomplete="off">
<div class="row">
  <div class="col-lg-3">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="id-addon">ID</span>
      </div>
      {{ form.render("id") }}
    </div>
  </div>

  <div class="col-lg-3">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Name</span>
      </div>
      {{ form.render("name") }}
    </div>
  </div>

  <div class="col-lg-3">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">E-Mail</span>
      </div>
      {{ form.render("email") }}
    </div>
  </div>

  <div class="col-lg-3">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Profiles</span>
      </div>
      {{ form.render("profilesId") }}
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-6">
    {{ submit_button("Search", "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ link_to("users/create", "Create new user", "class":"btn btn-light form-control") }}
  </div>
</div>
</form>
