<div class="row">
  <div class="col-lg-12">
    {{ content() }}
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
    {% for user in page.items %}
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
<div class="row">
  <div class="col-lg-2">
    {{ link_to("users/search", 'First', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("users/search?page=" ~ page.before, 'Previous', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-4">
    <p class="btn form-control">{{ page.current }}/{{ page.total_pages }}</p>
  </div>
  <div class="col-lg-2">
    {{ link_to("users/search?page=" ~ page.next, 'Next', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("users/search?page=" ~ page.last, 'Last', "class": "btn btn-light form-control") }}
  </div>
</div>
<div class="row">
  <div class="col-lg-6">
    {{ link_to("users/index", "Back to search", "class":"btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ link_to("users/create", "Create new user", "class":"btn btn-light form-control") }}
  </div>
</div>
