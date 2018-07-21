<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Create a new user</h2>
  </div>
</div>

<form method="post" autocomplete="off">
<div class="row">
  <div class="col-lg-12">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Name</span>
      </div>
      {{ form.render("name") }}
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-8">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="email-addon">E-Mail</span>
      </div>
      {{ form.render("email") }}
    </div>
  </div>
  <div class="col-lg-4">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="profile-addon">Profile</span>
      </div>
      {{ form.render("profilesId") }}
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-6">
    {{ link_to("users", "Go Back", "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ submit_button("Save", "class": "btn btn-success form-control") }}
  </div>
</div>
</form>
