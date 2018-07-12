<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Edit profile</h2>
  </div>
</div>

<form method="post" autocomplete="off">
<div class="row">
  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="id-addon">Name</span>
      </div>
      {{ form.render("name") }}
    </div>
  </div>

  <div class="col-lg-6">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="name-addon">Active</span>
      </div>
      {{ form.render("active") }}
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-6">
    {{ submit_button("Save", "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ link_to("profiles", "Go back", "class":"btn btn-light form-control") }}
  </div>
</div>
</form>

<div class="row">
  <div class="col-lg-12">
    <h4>User in this profile:</h4>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <table class="table table-hover">
      <thead>
        <tr>
          <th scope="col">#</th>
          <th scope="col">Name</th>
          <th scope="col">Email</th>
          <th scope="col">Profile</th>
          <th scope="col">Banned</th>
          <th scope="col">Suspended</th>
          <th scope="col">Confirmed</th>
          <th scope="col" colspan="2"></th>
        </tr>
      </thead>
      <tbody>
      {% for user in profile.users %}
        <tr>
          <th scope="row">{{ user.id }}</th>
          <td>{{ user.name }}</td>
          <td>{{ user.email }}</td>
          <td>{{ user.profile.name }}</td>
          <td>{{ user.banned == 'Y' ? 'Yes' : 'No' }}</td>
          <td>{{ user.suspended == 'Y' ? 'Yes' : 'No' }}</td>
          <td>{{ user.active == 'Y' ? 'Yes' : 'No' }}</td>
          <td>{{ link_to("users/edit/" ~ user.id, 'Edit', "class": "btn btn-light form-control") }}</td>
          <td>{{ link_to("users/delete/" ~ user.id, 'Delete', "class": "btn btn-danger form-control") }}</td>
        </tr>
      {% else %}
        <tr colspan="8">
          <th>No users are recorded</th>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>
