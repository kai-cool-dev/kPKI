<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<form method="post" autocomplete="off" action="{{ url("users/changePassword") }}">
<div class="row">
  <div class="col-lg-12">
    <h2>Change Password</h2>
  </div>
  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="pw-addon1">New Password</span>
      </div>
      <input type="password" class="form-control" aria-describedby="pw-addon1">
    </div>
  </div>
  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="pw-addon1">Repeat new Password</span>
      </div>
      <input type="password" class="form-control" aria-describedby="pw-addon1">
    </div>
  </div>
  <div class="col-lg-12">
    {{ submit_button("Change Password", "class": "btn btn-light form-control") }}
  </div>
</div>
</form>
