<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Edit user</h2>
  </div>
</div>

<form method="post" autocomplete="off">
<div class="row">
  <div class="col-lg-6">
    {{ link_to("users", "Go Back", "class":"btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ submit_button("Save", "class":"btn btn-success form-control") }}
  </div>
</div>
<div class="row">
  <div class="col-lg-3">
    <div id="list-scrollspy" class="list-group">
      <a class="list-group-item list-group-item-action" href="#administration">Administration</a>
      <a class="list-group-item list-group-item-action" href="#reset-password">Reset Password</a>
      <a class="list-group-item list-group-item-action" href="#successful-logins">Successful Logins</a>
      <a class="list-group-item list-group-item-action" href="#password-changes">Password Changes</a>
    </div>
  </div>
  <div class="col-lg-9">
    <div data-spy="scroll" data-target="#list-scrollspy" data-offset="0" class="scrollspy">
      <h4 id="administration">Administration</h4>
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Name</span>
        </div>
        {{ form.render("name") }}
      </div>

      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">E-Mail</span>
        </div>
        {{ form.render("email") }}
      </div>

      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Profile</span>
        </div>
        {{ form.render("profilesId") }}
      </div>

      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Suspended</span>
        </div>
        {{ form.render("suspended") }}
      </div>

      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Banned</span>
        </div>
        {{ form.render("banned") }}
      </div>

      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Confirmed</span>
        </div>
        {{ form.render("active") }}
      </div>

      <h4 id="reset-password">Reset Passwords</h4>
      <table class="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Date</th>
            <th scope="col">Reset</th>
          </tr>
        </thead>
        <tbody>
        {% for reset in user.resetPasswords %}
        <tr>
          <th scope="row">{{ reset.id }}</th>
          <td>{{ date("Y-m-d H:i:s", reset.createdAt) }}</td>
          <td>{{ reset.reset == 'Y' ? 'Yes' : 'No' }}</td>
        </tr>
        {% else %}
        <tr><td colspan="3" align="center">User does not have requested a password reset</td></tr>
        {% endfor %}
        </tbody>
      </table>

      <h4 id="successful-logins">Successful Logins</h4>
      <table class="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">IP Address</th>
            <th scope="col">User Agent</th>
          </tr>
        </thead>
        <tbody>
        {% for login in user.successLogins %}
        <tr>
          <th scope="row">{{ login.id }}</th>
          <td>{{ login.ipAddress }}</td>
          <td>{{ login.userAgent }}</td>
        </tr>
        {% else %}
        <tr><td colspan="3" align="center">User does not have successful logins</td></tr>
        {% endfor %}
        </tbody>
      </table>
      <h4 id="password-changes">Password Changes</h4>
      <table class="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">IP Address</th>
            <th scope="col">User Agent</th>
            <th scope="col">Date</th>
          </tr>
        </thead>
        <tbody>
        {% for change in user.passwordChanges %}
        <tr>
          <th scope="row">{{ change.id }}</th>
          <td>{{ change.ipAddress }}</td>
          <td>{{ change.userAgent }}</td>
          <td>{{ date("Y-m-d H:i:s", change.createdAt) }}</td>
        </tr>
        {% else %}
        <tr><td colspan="4" align="center">User does not have password changes</td></tr>
        {% endfor %}
        </tbody>
      </table>
    </div>
  </div>
</div>
</form>
